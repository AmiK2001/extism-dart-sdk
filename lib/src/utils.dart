import 'dart:ffi';

import 'package:dart_sdk/extism.dart';
import 'package:ffi/ffi.dart';

extension Uint8ListExtensions on List<int> {
  Pointer<Uint8> toNativeUint8List(Allocator allocator) {
    final ptr = allocator<Uint8>(length);
    ptr.asTypedList(length).setAll(0, this);
    return ptr;
  }
}

extension CharPointerExtension on Pointer<Char> {
  String toDartString() {
    return cast<Utf8>().toDartString();
  }
}

extension ExtismFunctionPointerListExtensions on List<Pointer<ExtismFunction>> {
  Pointer<Pointer<ExtismFunction>> toNativePointerList(Allocator allocator) {
    final ptr = allocator<Pointer<ExtismFunction>>(length);
    for (var i = 0; i < length; i++) {
      ptr[i] = this[i];
    }
    return ptr;
  }
}
