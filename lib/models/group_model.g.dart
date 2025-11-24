// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupModelImpl _$$GroupModelImplFromJson(Map<String, dynamic> json) =>
    _$GroupModelImpl(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Untitled Group',
      orderIndex: (json['orderIndex'] as num?)?.toDouble() ?? 0.0,
      colorValue: (json['colorValue'] as num?)?.toInt() ?? 0xFFEEEEEE,
    );

Map<String, dynamic> _$$GroupModelImplToJson(_$GroupModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'orderIndex': instance.orderIndex,
      'colorValue': instance.colorValue,
    };
