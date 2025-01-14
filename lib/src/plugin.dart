import 'dart:ffi';

import 'package:dart_sdk/extism.dart';
import 'package:dart_sdk/src/extism_exception.dart';
import 'package:ffi/ffi.dart';

class ExtismFFI {
  final DynamicLibrary dynamicLibrary;
  late final LibExtism _libExtism;

  ExtismFFI({
    required this.dynamicLibrary,
  }) {
    _libExtism = LibExtism(dynamicLibrary);
  }

  String extismVersion() => _libExtism.extism_version().toDartString();

  Pointer<ExtismPlugin> extismPluginNew(
    Allocator allocator,
    List<int> wasm,
    List<Pointer<ExtismFunction>> functions,
    bool withWasi,
  ) {
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
    _libExtism.extism_plugin_free(plugin);
  }

  int extismPluginCall(
    Allocator allocator,
    Pointer<ExtismPlugin> plugin,
    String funcName,
    List<int> data,
  ) {
    final funcNamePointer = funcName.toNativeUtf8(allocator: allocator);
    final dataPointer = data.toNativeUint8List(allocator);

    final result = _libExtism.extism_plugin_call(
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
    final result = _libExtism.extism_plugin_output_data(plugin);

    return result;
  }

  int extismPluginOutputLength(
    Pointer<ExtismPlugin> plugin,
  ) {
    final result = _libExtism.extism_plugin_output_length(plugin);

    return result;
  }

  Pointer<Char> extismPluginError(
    Pointer<ExtismPlugin> plugin,
  ) {
    final result = _libExtism.extism_plugin_error(plugin);

    return result;
  }
}

class Plugin {
  final DynamicLibrary dynamicLibrary;
  late final ExtismFFI _extismFFI;

  Plugin({
    required bool withWasi,
    required ManifestEntity manifest,
    required this.dynamicLibrary,
  }) {
    _extismFFI = ExtismFFI(dynamicLibrary: dynamicLibrary);
    final bytes = manifest.bytes();
    _pluginPointer =
        _extismFFI.extismPluginNew(_allocator, bytes, [], withWasi);
  }

  final _allocator = calloc;
  late final Pointer<ExtismPlugin> _pluginPointer;

  void dispose() {
    _extismFFI.extismPluginFree(_pluginPointer);
  }

  List<int> call(String functionName, List<int> inputData) {
    try {
      // Call function
      final resultCode = _extismFFI.extismPluginCall(
        _allocator,
        _pluginPointer,
        functionName,
        inputData,
      );

      // Check result
      if (resultCode != 0) {
        final errorPointer = _extismFFI.extismPluginError(_pluginPointer);
        final errorMessage = errorPointer.toDartString();
        throw ExtismException(errorMessage);
      }

      // Retrieve output
      final outputSize = _extismFFI.extismPluginOutputLength(_pluginPointer);
      final outputPointer = _extismFFI.extismPluginOutputData(_pluginPointer);

      return outputPointer.asTypedList(outputSize);
    } on Object catch (e) {
      throw ExtismException(e.toString());
    }
  }
}
