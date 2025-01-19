import 'package:json_annotation/json_annotation.dart';
part 'http_request.g.dart';

@JsonSerializable()
class HttpRequest {
  final String url;
  final Map<String, String> headers;
  final String method;

  HttpRequest({
    required this.url,
    required this.headers,
    required this.method,
  });
  Map<String, dynamic> toJson() => _$HttpRequestToJson(this);

  factory HttpRequest.fromJson(Map<String, dynamic> json) =>
      _$HttpRequestFromJson(json);
}
