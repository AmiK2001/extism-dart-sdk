import 'package:json_annotation/json_annotation.dart';

part 'manifest_http_request.g.dart';

@JsonSerializable()
final class ManifestHttpRequest {
  final String url;
  final Map<String, String> header;
  final String method;

  ManifestHttpRequest({
    required this.url,
    required this.header,
    required this.method,
  });

  factory ManifestHttpRequest.fromJson(Map<String, dynamic> json) =>
      _$ManifestHttpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ManifestHttpRequestToJson(this);
}
