import 'dart:ffi';
import 'package:dart_sdk/src/current_plugin.dart';
import 'package:dart_sdk/src/extism_ffi.dart';
import 'package:dart_sdk/src/lib_extism.dart';
import 'package:ffi/ffi.dart';

// A function provided by the host that plugins can call.
class HostFunction {
  final String functionName;
  final List<ExtismValType> inputTypes;
  final List<ExtismValType> outputTypes;
  final void Function(CurrentPlugin, List<ExtismVal>, List<ExtismVal>)
      _function;
  Object? userData;
  Pointer<ExtismFunction>? _nativeHandle;

  static final Map<String, Function> functionRegistry = {};

  HostFunction({
    required this.functionName,
    required this.inputTypes,
    required this.outputTypes,
    required void Function(CurrentPlugin, List<ExtismVal>, List<ExtismVal>)
        function,
    this.userData,
  }) : _function = function {
    functionRegistry[functionName] = function;
  }

  Pointer<ExtismFunction> get nativeHandle {
    if (_nativeHandle == null) {
      _nativeHandle = _createNativeHandle();
    }
    return _nativeHandle!;
  }

  Pointer<ExtismFunction> _createNativeHandle() {
    final name = functionName.toNativeUtf8();
    final inputs = calloc<Int32>(inputTypes.length);
    final outputs = calloc<Int32>(outputTypes.length);

    for (var i = 0; i < inputTypes.length; i++) {
      inputs[i] = inputTypes[i].value;
    }
    for (var i = 0; i < outputTypes.length; i++) {
      outputs[i] = outputTypes[i].value;
    }

    final ExtismFunctionType callback =
        Pointer.fromFunction(callbackTrampoline);

    _userDataPtr = storeUserData(userData);

    final handle = extism.extism_function_new(
      name.cast(),
      inputs.cast(),
      inputTypes.length,
      outputs.cast(),
      outputTypes.length,
      callback,
      _userDataPtr,
      nullptr,
    );

    calloc.free(name);
    calloc.free(inputs);
    calloc.free(outputs);

    return handle;
  }

  static Pointer<Void> _userDataPtr = nullptr;

  static Pointer<Void> storeUserData(Object? userData) {
    if (userData == null) {
      return nullptr;
    }

    final pointer = calloc<Pointer<Void>>();
    // ignore: invalid_use_of_protected_member
    pointer.value = Pointer.fromAddress(identityHashCode(userData));

    userDataRegistry[pointer.address] = userData;

    return pointer.cast();
  }

  static final Map<int, Object> userDataRegistry = {};

  static int callbackTrampoline(
    Pointer<ExtismCurrentPlugin> pluginPtr,
    Pointer<ExtismVal> inputsPtr,
    int nInputs,
    Pointer<ExtismVal> outputsPtr,
    int nOutputs,
    Pointer<Void> data,
  ) {
    try {
      final plugin = CurrentPlugin(pluginPtr, data);
      final inputs = <ExtismVal>[];
      for (var i = 0; i < nInputs; i++) {
        inputs.add(inputsPtr.elementAt(i).ref);
      }
      final outputs = <ExtismVal>[];
      for (var i = 0; i < nOutputs; i++) {
        outputs.add(outputsPtr.elementAt(i).ref);
      }

      // Get the host function from the registry using the function name
      final function =
          HostFunction.functionRegistry[plugin.hostFunction?.functionName];

      if (function == null) {
        print('Error: Host function not found'); // Or handle it more gracefully
        return 1;
      }

      function(plugin, inputs, outputs);
      return 0;
    } catch (e) {
      print('Error in host function callback: $e');
      return 1;
    }
  }

  void setNamespace(String ns) {
    if (ns.isNotEmpty) {
      final namespace = ns.toNativeUtf8();
      extism.extism_function_set_namespace(nativeHandle, namespace.cast());
      calloc.free(namespace);
    }
  }

  HostFunction withNamespace(String ns) {
    setNamespace(ns);
    return this;
  }

  void dispose() {
    if (_nativeHandle != null) {
      extism.extism_function_free(_nativeHandle!);
      _nativeHandle = null;
    }
    if (_userDataPtr != nullptr) {
      calloc.free(_userDataPtr);
      userDataRegistry.remove(_userDataPtr.address);
      _userDataPtr = nullptr;
    }
  }
}
