import 'dart:ffi';

import 'package:dart_sdk/src/extism_exception.dart';
import 'package:dart_sdk/src/extism_ffi.dart';
import 'package:dart_sdk/src/lib_extism.dart';
import 'package:dart_sdk/src/manifest/manifest_entity.dart';
import 'package:ffi/ffi.dart';

class Plugin {
  final DynamicLibrary dynamicLibrary;
  late final ExtismFFI _extism;

  Plugin({
    required bool withWasi,
    required ManifestEntity manifest,
    required this.dynamicLibrary,
  }) {
    _extism = ExtismFFI(dynamicLibrary: dynamicLibrary);
    final bytes = manifest.bytes();
    _pluginPointer = _extism.extismPluginNew(_allocator, bytes, [], withWasi);
  }

  final _allocator = calloc;
  late final Pointer<ExtismPlugin> _pluginPointer;

  void dispose() {
    _extism.extismPluginFree(_pluginPointer);
  }

  List<int> call(String functionName, List<int> inputData) {
    try {
      // Call function
      final resultCode = _extism.extismPluginCall(
        _allocator,
        _pluginPointer,
        functionName,
        inputData,
      );

      // Check result
      if (resultCode != 0) {
        final errorMessage = _extism.extismPluginError(_pluginPointer);
        throw ExtismException(errorMessage);
      }

      // Retrieve output
      final outputSize = _extism.extismPluginOutputLength(_pluginPointer);
      final outputPointer = _extism.extismPluginOutputData(_pluginPointer);

      return outputPointer.asTypedList(outputSize);
    } on Object catch (e) {
      throw ExtismException(e.toString());
    }
  }
}
