// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manifest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ManifestImpl _$$ManifestImplFromJson(Map<String, dynamic> json) =>
    _$ManifestImpl(
      wasm: (json['wasm'] as List<dynamic>)
          .map((e) => WasmSource.fromJson(e as Map<String, dynamic>))
          .toList(),
      memory: MemoryOptions.fromJson(json['memory'] as Map<String, dynamic>),
      allowedHosts: (json['allowedHosts'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      allowedPaths: Map<String, String>.from(json['allowedPaths'] as Map),
      config: Map<String, String>.from(json['config'] as Map),
    );

Map<String, dynamic> _$$ManifestImplToJson(_$ManifestImpl instance) =>
    <String, dynamic>{
      'wasm': instance.wasm,
      'memory': instance.memory,
      'allowedHosts': instance.allowedHosts,
      'allowedPaths': instance.allowedPaths,
      'config': instance.config,
    };
