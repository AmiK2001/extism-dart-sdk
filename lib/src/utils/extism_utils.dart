import 'dart:ffi';

import 'package:dart_sdk/extism.dart';

extension Uint8ListExtensions on List<int> {
  Pointer<Uint8> toNativeUint8List(Allocator allocator) {
    final ptr = allocator<Uint8>(length);
    ptr.asTypedList(length).setAll(0, this);
    return ptr;
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
