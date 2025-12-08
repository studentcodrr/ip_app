import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_app/models/task_model.dart';
import 'package:taskflow_app/providers/app_providers.dart';

class BoardController {
  final Ref ref;
  BoardController(this.ref);

  // --- TASK UPDATES ---
  
  Future<void> updateTaskStatus(
    String pId,
    String gId,
    String tId,
    TaskStatus status,
  ) {
    return ref
        .read(projectRepoProvider)
        .updateTaskField(pId, gId, tId, 'status', status.name);
  }

  Future<void> updateTaskPriority(
    String pId,
    String gId,
    String tId,
    Priority priority,
  ) {
    return ref
        .read(projectRepoProvider)
        .updateTaskField(pId, gId, tId, 'priority', priority.name);
  }

  Future<void> updateTaskName(
    String pId,
    String gId,
    String tId,
    String newName,
  ) {
    return ref
        .read(projectRepoProvider)
        .updateTaskField(pId, gId, tId, 'name', newName);
  }

  Future<void> updateTaskDeadline(
    String pId,
    String gId,
    String tId,
    DateTime date,
  ) {
    return ref
        .read(projectRepoProvider)
        .updateTaskField(pId, gId, tId, 'endDate', date);
  }

  // <input> // NEW: Assign a member to a task
  Future<void> updateTaskOwner(
    String pId,
    String gId,
    String tId,
    String newOwnerId,
  ) {
    return ref
        .read(projectRepoProvider)
        .updateTaskField(pId, gId, tId, 'ownerId', newOwnerId);
  }

  // --- GROUP UPDATES ---
  Future<void> updateGroupName(String pId, String gId, String newName) {
    return ref
        .read(projectRepoProvider)
        .updateGroupField(pId, gId, 'name', newName);
  }

  // --- PROJECT UPDATES ---
  Future<void> updateProjectName(String pId, String newName) {
    return ref
        .read(projectRepoProvider)
        .updateProjectField(pId, 'name', newName);
  }

  // <input> // NEW: Invite a user to the project
  Future<void> inviteUserToProject(String pId, String email) {
    return ref
        .read(projectRepoProvider)
        .addMemberByEmail(pId, email);
  }

  // --- CRUD OPERATIONS ---
  Future<void> addTask(String projectId, String groupId) {
    final now = DateTime.now();

    final newTask = TaskModel(
      id: '',
      name: "New Item",
      ownerId: "Unassigned",
      status: TaskStatus.notStarted,
      priority: Priority.medium,
      startDate: now,
      endDate: now.add(const Duration(days: 1)),
      orderIndex: 99999, 
      dependencies: [],
    );

    return ref
        .read(projectRepoProvider)
        .createTask(projectId, groupId, newTask);
  }

  Future<void> deleteTask(String pId, String gId, String tId) {
    return ref.read(projectRepoProvider).deleteTask(pId, gId, tId);
  }

  Future<void> deleteGroup(String pId, String gId) {
    return ref.read(projectRepoProvider).deleteGroup(pId, gId);
  }

  Future<void> deleteProject(String pId) {
    return ref.read(projectRepoProvider).deleteProject(pId);
  }

  // --- REORDERING ---
  Future<void> reorderTasks(
    String projectId,
    String groupId,
    int oldIndex,
    int newIndex,
    List<TaskModel> currentTasks,
  ) async {
    final updatedTasks = List<TaskModel>.from(currentTasks);
    
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    
    final taskToMove = updatedTasks.removeAt(oldIndex);
    updatedTasks.insert(newIndex, taskToMove);

    for (int i = 0; i < updatedTasks.length; i++) {
      updatedTasks[i] = updatedTasks[i].copyWith(orderIndex: i.toDouble()); 
    }

    await ref
        .read(projectRepoProvider)
        .updateTaskOrderBatch(projectId, groupId, updatedTasks);
  }
}

final boardControllerProvider = Provider((ref) => BoardController(ref));