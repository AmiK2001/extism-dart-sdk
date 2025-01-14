// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manifest_http_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManifestHttpRequest _$ManifestHttpRequestFromJson(Map<String, dynamic> json) =>
    ManifestHttpRequest(
      url: json['url'] as String,
      header: Map<String, String>.from(json['header'] as Map),
      method: json['method'] as String,
    );

Map<String, dynamic> _$ManifestHttpRequestToJson(
        ManifestHttpRequest instance) =>
    <String, dynamic>{
      'url': instance.url,
      'header': instance.header,
      'method': instance.method,
    };
