import 'dart:ffi';
import 'dart:ffi' as ffi;
import 'package:dart_sdk/src/lib_extism.dart';
import 'package:ffi/ffi.dart';

extension Uint8ListExtensions on List<int> {
  Pointer<Uint8> toNativeUint8List(Allocator allocator) {
    final ptr = allocator<Uint8>(length);
    ptr.asTypedList(length).setAll(0, this);
    return ptr;
  }

  Pointer<Uint32> toNativeUint32() {
    final Pointer<Uint32> pointer = malloc<Uint32>(length);

    for (var i = 0; i < length; i++) {
      pointer[i] = this[i];
    }

    return pointer;
  }

  String toDartString() {
    return String.fromCharCodes(this);
  }
}

extension StringExtension on String {
  Pointer<Char> toChar() {
    return toNativeUtf8().cast();
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

extension PointerValue<T extends NativeType> on Pointer<T> {
  /// Retrieves the value at the pointer's address for supported types.
  T? getValue() {
    if (address == 0) return null;

    // Handle primitive types
    if (T == int) return cast<IntPtr>().value as T;
    if (T == double) return cast<Double>().value as T;
    if (T == Uint8) return cast<Uint8>().value as T;
    if (T == Int8) return cast<Int8>().value as T;
    if (T == Uint16) return cast<Uint16>().value as T;
    if (T == Int16) return cast<Int16>().value as T;
    if (T == Uint32) return cast<Uint32>().value as T;
    if (T == Int32) return cast<Int32>().value as T;
    if (T == Uint64) return cast<Uint64>().value as T;
    if (T == Int64) return cast<Int64>().value as T;
    if (T == Float) return cast<Float>().value as T;

    // Handle pointers to void
    if (T == Pointer<Void>) return cast<Void>() as T;

    throw UnsupportedError(
      "Type $T is not supported for pointer dereferencing.",
    );
  }
}

extension ExtismValTypeExtension on ExtismValType {
  ExtismVal allocate(dynamic value) {
    final val = calloc<ExtismVal>();

    val.ref.tAsInt = this.value;

    switch (this) {
      case ExtismValType.ExtismValType_I32:
        val.ref.v.i32 = value as int;
        break;
      case ExtismValType.ExtismValType_I64:
        val.ref.v.i64 = value as int;
        break;
      case ExtismValType.ExtismValType_F32:
        val.ref.v.f32 = value as double;
        break;
      case ExtismValType.ExtismValType_F64:
        val.ref.v.f64 = value as double;
        break;
      default:
        calloc.free(val);
        throw ArgumentError('Unsupported ExtismValType for value assignment');
    }

    return val.ref;
  }
}

Pointer<ExtismVal> allocateExtismValArray(
  List<MapEntry<ExtismValType, dynamic>> values,
) {
  final sumInputs = calloc<ExtismVal>(values.length);

  for (var index = 0; index < values.length; index++) {
    sumInputs[index] = values.elementAt(index).key.allocate(
          values.elementAt(index).value,
        );
  }

  return sumInputs;
}
