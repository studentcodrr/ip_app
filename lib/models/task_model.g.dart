// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      ownerId: json['ownerId'] as String,
      status:
          $enumDecodeNullable(_$TaskStatusEnumMap, json['status']) ??
          TaskStatus.notStarted,
      priority:
          $enumDecodeNullable(_$PriorityEnumMap, json['priority']) ??
          Priority.medium,
      startDate: _nullableTimestampFromJson(json['startDate']),
      endDate: _nullableTimestampFromJson(json['endDate']),
      dependencies:
          (json['dependencies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      orderIndex: (json['orderIndex'] as num).toDouble(),
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ownerId': instance.ownerId,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'priority': _$PriorityEnumMap[instance.priority]!,
      'startDate': _nullableTimestampToJson(instance.startDate),
      'endDate': _nullableTimestampToJson(instance.endDate),
      'dependencies': instance.dependencies,
      'orderIndex': instance.orderIndex,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.notStarted: 'not_started',
  TaskStatus.working: 'working',
  TaskStatus.stuck: 'stuck',
  TaskStatus.done: 'done',
};

const _$PriorityEnumMap = {
  Priority.low: 'low',
  Priority.medium: 'medium',
  Priority.high: 'high',
};
