// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HttpRequest _$HttpRequestFromJson(Map<String, dynamic> json) => HttpRequest(
      url: json['url'] as String,
      headers: Map<String, String>.from(json['headers'] as Map),
      method: json['method'] as String,
    );

Map<String, dynamic> _$HttpRequestToJson(HttpRequest instance) =>
    <String, dynamic>{
      'url': instance.url,
      'headers': instance.headers,
      'method': instance.method,
    };
