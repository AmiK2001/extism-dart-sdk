import 'dart:ffi';
import 'dart:ffi' as ffi;
import 'package:dart_sdk/src/lib_extism.dart';
import 'package:ffi/ffi.dart';

extension ExtismValTypeExtension on ExtismValType {
  ExtismVal allocate(dynamic value) {
    final val = calloc<ExtismVal>();

    val.ref.tAsInt = this.value;

    switch (this) {
      case ExtismValType.ExtismValType_I32:
        val.ref.v.i32 = value as int;
      case ExtismValType.ExtismValType_I64:
        val.ref.v.i64 = value as int;
      case ExtismValType.ExtismValType_F32:
        val.ref.v.f32 = value as double;
      case ExtismValType.ExtismValType_F64:
        val.ref.v.f64 = value as double;
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
