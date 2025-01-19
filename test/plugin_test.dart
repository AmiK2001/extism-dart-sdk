import 'dart:io';

import 'package:extism/extism.dart';
import 'package:extism/src/extism_exception.dart';
import 'package:test/test.dart';

void main() {
  // Ensure the WASM file exists
  setUpAll(() {
    const wasmFilePath = "test/resources/code.wasm";
    if (!File(wasmFilePath).existsSync()) {
      throw StateError(
        "WASM file not found at $wasmFilePath. Please compile the WASM module before running tests.",
      );
    }
  });

  test('Plugin call with valid input returns expected output', () {
    final manifest = ManifestEntity(
      wasm: [
        WasmSource.fromPath(name: "main", path: "test/resources/code.wasm"),
      ],
    );

    // Create plugin
    final plugin = Plugin(
      manifest,
      [],
      PluginInitializationOptions(),
    );

    final output = plugin.callString(
      "count_vowels",
      "Hello, world!",
    );

    expect(output, equals('{"count":3,"total":3,"vowels":"aeiouAEIOU"}'));

    plugin.dispose();
  });

  test('Plugin call with empty input string', () {
    final manifest = ManifestEntity(
      wasm: [
        WasmSource.fromPath(name: "main", path: "test/resources/code.wasm"),
      ],
    );

    final plugin = Plugin(
      manifest,
      [],
      PluginInitializationOptions(),
    );

    final output = plugin.callString(
      "count_vowels",
      "",
    );

    expect(
      output,
      equals('{"count":0,"total":0,"vowels":"aeiouAEIOU"}'),
    );

    plugin.dispose();
  });

  test('Plugin call with non-existent function should throw ExtismException',
      () {
    final manifest = ManifestEntity(
      wasm: [
        WasmSource.fromPath(name: "main", path: "test/resources/code.wasm"),
      ],
    );

    final plugin = Plugin(
      manifest,
      [],
      PluginInitializationOptions(),
    );

    expect(
      () => plugin.callString(
        "non_existent_function", // Calling a function that doesn't exist
        "Hello, world!",
      ),
      throwsA(
        isA<ExtismException>().having(
          (e) => e.message,
          'message',
          contains(
            'Function not found: non_existent_function. Exit Code: -1',
          ),
        ),
      ),
    );

    plugin.dispose();
  });
}
