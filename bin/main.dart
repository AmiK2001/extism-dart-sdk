import 'dart:ffi';
import 'dart:io';

import 'package:dart_sdk/src/manifest/manifest_entity.dart';
import 'package:dart_sdk/src/plugin.dart';
import 'package:dart_sdk/src/wasm/wasm_source.dart';

void main() {
  const wasmPath = "test/resources/code.wasm";
  const functionName = "count_vowels";
  const input = "Hello, world";

  // Load WASM file
  final wasmData = File(wasmPath);
  if (!wasmData.existsSync()) {
    throw Exception('WASM file not found at path: $wasmPath');
  }

  // Define manifest
  final manifest = ManifestEntity(
    wasm: [
      WasmSource.fromPath(
        path: wasmPath,
        name: "main",
      ),
    ],
  );

  // Create plugin
  final plugin = Plugin(
    dynamicLibrary: DynamicLibrary.open("libs/extism.dll"),
    withWasi: true,
    manifest: manifest,
  );

  print("Executing $functionName from $wasmPath with input '$input'\n");

  final output = String.fromCharCodes(
    plugin.call(
      functionName,
      input.runes.toList(),
    ),
  );

  print(output);
}
