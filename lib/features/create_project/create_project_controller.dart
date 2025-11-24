import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/group_model.dart';
import '../../models/project_model.dart';
import '../../models/task_model.dart';
import '../../providers/app_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProjectProposal {
  final ProjectModel project;
  final List<GroupModel> groups;
  final Map<String, List<TaskModel>> tasksByGroup;
  final String userDescription;
  final String userStrategy;

  ProjectProposal({
    required this.project,
    required this.groups,
    required this.tasksByGroup,
    required this.userDescription,
    required this.userStrategy,
  });
}

final createProjectControllerProvider = 
    AsyncNotifierProvider<CreateProjectController, void>(CreateProjectController.new);

class CreateProjectController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    return null;
  }

  Future<ProjectProposal?> generateProjectProposal({
    required String description, 
    required String strategy
  }) async {
    state = const AsyncValue.loading();
    ProjectProposal? proposal;

    state = await AsyncValue.guard(() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      ref.read(historyRepoProvider).addHistory(user.uid, description, strategy); //<input>// Save user prompt to history

      final geminiService = ref.read(geminiServiceProvider);
      
      final result = await geminiService.generateProjectStructure(description, strategy);
      
      var project = result['project'] as ProjectModel;
      final groups = result['groups'] as List<GroupModel>;
      final tasksByGroup = result['tasksByGroup'] as Map<String, List<TaskModel>>;

      project = project.copyWith(description: description);

      proposal = ProjectProposal(
        project: project, 
        groups: groups, 
        tasksByGroup: tasksByGroup,
        userDescription: description,
        userStrategy: strategy,
      );
    });

    return proposal;
  }
}