import 'dart:convert';

import 'package:dart_sdk/extism.dart';
import 'package:dart_sdk/src/current_plugin.dart';
import 'package:dart_sdk/src/host_function.dart';
import 'package:dart_sdk/src/lib_extism.dart';

void countVowels() {
  // Host functions sample
  final sumFunction = HostFunction(
    functionName: 'sum_two_numbers',
    inputTypes: [
      ExtismValType.ExtismValType_I32,
      ExtismValType.ExtismValType_I32,
    ],
    outputTypes: [ExtismValType.ExtismValType_I32],
    function: (
      CurrentPlugin plugin,
      List<ExtismVal> inputs,
      List<ExtismVal> outputs,
    ) {
      final a = inputs[0].v.i32;
      final b = inputs[1].v.i32;
      final sum = a + b;

      // Set the output value
      outputs[0].v.i32 = sum;
    },
  );

  final manifest = ManifestEntity(
    wasm: [
      WasmSource.fromPath(name: "main", path: "test/resources/code.wasm"),
    ],
  );

  // Create plugin
  final plugin = Plugin(
    manifest,
    [
      sumFunction,
    ],
    PluginInitializationOptions(),
  );

  final output = plugin.callString(
    "count_vowels",
    "Hello, world",
  );

  print(output);
}

void httpGet() {
  final httpPlugin = Plugin.initWithManifest(
    manifest: ManifestEntity(
      allowedHosts: [
        "pub.dev",
      ],
      wasm: [
        WasmSource.fromUrl(
          name: 'http',
          url: Uri.parse(
            "https://github.com/extism/plugins/releases/download/v1.1.1/http.wasm",
          ),
          hash:
              "430edb43f087fa55b6ae489097a2dac8c332953f3f5116c45307cdcae77e2879",
        ),
      ],
    ),
    withWasi: false,
  );

  final httpRequest = jsonEncode({
    "url": "https://pub.dev/packages/uuid",
    "method": "GET",
  });

  print(
    httpPlugin.callString(
      "http_get",
      httpRequest,
    ),
  );
}

void main() {
  countVowels();
  httpGet();
}
