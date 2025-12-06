import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:taskflow_app/services/gemini_service.dart';
import 'package:taskflow_app/models/project_model.dart';
import 'package:taskflow_app/models/group_model.dart';
import 'package:taskflow_app/models/task_model.dart';

//<input> // Annotation to generate the MockClient
@GenerateMocks([http.Client])
import 'gemini_service_test.mocks.dart';

void main() {
  late GeminiService service;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    service = GeminiService(client: mockClient);
  });

  const String validJsonResponse = '''
  {
    "projectName": "Test Project",
    "groups": [
      {
        "groupName": "Phase 1",
        "tasks": [
          {
            "taskName": "Task A",
            "description": "Desc A",
            "priority": "High",
            "durationDays": 2
          }
        ]
      }
    ]
  }
  ''';

  group('GeminiService Tests', () {
    test('generateProjectStructure returns parsed models on 200 OK', () async {
      // 1. Arrange
      when(mockClient.post(
        Uri.parse("http://127.0.0.1:5000/generate-plan"),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(validJsonResponse, 200));

      // 2. Act
      final result = await service.generateProjectStructure("Build a house", "Fast");

      // 3. Assert
      expect(result['project'], isA<ProjectModel>());
      expect((result['project'] as ProjectModel).name, "Test Project");
      
      final groups = result['groups'] as List<GroupModel>;
      expect(groups.length, 1);
      expect(groups.first.name, "Phase 1");

      final tasksMap = result['tasksByGroup'] as Map<String, List<TaskModel>>;
      final groupId = groups.first.id;
      expect(tasksMap[groupId]?.length, 1);
      expect(tasksMap[groupId]?.first.name, "Task A");
      expect(tasksMap[groupId]?.first.priority, Priority.high);
    });

    test('generateProjectStructure throws Exception on non-200 response', () async {
      // 1. Arrange
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

      // 2. Act & Assert
      expect(
        () async => await service.generateProjectStructure("Test", "Test"),
        throwsException,
      );
    });

    test('generateProjectStructure throws FormatException on invalid JSON', () async {
      // 1. Arrange
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Not JSON', 200));

      // 2. Act & Assert
      expect(
        () async => await service.generateProjectStructure("Test", "Test"),
        throwsA(isA<FormatException>()),
      );
    });
  });
}