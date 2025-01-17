import 'dart:ffi';
import 'dart:io';

import 'package:dart_sdk/extism.dart';
import 'package:dart_sdk/src/current_plugin.dart';
import 'package:dart_sdk/src/host_function.dart';
import 'package:dart_sdk/src/lib_extism.dart';
import 'package:ffi/ffi.dart';

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
    withWasi: true,
    manifest: manifest,
  );

  print("Executing $functionName from $wasmPath with input '$input'\n");

  final output = plugin.call(
    functionName,
    input.runes.toList(),
  );

  print(output.toDartString());

  // Host functions sample
  final sumFunction = HostFunction(
    functionName: 'sum_two_numbers',
    inputTypes: [
      ExtismValType.ExtismValType_I32,
      ExtismValType.ExtismValType_I32
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
    userData: 10,
  );

  // Simulate calling 'sum_two_numbers'
  print("\nCalling sum_two_numbers (simulated)...");
  final sumInputs = allocateExtismValArray([
    MapEntry(ExtismValType.ExtismValType_I32, 10),
    MapEntry(ExtismValType.ExtismValType_I32, 25),
  ]);
  final sumOutputs = allocateExtismValArray([
    MapEntry(ExtismValType.ExtismValType_I32, 0),
  ]);

  // Allocate a Pointer<ExtismCurrentPlugin> for the dummy plugin
  final dummyPluginPtr = calloc<Pointer<ExtismCurrentPlugin>>();

  // Get the native handle of sumFunction
  final sumFunctionHandle = sumFunction.nativeHandle;

  // Simulate the plugin calling the host function using the stored function
  HostFunction.callbackTrampoline(
    dummyPluginPtr.value,
    sumInputs,
    2,
    sumOutputs,
    1,
    HostFunction.storeUserData(sumFunction),
  );

  print("Sum result: ${sumOutputs[0].v.i32}");
}
