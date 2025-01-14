import 'dart:ffi';

import 'package:dart_sdk/extism.dart';
import 'package:dart_sdk/src/exceptions/extism_exception.dart';
import 'package:ffi/ffi.dart';

class Plugin {
  Plugin({
    required bool withWasi,
    required List<int> wasm,
  }) {
    _pluginPointer = extismPluginNew(_allocator, wasm, [], withWasi);
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
        final errorMessage = errorPointer.cast<Utf8>().toDartString();
        throw Exception('Plugin call failed with error: $errorMessage');
      }

      // Retrieve output
      final outputSize = extismPluginOutputLength(_pluginPointer);
      final outputPointer = extismPluginOutputData(_pluginPointer);

      return outputPointer.asTypedList(outputSize);
    } catch (e) {
      throw ExtismException(e.toString());
    }
  }
}
