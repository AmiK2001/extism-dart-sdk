// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'manifest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Manifest _$ManifestFromJson(Map<String, dynamic> json) {
  return _Manifest.fromJson(json);
}

/// @nodoc
mixin _$Manifest {
  List<WasmSource> get wasm => throw _privateConstructorUsedError;
  MemoryOptions get memory => throw _privateConstructorUsedError;
  List<String> get allowedHosts => throw _privateConstructorUsedError;
  Map<String, String> get allowedPaths => throw _privateConstructorUsedError;
  Map<String, String> get config => throw _privateConstructorUsedError;

  /// Serializes this Manifest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Manifest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ManifestCopyWith<Manifest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ManifestCopyWith<$Res> {
  factory $ManifestCopyWith(Manifest value, $Res Function(Manifest) then) =
      _$ManifestCopyWithImpl<$Res, Manifest>;
  @useResult
  $Res call(
      {List<WasmSource> wasm,
      MemoryOptions memory,
      List<String> allowedHosts,
      Map<String, String> allowedPaths,
      Map<String, String> config});
}

/// @nodoc
class _$ManifestCopyWithImpl<$Res, $Val extends Manifest>
    implements $ManifestCopyWith<$Res> {
  _$ManifestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Manifest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wasm = null,
    Object? memory = null,
    Object? allowedHosts = null,
    Object? allowedPaths = null,
    Object? config = null,
  }) {
    return _then(_value.copyWith(
      wasm: null == wasm
          ? _value.wasm
          : wasm // ignore: cast_nullable_to_non_nullable
              as List<WasmSource>,
      memory: null == memory
          ? _value.memory
          : memory // ignore: cast_nullable_to_non_nullable
              as MemoryOptions,
      allowedHosts: null == allowedHosts
          ? _value.allowedHosts
          : allowedHosts // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allowedPaths: null == allowedPaths
          ? _value.allowedPaths
          : allowedPaths // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ManifestImplCopyWith<$Res>
    implements $ManifestCopyWith<$Res> {
  factory _$$ManifestImplCopyWith(
          _$ManifestImpl value, $Res Function(_$ManifestImpl) then) =
      __$$ManifestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<WasmSource> wasm,
      MemoryOptions memory,
      List<String> allowedHosts,
      Map<String, String> allowedPaths,
      Map<String, String> config});
}

/// @nodoc
class __$$ManifestImplCopyWithImpl<$Res>
    extends _$ManifestCopyWithImpl<$Res, _$ManifestImpl>
    implements _$$ManifestImplCopyWith<$Res> {
  __$$ManifestImplCopyWithImpl(
      _$ManifestImpl _value, $Res Function(_$ManifestImpl) _then)
      : super(_value, _then);

  /// Create a copy of Manifest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? wasm = null,
    Object? memory = null,
    Object? allowedHosts = null,
    Object? allowedPaths = null,
    Object? config = null,
  }) {
    return _then(_$ManifestImpl(
      wasm: null == wasm
          ? _value._wasm
          : wasm // ignore: cast_nullable_to_non_nullable
              as List<WasmSource>,
      memory: null == memory
          ? _value.memory
          : memory // ignore: cast_nullable_to_non_nullable
              as MemoryOptions,
      allowedHosts: null == allowedHosts
          ? _value._allowedHosts
          : allowedHosts // ignore: cast_nullable_to_non_nullable
              as List<String>,
      allowedPaths: null == allowedPaths
          ? _value._allowedPaths
          : allowedPaths // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      config: null == config
          ? _value._config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ManifestImpl implements _Manifest {
  const _$ManifestImpl(
      {required final List<WasmSource> wasm,
      required this.memory,
      required final List<String> allowedHosts,
      required final Map<String, String> allowedPaths,
      required final Map<String, String> config})
      : _wasm = wasm,
        _allowedHosts = allowedHosts,
        _allowedPaths = allowedPaths,
        _config = config;

  factory _$ManifestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ManifestImplFromJson(json);

  final List<WasmSource> _wasm;
  @override
  List<WasmSource> get wasm {
    if (_wasm is EqualUnmodifiableListView) return _wasm;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_wasm);
  }

  @override
  final MemoryOptions memory;
  final List<String> _allowedHosts;
  @override
  List<String> get allowedHosts {
    if (_allowedHosts is EqualUnmodifiableListView) return _allowedHosts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allowedHosts);
  }

  final Map<String, String> _allowedPaths;
  @override
  Map<String, String> get allowedPaths {
    if (_allowedPaths is EqualUnmodifiableMapView) return _allowedPaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_allowedPaths);
  }

  final Map<String, String> _config;
  @override
  Map<String, String> get config {
    if (_config is EqualUnmodifiableMapView) return _config;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_config);
  }

  @override
  String toString() {
    return 'Manifest(wasm: $wasm, memory: $memory, allowedHosts: $allowedHosts, allowedPaths: $allowedPaths, config: $config)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ManifestImpl &&
            const DeepCollectionEquality().equals(other._wasm, _wasm) &&
            (identical(other.memory, memory) || other.memory == memory) &&
            const DeepCollectionEquality()
                .equals(other._allowedHosts, _allowedHosts) &&
            const DeepCollectionEquality()
                .equals(other._allowedPaths, _allowedPaths) &&
            const DeepCollectionEquality().equals(other._config, _config));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_wasm),
      memory,
      const DeepCollectionEquality().hash(_allowedHosts),
      const DeepCollectionEquality().hash(_allowedPaths),
      const DeepCollectionEquality().hash(_config));

  /// Create a copy of Manifest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ManifestImplCopyWith<_$ManifestImpl> get copyWith =>
      __$$ManifestImplCopyWithImpl<_$ManifestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ManifestImplToJson(
      this,
    );
  }
}

abstract class _Manifest implements Manifest {
  const factory _Manifest(
      {required final List<WasmSource> wasm,
      required final MemoryOptions memory,
      required final List<String> allowedHosts,
      required final Map<String, String> allowedPaths,
      required final Map<String, String> config}) = _$ManifestImpl;

  factory _Manifest.fromJson(Map<String, dynamic> json) =
      _$ManifestImpl.fromJson;

  @override
  List<WasmSource> get wasm;
  @override
  MemoryOptions get memory;
  @override
  List<String> get allowedHosts;
  @override
  Map<String, String> get allowedPaths;
  @override
  Map<String, String> get config;

  /// Create a copy of Manifest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ManifestImplCopyWith<_$ManifestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
