import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_app/models/group_model.dart';
import 'package:taskflow_app/models/task_model.dart';
import 'package:taskflow_app/providers/app_providers.dart';
import 'package:taskflow_app/widgets/monday_task_row.dart';
import 'package:taskflow_app/widgets/inline_text_editor.dart'; 
import 'package:taskflow_app/features/project_features/board_controller.dart';

class ProjectGroupPair {
  final String projectId;
  final String groupId;
  const ProjectGroupPair(this.projectId, this.groupId);
  @override
  bool operator ==(Object other) => other is ProjectGroupPair && other.projectId == projectId && other.groupId == groupId;
  @override
  int get hashCode => Object.hash(projectId, groupId);
}

final groupTasksProvider = StreamProvider.family<List<TaskModel>, ProjectGroupPair>((ref, pair) {
  return ref.watch(projectRepoProvider).watchTasks(pair.projectId, pair.groupId);
});

class MondayGroup extends ConsumerWidget {
  final String projectId;
  final GroupModel group;

  const MondayGroup({super.key, required this.projectId, required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(groupTasksProvider(ProjectGroupPair(projectId, group.id)));
    final groupColor = Color(group.colorValue == 0 ? 0xFF0073EA : group.colorValue);

    return Container(
      margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.keyboard_arrow_down, color: groupColor),
              const SizedBox(width: 8),
              Expanded(
                child: InlineTextEditor(
                  text: group.name,
                  style: const TextStyle(
                    color: Colors.black87, 
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  onSave: (newName) {
                    ref.read(boardControllerProvider).updateGroupName(projectId, group.id, newName);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                tasksAsync.valueOrNull?.length.toString() ?? "0",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_horiz, color: Colors.grey.shade400),
                onSelected: (value) {
                  if (value == 'delete') {
                    ref.read(boardControllerProvider).deleteGroup(projectId, group.id);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('Delete Group', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Material(
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: Column(
              children: [
                _buildTableHeader(context),
                tasksAsync.when(
                  data: (tasks) => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                    itemBuilder: (context, index) {
                      return MondayTaskRow(
                        task: tasks[index], 
                        projectId: projectId, 
                        groupId: group.id
                      );
                    },
                  ),
                  loading: () => const LinearProgressIndicator(minHeight: 2),
                  error: (e, s) => Padding(padding: const EdgeInsets.all(16), child: Text("Error: $e")),
                ),
                _buildAddTaskFooter(ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50, 
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: const Row(
        children: [
          SizedBox(width: 30), 
          Expanded(flex: 6, child: Text("Item", style: TextStyle(color: Colors.grey, fontSize: 12))),
          Expanded(flex: 3, child: Center(child: Text("Status", style: TextStyle(color: Colors.grey, fontSize: 12)))),
          Expanded(flex: 3, child: Center(child: Text("Priority", style: TextStyle(color: Colors.grey, fontSize: 12)))),
          Expanded(flex: 4, child: Center(child: Text("Timeline", style: TextStyle(color: Colors.grey, fontSize: 12)))),
          SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildAddTaskFooter(WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(boardControllerProvider).addTask(projectId, group.id);
      },
      child: Container(
        height: 40,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        padding: const EdgeInsets.only(left: 42), 
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(Icons.add, size: 16, color: Colors.grey.shade500),
            const SizedBox(width: 8),
            Text("Add Item", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}