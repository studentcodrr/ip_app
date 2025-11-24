import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/project_models.dart';

final projectRepoProvider = Provider(
  (ref) => ProjectRepository(FirebaseFirestore.instance),
);

class ProjectRepository {
  final FirebaseFirestore _firestore;
  ProjectRepository(this._firestore);

  Stream<List<ProjectModel>> watchProjects(String userId) {
    return _firestore
        .collection('projects')
        .where('ownerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProjectModel.fromFirestore(doc))
              .toList(),
        );
  }

  Stream<List<GroupModel>> watchGroups(String projectId) {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .collection('groups')
        .orderBy('orderIndex')
        .snapshots()
        .map((s) => s.docs.map((d) => GroupModel.fromFirestore(d)).toList());
  }

  Stream<List<TaskModel>> watchTasks(String projectId, String groupId) {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .collection('groups')
        .doc(groupId)
        .collection('tasks')
        .orderBy('orderIndex')
        .snapshots()
        .map((s) => s.docs.map((d) => TaskModel.fromFirestore(d)).toList());
  }

  Future<void> updateTaskStatus(
    String projectId,
    String groupId,
    String taskId,
    TaskStatus status,
  ) {
    return _firestore
        .doc('projects/$projectId/groups/$groupId/tasks/$taskId')
        .update({'status': status.name});
  }

  Future<void> updateProjectField(
    String projectId,
    String field,
    dynamic value,
  ) {
    return _firestore.collection('projects').doc(projectId).update({
      field: value,
    });
  }

  Future<void> updateGroupField(
    String projectId,
    String groupId,
    String field,
    dynamic value,
  ) {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .collection('groups')
        .doc(groupId)
        .update({field: value});
  }

  Future<void> updateTaskField(
    String projectId,
    String groupId,
    String taskId,
    String field,
    dynamic value,
  ) {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .collection('groups')
        .doc(groupId)
        .collection('tasks')
        .doc(taskId)
        .update({field: value});
  }

  Future<void> createTask(
    String projectId,
    String groupId,
    TaskModel task,
  ) async {
    final docRef = _firestore
        .collection('projects')
        .doc(projectId)
        .collection('groups')
        .doc(groupId)
        .collection('tasks')
        .doc();

    final taskWithId = task.copyWith(id: docRef.id);

    await docRef.set(taskWithId.toJson());
  }

  Future<void> saveGeneratedPlan(
    ProjectModel project,
    List<GroupModel> groups,
    Map<String, List<TaskModel>> tasksByGroup,
  ) async {
    final batch = _firestore.batch();

    final projectRef = _firestore
        .collection('projects')
        .doc(project.id.isEmpty ? null : project.id);
    batch.set(
      projectRef,
      project.toJson()..remove('id'),
    ); 

    for (var group in groups) {
      final groupRef = projectRef.collection('groups').doc();
      batch.set(
        groupRef,
        group.copyWith(id: groupRef.id).toJson()..remove('id'),
      );

      final tasks = tasksByGroup[group.id] ?? [];

      for (var task in tasks) {
        final taskRef = groupRef.collection('tasks').doc();
        final json = task.toJson()..remove('id');
        json['startDate'] = task.startDate != null
            ? Timestamp.fromDate(task.startDate!)
            : null;
        json['endDate'] = task.endDate != null
            ? Timestamp.fromDate(task.endDate!)
            : null;

        batch.set(taskRef, json);
      }
    }
    await batch.commit();
  }

  Future<void> deleteTask(String projectId, String groupId, String taskId) {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .collection('groups')
        .doc(groupId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  Future<void> deleteGroup(String projectId, String groupId) {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .collection('groups')
        .doc(groupId)
        .delete();
  }

  Future<void> deleteProject(String projectId) {
    return _firestore.collection('projects').doc(projectId).delete();
  }

  Future<void> updateTaskOrderBatch(
    String projectId,
    String groupId,
    List<TaskModel> tasks,
  ) async {
    final batch = _firestore.batch();
    final groupCollection = _firestore
        .collection('projects')
        .doc(projectId)
        .collection('groups')
        .doc(groupId)
        .collection('tasks');

    for (final task in tasks) {
      final taskRef = groupCollection.doc(task.id);
      batch.update(taskRef, {'orderIndex': task.orderIndex});
    }
    await batch.commit();
  }
}