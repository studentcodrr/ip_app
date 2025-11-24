import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

enum TaskStatus {
  @JsonValue('not_started') notStarted,
  @JsonValue('working') working,
  @JsonValue('stuck') stuck,
  @JsonValue('done') done;
}

enum Priority {
  @JsonValue('low') low,
  @JsonValue('medium') medium,
  @JsonValue('high') high;
}

@freezed
class TaskModel with _$TaskModel {
  const TaskModel._();

  const factory TaskModel({
    required String id,
    required String name,
    required String ownerId,
    @Default(TaskStatus.notStarted) TaskStatus status,
    @Default(Priority.medium) Priority priority,
    DateTime? startDate,
    DateTime? endDate,
    @Default([]) List<String> dependencies,
    required double orderIndex,
  }) = _TaskModel;

  int get durationDays {
    if (startDate == null || endDate == null) return 0;
    return endDate!.difference(startDate!).inDays + 1;
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    return TaskModel(
      id: doc.id,
      name: data['name'] as String? ?? 'Untitled Task',
      ownerId: data['ownerId'] as String? ?? 'Unassigned',
      status: TaskStatus.values.firstWhere(
        (e) => e.name == (data['status'] as String?),
        orElse: () => TaskStatus.notStarted,
      ),
      priority: Priority.values.firstWhere(
        (e) => e.name == (data['priority'] as String?),
        orElse: () => Priority.medium,
      ),
      startDate: (data['startDate'] as Timestamp?)?.toDate(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
      dependencies: (data['dependencies'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      orderIndex: (data['orderIndex'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

DateTime? _nullableTimestampFromJson(dynamic timestamp) => (timestamp as Timestamp?)?.toDate();
dynamic _nullableTimestampToJson(DateTime? date) => date != null ? Timestamp.fromDate(date) : null;