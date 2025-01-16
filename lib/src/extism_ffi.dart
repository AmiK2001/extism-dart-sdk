import 'dart:ffi';

import 'package:dart_sdk/src/extism_exception.dart';
import 'package:dart_sdk/src/lib_extism.dart';
import 'package:dart_sdk/src/utils.dart';
import 'package:ffi/ffi.dart';

class ExtismFFI {
  final DynamicLibrary dynamicLibrary;
  late final LibExtism _libExtism;

  ExtismFFI({
    required this.dynamicLibrary,
  }) {
    _libExtism = LibExtism(dynamicLibrary);
  }

  /// Get the Extism version string
  String extismVersion() {
    return _libExtism.extism_version().toDartString();
  }

  /// Create a new plugin with host functions, the functions passed to this function no longer need to be manually freed using
  ///
  /// `wasm`: is a WASM module (wat or wasm) or a JSON encoded manifest
  /// `wasm_size`: the length of the `wasm` parameter
  /// `functions`: an array of `ExtismFunction*`
  /// `n_functions`: the number of functions provided
  /// `with_wasi`: enables/disables WASI
  Pointer<ExtismPlugin> extismPluginNew(
    Allocator allocator,
    List<int> wasm,
    List<Pointer<ExtismFunction>> functions,
    bool withWasi,
  ) {
    return withZoneArena(
      () {
        final wasmPointer = wasm.toNativeUint8List(allocator);
        final functionsPointer = functions.toNativePointerList(allocator);
        final errmsgPointer = allocator<Pointer<Char>>();

        final plugin = _libExtism.extism_plugin_new(
          wasmPointer,
          wasm.length,
          functionsPointer,
          functions.length,
          withWasi,
          errmsgPointer,
        );

        if (errmsgPointer.value != nullptr) {
          final error = errmsgPointer.value.toDartString();

          throw ExtismException(error);
        }

        return plugin;
      },
      allocator,
    );
  }

  /// Free `ExtismPlugin`
  void extismPluginFree(Pointer<ExtismPlugin> plugin) {
    return _libExtism.extism_plugin_free(plugin);
  }

  /// Call a function
  ///
  /// `func_name`: is the function to call
  /// `data`: is the input data
  /// `data_len`: is the length of `data`
  int extismPluginCall(
    Allocator allocator,
    Pointer<ExtismPlugin> plugin,
    String funcName,
    List<int> data,
  ) {
    return withZoneArena(
      () {
        final funcNamePointer = funcName.toNativeUtf8(allocator: allocator);
        final dataPointer = data.toNativeUint8List(allocator);

        return _libExtism.extism_plugin_call(
          plugin,
          funcNamePointer.cast(),
          dataPointer,
          data.length,
        );
      },
      allocator,
    );
  }

  /// Get a pointer to the output data
  Pointer<Uint8> extismPluginOutputData(
    Pointer<ExtismPlugin> plugin,
  ) {
    return _libExtism.extism_plugin_output_data(plugin);
  }

  /// Get the length of a plugin's output data
  int extismPluginOutputLength(
    Pointer<ExtismPlugin> plugin,
  ) {
    return _libExtism.extism_plugin_output_length(plugin);
  }

  /// Get the error associated with a `Plugin`
  String extismPluginError(
    Pointer<ExtismPlugin> plugin,
  ) {
    return _libExtism.extism_plugin_error(plugin).toDartString();
  }
}
