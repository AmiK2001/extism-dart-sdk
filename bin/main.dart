import 'dart:convert';
import 'dart:io';

import 'package:dart_sdk/extism.dart';
import 'package:dart_sdk/src/current_plugin.dart';
import 'package:dart_sdk/src/host_function.dart';
import 'package:dart_sdk/src/http_request.dart';
import 'package:dart_sdk/src/lib_extism.dart';

void countVowels() {
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
    "Hello, world",
  );

  print(output);
}

void hostFunctions() {
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
    "Hello, world",
  );

  print(output);
}

void httpGet() {
  final httpPlugin = Plugin.initWithManifest(
    manifest: ManifestEntity(
      allowedHosts: [
        "jsonplaceholder.typicode.com",
      ],
      wasm: [
        WasmSource.fromPath(
          name: 'main',
          path: "test/resources/http.wasm",
        ),
      ],
    ),
    withWasi: false,
  );

  final httpRequestJson = jsonEncode(
    HttpRequest(
      url: "https://jsonplaceholder.typicode.com/todos/1",
      method: "GET",
      headers: {},
    ),
  );

  print(
    httpPlugin.callString(
      "http_get",
      httpRequestJson,
    ),
  );
}

void main() {
  countVowels();
  httpGet();
  hostFunctions();

  exit(0);
}
