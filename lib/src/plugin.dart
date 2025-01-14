import 'dart:ffi';
import 'dart:io';

import 'package:dart_sdk/extism.dart';
import 'package:dart_sdk/src/extism_exception.dart';
import 'package:ffi/ffi.dart';

DynamicLibrary loadExtismLibrary() {
  final libraryPath = _findLibraryPath();
  return DynamicLibrary.open(libraryPath);
}

String _findLibraryPath() {
  const binariesFolder = 'libs';

  if (Platform.isLinux) {
    return '$binariesFolder/linux/libextism.so';
  } else if (Platform.isMacOS) {
    return '$binariesFolder/macos/libextism.dylib';
  } else if (Platform.isWindows) {
    return '$binariesFolder/windows/extism.dll';
  } else if (Platform.isAndroid) {
    return _findAndroidLibrary();
  } else {
    throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
  }
}

final extism = LibExtism(loadExtismLibrary());

String _findAndroidLibrary() {
  // Detect the CPU architecture of the Android device
  final abi = Platform.environment['ANDROID_RUNTIME_ABI'] ??
      (Platform.environment['HOSTTYPE'] ?? 'unknown');

  if (abi.contains('arm') && !abi.contains('64')) {
    return 'binaries/android/armeabi-v7a/libextism.so';
  } else if (abi.contains('arm64')) {
    return 'binaries/android/arm64-v8a/libextism.so';
  } else if (abi.contains('x86') && !abi.contains('64')) {
    return 'binaries/android/x86/libextism.so';
  } else if (abi.contains('x86_64')) {
    return 'binaries/android/x86_64/libextism.so';
  } else {
    throw UnsupportedError('Unsupported Android ABI: $abi');
  }
}

// Exposed FFI Functions
String extismVersion() => extism.extism_version().toDartString();

Pointer<ExtismPlugin> extismPluginNew(
  Allocator allocator,
  List<int> wasm,
  List<Pointer<ExtismFunction>> functions,
  bool withWasi,
) {
  final wasmPointer = wasm.toNativeUint8List(allocator);
  final functionsPointer = functions.toNativePointerList(allocator);
  final errmsgPointer = allocator<Pointer<Char>>();

  final plugin = extism.extism_plugin_new(
    wasmPointer,
    wasm.length,
    functionsPointer,
    functions.length,
    withWasi,
    errmsgPointer,
  );

  allocator.free(wasmPointer);
  allocator.free(functionsPointer);

  if (errmsgPointer.value != nullptr) {
    final error = errmsgPointer.value.toDartString();
    allocator.free(errmsgPointer.value);
    throw ExtismException(error);
  }

  allocator.free(errmsgPointer);
  return plugin;
}

void extismPluginFree(Pointer<ExtismPlugin> plugin) {
  extism.extism_plugin_free(plugin);
}

int extismPluginCall(
  Allocator allocator,
  Pointer<ExtismPlugin> plugin,
  String funcName,
  List<int> data,
) {
  final funcNamePointer = funcName.toNativeUtf8(allocator: allocator);
  final dataPointer = data.toNativeUint8List(allocator);

  final result = extism.extism_plugin_call(
    plugin,
    funcNamePointer.cast(),
    dataPointer,
    data.length,
  );

  allocator.free(funcNamePointer);
  allocator.free(dataPointer);

  return result;
}

Pointer<Uint8> extismPluginOutputData(
  Pointer<ExtismPlugin> plugin,
) {
  final result = extism.extism_plugin_output_data(plugin);

  return result;
}

int extismPluginOutputLength(
  Pointer<ExtismPlugin> plugin,
) {
  final result = extism.extism_plugin_output_length(plugin);

  return result;
}

Pointer<Char> extismPluginError(
  Pointer<ExtismPlugin> plugin,
) {
  final result = extism.extism_plugin_error(plugin);

  return result;
}

class Plugin {
  Plugin({
    required bool withWasi,
    required ManifestEntity manifest,
  }) {
    final bytes = manifest.bytes();
    _pluginPointer = extismPluginNew(_allocator, bytes, [], withWasi);
  }

  final _allocator = calloc;
  late final Pointer<ExtismPlugin> _pluginPointer;

  void dispose() {
    extismPluginFree(_pluginPointer);
  }

  List<int> call(String functionName, List<int> inputData) {
    try {
      // Call function
      final resultCode = extismPluginCall(
        _allocator,
        _pluginPointer,
        functionName,
        inputData,
      );

      // Check result
      if (resultCode != 0) {
        final errorPointer = extismPluginError(_pluginPointer);
        final errorMessage = errorPointer.toDartString();
        throw ExtismException(errorMessage);
      }

      // Retrieve output
      final outputSize = extismPluginOutputLength(_pluginPointer);
      final outputPointer = extismPluginOutputData(_pluginPointer);

      return outputPointer.asTypedList(outputSize);
    } on Object catch (e) {
      throw ExtismException(e.toString());
    }
  }
}
