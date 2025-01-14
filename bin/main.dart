import 'dart:io';

import 'package:dart_sdk/src/api/plugin.dart';

void main() {
  const wasmPath = "test/resources/code.wasm";
  const functionName = "count_vowels";
  const input = "Hello, world";

  // Load WASM file
  final wasmData = File(wasmPath);
  if (!wasmData.existsSync()) {
    throw Exception('WASM file not found at path: $wasmPath');
  }

  final wasmBytes = wasmData.readAsBytesSync();

  final plugin = Plugin(withWasi: true, wasm: wasmBytes);

  print("Executing $functionName from $wasmPath with input '$input'\n");

  print(
    plugin.call(
      functionName,
      input.runes.toList(),
    ),
  );
}
