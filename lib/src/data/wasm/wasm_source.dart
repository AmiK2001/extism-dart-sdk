import 'package:json_annotation/json_annotation.dart';

part 'wasm_source.g.dart';

@JsonSerializable()
final class WasmSource {
  final String name;
  final String hash;

  WasmSource({required this.name, required this.hash});

  factory WasmSource.fromJson(Map<String, dynamic> json) =>
      _$WasmSourceFromJson(json);

  Map<String, dynamic> toJson() => _$WasmSourceToJson(this);
}
