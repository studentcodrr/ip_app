// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SearchHistoryModelImpl _$$SearchHistoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$SearchHistoryModelImpl(
  id: json['id'] as String,
  description: json['description'] as String? ?? 'Unknown Prompt',
  strategy: json['strategy'] as String? ?? '',
  createdAt: _fromJsonTimestamp(json['createdAt']),
);

Map<String, dynamic> _$$SearchHistoryModelImplToJson(
  _$SearchHistoryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'strategy': instance.strategy,
  'createdAt': _toJsonTimestamp(instance.createdAt),
};
