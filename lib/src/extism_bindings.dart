import 'dart:ffi';
import 'dart:io';

import 'package:dart_sdk/extism.dart';
import 'package:ffi/ffi.dart';

DynamicLibrary loadExtismLibrary() {
  final libraryPath = _findLibraryPath();
  return DynamicLibrary.open(libraryPath);
}

String _findLibraryPath() {
  const binariesFolder = 'libs';

  if (Platform.isLinux) {
    return '$binariesFolder/linux/libextism.so';
  } else if (Platform.isMacOS) {
    return '$binariesFolder/macos/libextism.dylib';
  } else if (Platform.isWindows) {
    return '$binariesFolder/windows/extism.dll';
  } else if (Platform.isAndroid) {
    return _findAndroidLibrary();
  } else {
    throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
  }
}

final _extismLib = LibExtism(loadExtismLibrary());

String _findAndroidLibrary() {
  // Detect the CPU architecture of the Android device
  final abi = Platform.environment['ANDROID_RUNTIME_ABI'] ??
      (Platform.environment['HOSTTYPE'] ?? 'unknown');

  if (abi.contains('arm') && !abi.contains('64')) {
    return 'binaries/android/armeabi-v7a/libextism.so';
  } else if (abi.contains('arm64')) {
    return 'binaries/android/arm64-v8a/libextism.so';
  } else if (abi.contains('x86') && !abi.contains('64')) {
    return 'binaries/android/x86/libextism.so';
  } else if (abi.contains('x86_64')) {
    return 'binaries/android/x86_64/libextism.so';
  } else {
    throw UnsupportedError('Unsupported Android ABI: $abi');
  }
}

// Exposed FFI Functions
String extismVersion() =>
    _extismLib.extism_version().cast<Utf8>().toDartString();

Pointer<ExtismPlugin> extismPluginNew(
  Allocator allocator,
  List<int> wasm,
  List<Pointer<ExtismFunction>> functions,
  bool withWasi,
) {
  final wasmPointer = wasm.toNativeUint8List(allocator);
  final functionsPointer = functions.toNativePointerList(allocator);
  final errmsgPointer = allocator<Pointer<Char>>();

  final plugin = _extismLib.extism_plugin_new(
    wasmPointer,
    wasm.length,
    functionsPointer,
    functions.length,
    withWasi,
    errmsgPointer,
  );

  allocator.free(wasmPointer);
  allocator.free(functionsPointer);

  if (errmsgPointer.value != nullptr) {
    final error = errmsgPointer.cast<Utf8>().toDartString();
    allocator.free(errmsgPointer.value);
    allocator.free(errmsgPointer);
    throw Exception('Extism Plugin Error: $error');
  }

  allocator.free(errmsgPointer);
  return plugin;
}

void extismPluginFree(Pointer<ExtismPlugin> plugin) {
  _extismLib.extism_plugin_free(plugin);
}

int extismPluginCall(
  Allocator allocator,
  Pointer<ExtismPlugin> plugin,
  String funcName,
  List<int> data,
) {
  final funcNamePointer = funcName.toNativeUtf8(allocator: allocator);
  final dataPointer = data.toNativeUint8List(allocator);

  final result = _extismLib.extism_plugin_call(
      plugin, funcNamePointer.cast(), dataPointer, data.length);

  allocator.free(funcNamePointer);
  allocator.free(dataPointer);

  return result;
}

Pointer<Uint8> extismPluginOutputData(
  Pointer<ExtismPlugin> plugin,
) {
  final result = _extismLib.extism_plugin_output_data(plugin);

  return result;
}

int extismPluginOutputLength(
  Pointer<ExtismPlugin> plugin,
) {
  final result = _extismLib.extism_plugin_output_length(plugin);

  return result;
}

Pointer<Char> extismPluginError(
  Pointer<ExtismPlugin> plugin,
) {
  final result = _extismLib.extism_plugin_error(plugin);

  return result;
}
