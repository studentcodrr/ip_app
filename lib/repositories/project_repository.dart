import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/project_models.dart';
import '../../models/group_model.dart';
import '../../models/task_model.dart';

final projectRepoProvider = Provider(
  (ref) => ProjectRepository(FirebaseFirestore.instance),
);

class ProjectRepository {
  final FirebaseFirestore _firestore;
  ProjectRepository(this._firestore);

  // 1. Get Projects (Filtered by Membership)
  Stream<List<ProjectModel>> watchProjects(String userId) {
    return _firestore
        .collection('projects')
        .where('memberIds', arrayContains: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProjectModel.fromFirestore(doc))
              .toList(),
        );
  }

  // ... inside ProjectRepository class ...

  // <input> // NEW: Watch a single project document for real-time updates
  Stream<ProjectModel?> watchProject(String projectId) {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .snapshots()
        .map((doc) {
          if (doc.exists) {
            return ProjectModel.fromFirestore(doc);
          }
          return null;
        });
  }
  

  // 2. Add Member to Project (Invite System)
  Future<void> addMemberByEmail(String projectId, String email) async {
    // 1. Search for the user in the 'users' collection
    final userSnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (userSnapshot.docs.isEmpty) {
      throw Exception("User with email $email not found");
    }

    final userId = userSnapshot.docs.first.id;

    // 2. Add their ID to the project's 'memberIds' array
    await _firestore.collection('projects').doc(projectId).update({
      'memberIds': FieldValue.arrayUnion([userId])
    });
  }

  // ... (Groups, Tasks, and Update methods remain the same) ...
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
    String pId,
    String gId,
    String tId,
    TaskStatus status,
  ) {
    return _firestore.doc('projects/$pId/groups/$gId/tasks/$tId').update({
      'status': status.name,
    });
  }

  Future<void> updateProjectField(String pId, String field, dynamic value) {
    return _firestore.collection('projects').doc(pId).update({field: value});
  }

  Future<void> updateGroupField(
    String pId,
    String gId,
    String field,
    dynamic value,
  ) {
    return _firestore
        .collection('projects')
        .doc(pId)
        .collection('groups')
        .doc(gId)
        .update({field: value});
  }

  Future<void> updateTaskField(
    String pId,
    String gId,
    String tId,
    String field,
    dynamic value,
  ) {
    return _firestore
        .collection('projects')
        .doc(pId)
        .collection('groups')
        .doc(gId)
        .collection('tasks')
        .doc(tId)
        .update({field: value});
  }

  Future<void> createTask(String pId, String gId, TaskModel task) async {
    final docRef = _firestore
        .collection('projects')
        .doc(pId)
        .collection('groups')
        .doc(gId)
        .collection('tasks')
        .doc();
    await docRef.set(task.copyWith(id: docRef.id).toJson());
  }

  Future<void> deleteTask(String pId, String gId, String tId) {
    return _firestore
        .collection('projects')
        .doc(pId)
        .collection('groups')
        .doc(gId)
        .collection('tasks')
        .doc(tId)
        .delete();
  }

  Future<void> deleteGroup(String pId, String gId) {
    return _firestore
        .collection('projects')
        .doc(pId)
        .collection('groups')
        .doc(gId)
        .delete();
  }

  Future<void> deleteProject(String pId) {
    return _firestore.collection('projects').doc(pId).delete();
  }

  Future<void> updateTaskOrderBatch(
    String pId,
    String gId,
    List<TaskModel> tasks,
  ) async {
    final batch = _firestore.batch();
    final col = _firestore
        .collection('projects')
        .doc(pId)
        .collection('groups')
        .doc(gId)
        .collection('tasks');
    for (final task in tasks) {
      batch.update(col.doc(task.id), {'orderIndex': task.orderIndex});
    }
    await batch.commit();
  }

  // 9. Save Generated Plan (Updated)
  Future<void> saveGeneratedPlan(
    ProjectModel project,
    List<GroupModel> groups,
    Map<String, List<TaskModel>> tasksByGroup,
  ) async {
    final batch = _firestore.batch();
    final projectRef = _firestore
        .collection('projects')
        .doc(project.id.isEmpty ? null : project.id);

    final projectJson = project.toJson()..remove('id');
    projectJson['createdAt'] = Timestamp.fromDate(project.createdAt);

    //<input> // AUTO-ADD OWNER TO MEMBERS
    // This ensures the creator can see the project in the 'memberIds' query
    // Ensure owner is always in the list, but preserve existing members if any
    final currentMembers = List<String>.from(project.memberIds);
    if (!currentMembers.contains(project.ownerId)) {
      currentMembers.add(project.ownerId);
    }
    projectJson['memberIds'] = currentMembers;

    batch.set(projectRef, projectJson);

    for (var group in groups) {
      final groupRef = projectRef.collection('groups').doc();
      batch.set(
        groupRef,
        group.copyWith(id: groupRef.id).toJson()..remove('id'),
      );

      final tasks = tasksByGroup[group.id] ?? [];
      for (var task in tasks) {
        final taskRef = groupRef.collection('tasks').doc();
        final taskJson = task.toJson()..remove('id');
        taskJson['startDate'] = task.startDate != null
            ? Timestamp.fromDate(task.startDate!)
            : null;
        taskJson['endDate'] = task.endDate != null
            ? Timestamp.fromDate(task.endDate!)
            : null;
        batch.set(taskRef, taskJson);
      }
    }
    await batch.commit();
  }
}
