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

Map<String, dynamic> _$ManifestToJson(Manifest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('allowed_hosts', instance.allowedHosts);
  writeNotNull('allowed_paths', instance.allowedPaths);
  writeNotNull('config', instance.config);
  writeNotNull('memory', instance.memory?.toJson());
  writeNotNull('timeout_ms', instance.timeoutMs);
  writeNotNull('wasm', instance.wasm?.map((e) => e.toJson()).toList());
  return val;
}

MemoryOptions _$MemoryOptionsFromJson(Map<String, dynamic> json) =>
    MemoryOptions(
      maxHttpResponseBytes: (json['max_http_response_bytes'] as num?)?.toInt(),
      maxPages: (json['max_pages'] as num?)?.toInt(),
      maxVarBytes: (json['max_var_bytes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MemoryOptionsToJson(MemoryOptions instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('max_http_response_bytes', instance.maxHttpResponseBytes);
  writeNotNull('max_pages', instance.maxPages);
  writeNotNull('max_var_bytes', instance.maxVarBytes);
  return val;
}

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

Map<String, dynamic> _$WasmToJson(Wasm instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('hash', instance.hash);
  writeNotNull('name', instance.name);
  writeNotNull('path', instance.path);
  writeNotNull('data', instance.data);
  writeNotNull('headers', instance.headers);
  writeNotNull('method', instance.method);
  writeNotNull('url', instance.url);
  return val;
}

DataClass _$DataClassFromJson(Map<String, dynamic> json) => DataClass(
      len: (json['len'] as num).toInt(),
      ptr: (json['ptr'] as num).toInt(),
    );

Map<String, dynamic> _$DataClassToJson(DataClass instance) => <String, dynamic>{
      'len': instance.len,
      'ptr': instance.ptr,
    };
