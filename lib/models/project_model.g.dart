// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectModelImpl _$$ProjectModelImplFromJson(Map<String, dynamic> json) =>
    _$ProjectModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      ownerId: json['ownerId'] as String,
      colorValue: (json['colorValue'] as num?)?.toInt() ?? 0xFF42A5F5,
      createdAt: _fromJsonTimestamp(json['createdAt']),
      auditScore: (json['auditScore'] as num?)?.toInt() ?? 0,
      auditFeedback: json['auditFeedback'] as String? ?? '',
    );

Map<String, dynamic> _$$ProjectModelImplToJson(_$ProjectModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'ownerId': instance.ownerId,
      'colorValue': instance.colorValue,
      'createdAt': _toJsonTimestamp(instance.createdAt),
      'auditScore': instance.auditScore,
      'auditFeedback': instance.auditFeedback,
    };
