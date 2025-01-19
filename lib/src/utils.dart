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

extension ExtismValExtension on ExtismVal {
  num toNum() => switch (t) {
        ExtismValType.ExtismValType_I32 => v.i32,
        ExtismValType.ExtismValType_I64 => v.i64,
        ExtismValType.ExtismValType_F32 => v.f32,
        ExtismValType.ExtismValType_F64 => v.f64,
        ExtismValType.ExtismValType_V128 => throw UnimplementedError(),
        ExtismValType.ExtismValType_FuncRef => throw UnimplementedError(),
        ExtismValType.ExtismValType_ExternRef => throw UnimplementedError(),
      };

  int get offset => switch (t) {
        ExtismValType.ExtismValType_I32 => v.i32,
        ExtismValType.ExtismValType_I64 => v.i64,
        ExtismValType.ExtismValType_F32 => throw UnimplementedError(),
        ExtismValType.ExtismValType_F64 => throw UnimplementedError(),
        ExtismValType.ExtismValType_V128 => throw UnimplementedError(),
        ExtismValType.ExtismValType_FuncRef => throw UnimplementedError(),
        ExtismValType.ExtismValType_ExternRef => throw UnimplementedError(),
      };
}

extension LetExtension<T> on T {
  V let<V>(V Function(T) f) => f(this);
}
