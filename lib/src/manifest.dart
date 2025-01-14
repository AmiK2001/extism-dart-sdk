// Schema: https://raw.githubusercontent.com/extism/extism/main/manifest/schema.json

import 'package:json_annotation/json_annotation.dart';

part 'manifest.g.dart';

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)

///The `Manifest` type is used to configure the runtime and specify how to load modules.
final class Manifest {
  ///Specifies which hosts may be accessed via HTTP, if this is empty then no hosts may be
  ///accessed. Wildcards may be used.
  final List<String>? allowedHosts;

  ///Specifies which paths should be made available on disk when using WASI. This is a mapping
  ///from the path on disk to the path it should be available inside the plugin. For example,
  ///`".": "/tmp"` would mount the current directory as `/tmp` inside the module
  final Map<String, String>? allowedPaths;

  ///Config values are made accessible using the PDK `extism_config_get` function
  final Map<String, String>? config;

  ///Memory options
  final MemoryOptions? memory;

  ///The plugin timeout in milliseconds
  final int? timeoutMs;

  ///WebAssembly modules, the `main` module should be named `main` or listed last
  final List<Wasm>? wasm;

  Manifest({
    this.allowedHosts,
    this.allowedPaths,
    this.config,
    this.memory,
    this.timeoutMs,
    this.wasm,
  });

  factory Manifest.fromJson(Map<String, dynamic> json) =>
      _$ManifestFromJson(json);
  Map<String, dynamic> toJson() => _$ManifestToJson(this);
}

///Memory options
///
///Configure memory settings
@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
final class MemoryOptions {
  ///The maximum number of bytes allowed in an HTTP response
  final int? maxHttpResponseBytes;

  ///The max number of WebAssembly pages that should be allocated
  final int? maxPages;

  ///The maximum number of bytes allowed to be used by plugin vars. Setting this to 0 will
  ///disable Extism vars. The default value is 1mb.
  final int? maxVarBytes;

  MemoryOptions({
    this.maxHttpResponseBytes,
    this.maxPages,
    this.maxVarBytes,
  });

  factory MemoryOptions.fromJson(Map<String, dynamic> json) =>
      _$MemoryOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$MemoryOptionsToJson(this);
}

///The `Wasm` type specifies how to access a WebAssembly module
///
///From disk
///
///From memory
///
///Via HTTP
@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
final class Wasm {
  ///Module hash, if the data loaded from disk or via HTTP doesn't match an error will be
  ///raised
  final String? hash;

  ///Module name, this is used by Extism to determine which is the `main` module
  final String? name;
  final String? path;
  final dynamic data;

  ///Request headers
  final Map<String, String>? headers;

  ///Request method
  final String? method;

  ///The request URL
  final String? url;

  Wasm({
    this.hash,
    this.name,
    this.path,
    this.data,
    this.headers,
    this.method,
    this.url,
  });

  factory Wasm.fromJson(Map<String, dynamic> json) => _$WasmFromJson(json);
  Map<String, dynamic> toJson() => _$WasmToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
  includeIfNull: false,
  fieldRename: FieldRename.snake,
)
final class DataClass {
  final int len;
  final int ptr;

  DataClass({
    required this.len,
    required this.ptr,
  });

  factory DataClass.fromJson(Map<String, dynamic> json) =>
      _$DataClassFromJson(json);
  Map<String, dynamic> toJson() => _$DataClassToJson(this);
}
