import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:taskflow_app/services/gemini_service.dart';
import 'package:taskflow_app/models/project_model.dart';
import 'package:taskflow_app/models/group_model.dart';
// Import your FakeHttpClient implementation
import 'fake_http_client.dart'; 

void main() {
  // Sample response matching the expected Gemini structure
  const String successJson = '''
  {
    "projectName": "Test Project",
    "groups": [{
      "groupName": "Phase A",
      "tasks": [
        {"taskName": "Test Task", "description": "desc", "priority": "Medium", "durationDays": 1}
      ]
    }]
  }
  ''';

  group('GeminiService Fake Client Tests', () {
    test('generateProjectStructure returns parsed models on 200 OK', () async {
      // 1. Arrange: Inject the Fake Client configured for success
      final fakeClient = FakeHttpClient(successJson, 200);
      final service = GeminiService(client: fakeClient);

      // 2. Act
      final result = await service.generateProjectStructure("Test Goal", "Test Strategy");

      // 3. Assert
      expect(result['project'], isA<ProjectModel>());
      expect((result['project'] as ProjectModel).name, "Test Project");
      expect((result['groups'] as List<GroupModel>).length, 1);
    });

    test('generateProjectStructure throws Exception on 500 failure', () async {
      // 1. Arrange: Inject the Fake Client configured for 500 error
      final fakeClient = FakeHttpClient('{"error": "API failed"}', 500);
      final service = GeminiService(client: fakeClient);

      // 2. Act & Assert
      expect(
        () async => await service.generateProjectStructure("Test Goal", "Test Strategy"),
        throwsException, // Expect the service to throw on the 500 status code
      );
    });
  });
}