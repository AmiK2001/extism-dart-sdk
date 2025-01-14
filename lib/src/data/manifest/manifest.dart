import 'package:dart_sdk/src/data/manifest/memory_options.dart';
import 'package:dart_sdk/src/data/wasm/wasm_source.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'manifest.freezed.dart';
part 'manifest.g.dart';

@freezed
class Manifest with _$Manifest {
  const factory Manifest({
    required List<WasmSource> wasm,
    required MemoryOptions memory,
    required List<String> allowedHosts,
    required Map<String, String> allowedPaths,
    required Map<String, String> config,
  }) = _Manifest;

  factory Manifest.fromJson(Map<String, dynamic> json) =>
      _$ManifestFromJson(json);
}
