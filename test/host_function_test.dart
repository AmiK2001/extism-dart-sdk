import 'dart:convert';
import 'dart:io';

import 'package:extism/extism.dart';
import 'package:test/test.dart';

void main() {
  // Ensure the WASM file exists before running tests.
  setUpAll(() {
    const wasmFilePath = "test/resources/host_function.wasm";
    if (!File(wasmFilePath).existsSync()) {
      throw StateError(
        "WASM file not found at $wasmFilePath. Please compile the WASM module before running tests.",
      );
    }
  });

  test('HostFunction with valid input and output', () {
    final helloWorldFunction = HostFunction(
      functionName: 'hello_world',
      inputTypes: [
        ExtismValType.ExtismValType_I64,
      ],
      outputTypes: [
        ExtismValType.ExtismValType_I64,
      ],
      function: (
        CurrentPlugin plugin,
        List<ExtismVal> inputs,
        List<ExtismVal> outputs,
      ) {
        final input = inputs[0].offset.let(plugin.readString).let(jsonDecode);
        final count = input['count'] as int;

        print("Input: $input");

        final newCount = count * 100;

        final output = {'count': newCount}.let(jsonEncode);

        final outputPtr = plugin.writeString(output);

        print("Output: $output");

        outputs[0].v.i64 = outputPtr;
      },
    ).withNamespace("extism:env/user");

    final plugin = Plugin(
      ManifestEntity(
        wasm: [
          WasmSource.fromPath(
            name: 'main',
            path: "test/resources/host_function.wasm",
          ),
        ],
      ),
      [
        helloWorldFunction,
      ],
      PluginInitializationOptions(
        withWasi: true,
      ),
    );

    final output = plugin.callString(
      "count_vowels",
      jsonEncode({'count': 4}),
    );

    final outputJson = jsonDecode(output);
    expect(outputJson['count'], equals(2 * 100));

    plugin.dispose();
  });
}
