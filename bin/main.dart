import 'dart:convert';
import 'dart:io';

import 'package:dart_sdk/extism.dart';

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

  // Define manifest
  final manifest = Manifest(
    wasm: [
      Wasm(
        data: base64Encode(wasmBytes),
        name: "main",
      ),
    ],
    timeoutMs: 5000,
  );

  final manifestInBytes = jsonEncode(manifest).runes.toList();

  // Create plugin
  final plugin = Plugin(
    withWasi: true,
    wasm: manifestInBytes,
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
