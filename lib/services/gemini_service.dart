import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:taskflow_app/models/project_model.dart';
import 'package:taskflow_app/models/group_model.dart';
import 'package:taskflow_app/models/task_model.dart';

class GeminiService {
  final Uuid _uuid = const Uuid();
  final http.Client _client; 

  GeminiService({http.Client? client}) : _client = client ?? http.Client();

  static const String backendUrl = "http://localhost:5000/generate-plan";

  Future<Map<String, dynamic>> generateProjectStructure(
    String description,
    String strategy,
  ) async {
    final uri = Uri.parse(backendUrl);

    final response = await _client.post(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "description": description,
        "strategy": strategy,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Server returned ${response.statusCode}: ${response.body}",
      );
    }

    final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return _parseModels(jsonResponse);
  }

  Map<String, dynamic> _parseModels(Map<String, dynamic> json) {
    final now = DateTime.now();

    final project = ProjectModel(
      id: "",
      name: json["projectName"] ?? "Untitled Project",
      description: "AI-generated project plan",
      ownerId: "current_user_id",
      createdAt: now,
      //<input> // Map Audit Fields
      auditScore: json['audit_score'] as int? ?? 0,
      auditFeedback: json['audit_feedback'] as String? ?? '',
    );

    final List<GroupModel> groups = [];
    final Map<String, List<TaskModel>> tasksByGroup = {};

    final rawGroups = json["groups"] as List;
    
    for (int i = 0; i < rawGroups.length; i++) {
      final gData = rawGroups[i];
      final groupId = _uuid.v4();
      
      final int phaseStartDay = gData["phaseStartDay"] as int? ?? (i * 7);

      groups.add(GroupModel(
        id: groupId,
        name: gData["groupName"] ?? "Untitled Phase",
        orderIndex: i.toDouble(),
      ));

      final rawTasks = gData["tasks"] as List;
      final List<TaskModel> taskList = [];

      for (int j = 0; j < rawTasks.length; j++) {
        final tData = rawTasks[j];
        final duration = tData["durationDays"] as int? ?? 1;
        final startOffset = tData["startDayOffset"] as int? ?? 0;
        final taskStart = now.add(Duration(days: phaseStartDay + startOffset));

        taskList.add(TaskModel(
          id: "",
          name: tData["taskName"] ?? "Task",
          ownerId: "Unassigned",
          status: TaskStatus.notStarted,
          priority: _parsePriority(tData["priority"]),
          startDate: taskStart,
          endDate: taskStart.add(Duration(days: duration)),
          dependencies: [],
          orderIndex: j.toDouble(),
        ));
      }
      tasksByGroup[groupId] = taskList;
    }

    return {
      "project": project,
      "groups": groups,
      "tasksByGroup": tasksByGroup,
    };
  }

  Priority _parsePriority(String? p) {
    switch(p?.toLowerCase()) {
      case 'high': return Priority.high;
      case 'low': return Priority.low;
      default: return Priority.medium;
    }
  }
}