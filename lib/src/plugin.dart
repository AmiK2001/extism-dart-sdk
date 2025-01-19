import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_sdk/extism.dart';
import 'package:dart_sdk/src/extism_exception.dart';
import 'package:dart_sdk/src/host_function.dart';
import 'package:dart_sdk/src/lib_extism.dart';
import 'package:dart_sdk/src/log_level.dart';
import 'package:ffi/ffi.dart';
import 'package:uuid/uuid.dart';

// Define a global variable to hold the loaded dynamic library
DynamicLibrary? _dylib;

// Helper function to get the dynamic library
DynamicLibrary _loadLibrary() {
  _dylib ??= Platform.isAndroid
      ? DynamicLibrary.open("libextism.so")
      : (Platform.isIOS || Platform.isMacOS)
          ? DynamicLibrary.open("libextism.dylib")
          : DynamicLibrary.open("extism.dll");
  return _dylib!;
}

final extism = LibExtism(_loadLibrary());

/// Represents a WASM Extism plugin.
class Plugin {
  static const _disposedMarker = 1;
  int _disposed = 0;

  late final Pointer<ExtismPlugin> _nativeHandle;
  final List<HostFunction> _functions;
  late final Pointer<ExtismCancelHandle> _cancelHandle;

  static LoggingSink? _logCallback;

  static late Pointer<NativeFunction<ExtismLogDrainFunctionTypeFunction>>?
      _logCallbackPointer;

  static void _logCallbackWrapper(Pointer<Char> data, int size) {
    if (_logCallback != null) {
      final message = data.cast<Utf8>().toDartString();
      _logCallback!.call(message);
    }
  }

  /// Initialize a plugin from a Manifest.
  Plugin(
    ManifestEntity manifest,
    this._functions,
    PluginInitializationOptions options,
  ) {
    withZoneArena(() {
      final bytes = manifest.bytes();

      final wasmPtr = calloc<Uint8>(bytes.length);
      wasmPtr.asTypedList(bytes.length).setAll(0, bytes);

      final functionHandles = _functions.map((f) => f.nativeHandle).toList();
      final functionsPtr =
          calloc<Pointer<ExtismFunction>>(functionHandles.length);
      for (var i = 0; i < functionHandles.length; i++) {
        functionsPtr[i] = functionHandles[i].cast();
      }

      final errorMsgPtrOut = calloc<Pointer<Char>>();

      if (options.fuelLimit == null) {
        _nativeHandle = extism.extism_plugin_new(
          wasmPtr,
          bytes.length,
          functionsPtr,
          _functions.length,
          options.withWasi,
          errorMsgPtrOut,
        );
      } else {
        _nativeHandle = extism.extism_plugin_new_with_fuel_limit(
          wasmPtr,
          bytes.length,
          functionsPtr,
          _functions.length,
          options.withWasi,
          options.fuelLimit!,
          errorMsgPtrOut,
        );
      }

      if (_nativeHandle == nullptr) {
        final errorMsgPtr = errorMsgPtrOut.value;
        String? msg;
        if (errorMsgPtr != nullptr) {
          msg = errorMsgPtr.cast<Utf8>().toDartString();
        }

        throw Exception(msg ?? "Unknown error during plugin creation");
      }

      _cancelHandle = extism.extism_plugin_cancel_handle(_nativeHandle);
    });
  }

  /// Instantiate a plugin from a compiled plugin.
  Plugin.fromCompiled(CompiledPlugin plugin) : _functions = plugin.functions {
    withZoneArena(() {
      final errorMsgPtrOut = calloc<Pointer<Char>>();
      _nativeHandle = extism.extism_plugin_new_from_compiled(
        plugin._nativeHandle,
        errorMsgPtrOut,
      );

      if (_nativeHandle == nullptr) {
        final errorMsgPtr = errorMsgPtrOut.value;
        String? msg;
        if (errorMsgPtr != nullptr) {
          msg = errorMsgPtr.cast<Utf8>().toDartString();
        }

        throw Exception(msg ?? "Unknown error during plugin instantiation");
      }

      _cancelHandle = extism.extism_plugin_cancel_handle(_nativeHandle);
    });
  }

  /// Create a plugin from a Manifest.
  Plugin.initWithManifest({
    required ManifestEntity manifest,
    List<HostFunction>? functions,
    required bool withWasi,
  }) : this(
          manifest,
          functions ?? [],
          PluginInitializationOptions(withWasi: withWasi),
        );

  /// Create and load a plugin from a byte array.
  Plugin.fromBytes(List<int> wasm, List<HostFunction> functions, bool withWasi)
      : _functions = functions {
    withZoneArena(() {
      final wasmPtr = calloc<Uint8>(wasm.length);
      wasmPtr.asTypedList(wasm.length).setAll(0, wasm);

      final functionHandles = functions.map((f) => f.nativeHandle).toList();
      final functionsPtr =
          calloc<Pointer<ExtismFunction>>(functionHandles.length);
      for (var i = 0; i < functionHandles.length; i++) {
        functionsPtr[i] = functionHandles[i].cast();
      }

      final errorMsgPtrOut = calloc<Pointer<Char>>();
      _nativeHandle = extism.extism_plugin_new(
        wasmPtr,
        wasm.length,
        functionsPtr,
        functions.length,
        withWasi,
        errorMsgPtrOut,
      );

      if (_nativeHandle == nullptr) {
        final errorMsgPtr = errorMsgPtrOut.value;
        String? msg;
        if (errorMsgPtr != nullptr) {
          msg = errorMsgPtr.cast<Utf8>().toDartString();
        }

        throw Exception(
          msg ?? "Unknown error during plugin creation from bytes",
        );
      }

      _cancelHandle = extism.extism_plugin_cancel_handle(_nativeHandle);
    });
  }

  /// Get the plugin's ID.
  ///
  /// Returns a Uuid representing the plugin ID.
  UuidValue get id {
    _checkNotDisposed();
    final idPtr = extism.extism_plugin_id(_nativeHandle);
    final byteList =
        Uint8List.fromList(List.generate(16, (index) => idPtr[index]));

    return UuidValue.fromByteList(byteList);
  }

  /// Reset the Extism runtime.
  ///
  /// This will invalidate all allocated memory.
  ///
  /// Returns `true` if successful, `false` otherwise.
  bool reset() {
    _checkNotDisposed();
    return extism.extism_plugin_reset(_nativeHandle);
  }

  /// Update plugin config values.
  ///
  /// This will merge with the existing values.
  ///
  /// Returns `true` if successful, `false` otherwise.
  bool updateConfig(Map<String, String> config) {
    _checkNotDisposed();
    final json = jsonEncode(config);
    final bytes = utf8.encode(json);

    return withZoneArena(() {
      final jsonPtr = calloc<Uint8>(bytes.length);
      jsonPtr.asTypedList(bytes.length).setAll(0, bytes);
      final success =
          extism.extism_plugin_config(_nativeHandle, jsonPtr, bytes.length);
      return success;
    });
  }

  /// Checks if a specific function exists in the current plugin.
  bool functionExists(String name) {
    _checkNotDisposed();

    return withZoneArena(() {
      final namePtr = name.toNativeUtf8();
      final exists =
          extism.extism_plugin_function_exists(_nativeHandle, namePtr.cast());
      return exists;
    });
  }

  /// Calls a function in the current plugin and returns the output as a byte buffer.
  List<int> call(String functionName, List<int> input) {
    _checkNotDisposed();

    return withZoneArena(() {
      final Pointer<Uint8> dataPtr = calloc<Uint8>(input.length);
      dataPtr.asTypedList(input.length).setAll(0, input);

      final functionNamePtr = functionName.toNativeUtf8();

      final rc = extism.extism_plugin_call(
        _nativeHandle,
        functionNamePtr.cast(),
        dataPtr,
        input.length,
      );

      final errorMsg = getError();
      if (errorMsg != null) {
        throw ExtismException("$errorMsg. Exit Code: $rc");
      }

      return outputData();
    });
  }

  /// Calls a function in the current plugin and returns the output as a UTF8 encoded string.
  String callString(String functionName, String input) {
    final inputBytes = utf8.encode(input);
    final outputBytes = call(functionName, inputBytes);
    return utf8.decode(outputBytes);
  }

  /// Get the length of a plugin's output data.
  int _outputLength() {
    _checkNotDisposed();
    return extism.extism_plugin_output_length(_nativeHandle);
  }

  /// Get the plugin's output data.
  List<int> outputData() {
    _checkNotDisposed();
    final length = _outputLength();
    final ptr = extism.extism_plugin_output_data(_nativeHandle);
    return List.generate(length, (index) => ptr[index]);
  }

  /// Get the error associated with the current plugin.
  String? getError() {
    _checkNotDisposed();
    final ptr = extism.extism_plugin_error(_nativeHandle);
    if (ptr == nullptr) {
      return null;
    }
    return ptr.cast<Utf8>().toDartString();
  }

  /// Frees all resources held by this Plugin.
  void dispose() {
    if (_disposed == _disposedMarker) {
      return;
    }
    _dispose(true);
    _disposed = _disposedMarker;
  }

  /// Throw an appropriate exception if the plugin has been disposed.
  void _checkNotDisposed() {
    if (_disposed == _disposedMarker) {
      _throwDisposedException();
    }
  }

  void _throwDisposedException() {
    throw StateError("Plugin has been disposed.");
  }

  /// Frees all resources held by this Plugin.
  void _dispose(bool disposing) {
    if (disposing) {
      // Free up any managed resources here
    }

    extism.extism_plugin_free(_nativeHandle);
  }

  /// Get Extism Runtime version.
  static String get extismVersion {
    return extism.extism_version().cast<Utf8>().toDartString();
  }

  /// Set log file and level
  static void setLogFile(String path, LogLevel level) {
    withZoneArena(() {
      final pathPtr = path.toNativeUtf8();
      final levelPtr = enumToPtr(level);
      extism.extism_log_file(pathPtr.cast(), levelPtr.cast());
    });
  }

  /// Enable custom logging. This configures Extism to send log messages to
  /// the specified callback function. The plugin must be initialized for this to
  /// take effect.
  void setLogCallback(LoggingSink callback, LogLevel level) {
    withZoneArena(() {
      final levelPtr = enumToPtr(level);
      extism.extism_log_custom(levelPtr);
    });

    _logCallback = (String message) {
      callback(message);
    };

    _logCallbackPointer = Pointer.fromFunction(_logCallbackWrapper);
  }

  /// Calls the provided callback function for each buffered log line.
  ///
  /// This is only needed when `extism_log_custom` is used.
  void logDrain(LoggingSink callback) {
    _logCallback = (String message) {
      callback(message);
    };

    _logCallbackPointer = Pointer.fromFunction(_logCallbackWrapper);
    extism.extism_log_drain(_logCallbackPointer!);
  }
}

/// Set log file and level
///
/// Options for initializing a plugin.
class PluginInitializationOptions {
  /// Enable WASI support.
  bool withWasi;

  /// Limits the number of instructions that can be executed by the plugin.
  int? fuelLimit;

  PluginInitializationOptions({this.withWasi = false, this.fuelLimit});
}

/// Custom logging callback.
typedef LoggingSink = void Function(String line);

/// A pre-compiled plugin ready to be instantiated.
class CompiledPlugin {
  static const _disposedMarker = 1;
  int _disposed = 0;

  late final Pointer<ExtismCompiledPlugin> _nativeHandle;

  final ManifestEntity manifest;
  List<HostFunction> functions;
  final bool withWasi;

  /// Compile a plugin from a Manifest.
  CompiledPlugin({
    required this.manifest,
    required this.functions,
    required this.withWasi,
  }) {
    withZoneArena(() {
      final bytes = manifest.bytes();

      final wasmPtr = calloc<Uint8>(bytes.length);
      wasmPtr.asTypedList(bytes.length).setAll(0, bytes);

      // Convert the list of HostFunction to a Pointer<Pointer<Void>>
      final functionHandles = functions.map((f) => f.nativeHandle).toList();
      final functionsPtr =
          calloc<Pointer<ExtismFunction>>(functionHandles.length);
      for (var i = 0; i < functionHandles.length; i++) {
        functionsPtr[i] = functionHandles[i];
      }

      final errorMsgPtrOut = calloc<Pointer<Char>>();

      _nativeHandle = extism.extism_compiled_plugin_new(
        wasmPtr,
        bytes.length,
        functionsPtr,
        functions.length,
        withWasi,
        errorMsgPtrOut,
      );

      // Check for errors
      if (_nativeHandle == nullptr) {
        final errorMsgPtr = errorMsgPtrOut.value;
        String? msg;
        if (errorMsgPtr != nullptr) {
          msg = errorMsgPtr.cast<Utf8>().toDartString();
        }
        throw Exception(msg ?? "Unknown error during plugin compilation");
      }
    });
  }

  /// Instantiate a plugin from this compiled plugin.
  Plugin instantiate() {
    _checkNotDisposed();
    return Plugin(
      manifest,
      functions,
      PluginInitializationOptions(
        withWasi: withWasi,
      ),
    );
  }

  /// Frees all resources held by this Plugin.
  void dispose() {
    if (_disposed == _disposedMarker) {
      // Already disposed.
      return;
    }

    _dispose(true);
    _disposed = _disposedMarker;
  }

  /// Throw an appropriate exception if the plugin has been disposed.
  void _checkNotDisposed() {
    if (_disposed == _disposedMarker) {
      _throwDisposedException();
    }
  }

  void _throwDisposedException() {
    throw StateError("CompiledPlugin has been disposed.");
  }

  /// Frees all resources held by this Plugin.
  void _dispose(bool disposing) {
    if (disposing) {
      // Free up any managed resources here
    }

    extism.extism_compiled_plugin_free(_nativeHandle);
  }
}
