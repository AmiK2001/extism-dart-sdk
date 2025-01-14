// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemoryOptions _$MemoryOptionsFromJson(Map<String, dynamic> json) =>
    MemoryOptions(
      maxPages: (json['maxPages'] as num).toInt(),
      maxHttpResponseBytes: (json['maxHttpResponseBytes'] as num).toInt(),
    );

Map<String, dynamic> _$MemoryOptionsToJson(MemoryOptions instance) =>
    <String, dynamic>{
      'maxPages': instance.maxPages,
      'maxHttpResponseBytes': instance.maxHttpResponseBytes,
    };
