// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manifest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Manifest _$ManifestFromJson(Map<String, dynamic> json) => Manifest(
      allowedHosts: (json['allowed_hosts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      allowedPaths: (json['allowed_paths'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      config: (json['config'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      memory: json['memory'] == null
          ? null
          : MemoryOptions.fromJson(json['memory'] as Map<String, dynamic>),
      timeoutMs: (json['timeout_ms'] as num?)?.toInt(),
      wasm: (json['wasm'] as List<dynamic>?)
          ?.map((e) => Wasm.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ManifestToJson(Manifest instance) => <String, dynamic>{
      if (instance.allowedHosts case final value?) 'allowed_hosts': value,
      if (instance.allowedPaths case final value?) 'allowed_paths': value,
      if (instance.config case final value?) 'config': value,
      if (instance.memory?.toJson() case final value?) 'memory': value,
      if (instance.timeoutMs case final value?) 'timeout_ms': value,
      if (instance.wasm?.map((e) => e.toJson()).toList() case final value?)
        'wasm': value,
    };

MemoryOptions _$MemoryOptionsFromJson(Map<String, dynamic> json) =>
    MemoryOptions(
      maxHttpResponseBytes: (json['max_http_response_bytes'] as num?)?.toInt(),
      maxPages: (json['max_pages'] as num?)?.toInt(),
      maxVarBytes: (json['max_var_bytes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MemoryOptionsToJson(MemoryOptions instance) =>
    <String, dynamic>{
      if (instance.maxHttpResponseBytes case final value?)
        'max_http_response_bytes': value,
      if (instance.maxPages case final value?) 'max_pages': value,
      if (instance.maxVarBytes case final value?) 'max_var_bytes': value,
    };

Wasm _$WasmFromJson(Map<String, dynamic> json) => Wasm(
      hash: json['hash'] as String?,
      name: json['name'] as String?,
      path: json['path'] as String?,
      data: json['data'],
      headers: (json['headers'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      method: json['method'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$WasmToJson(Wasm instance) => <String, dynamic>{
      if (instance.hash case final value?) 'hash': value,
      if (instance.name case final value?) 'name': value,
      if (instance.path case final value?) 'path': value,
      if (instance.data case final value?) 'data': value,
      if (instance.headers case final value?) 'headers': value,
      if (instance.method case final value?) 'method': value,
      if (instance.url case final value?) 'url': value,
    };

DataClass _$DataClassFromJson(Map<String, dynamic> json) => DataClass(
      len: (json['len'] as num).toInt(),
      ptr: (json['ptr'] as num).toInt(),
    );

Map<String, dynamic> _$DataClassToJson(DataClass instance) => <String, dynamic>{
      'len': instance.len,
      'ptr': instance.ptr,
    };
