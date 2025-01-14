import 'package:json_annotation/json_annotation.dart';

part 'memory_options.g.dart';

@JsonSerializable()
final class MemoryOptions {
  final int maxPages;
  final int maxHttpResponseBytes;

  MemoryOptions({
    required this.maxPages,
    required this.maxHttpResponseBytes,
  });

  factory MemoryOptions.fromJson(Map<String, dynamic> json) =>
      _$MemoryOptionsFromJson(json);

  Map<String, dynamic> toJson() => _$MemoryOptionsToJson(this);
}
