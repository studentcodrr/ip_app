import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../features/project_features/board_controller.dart';
import '../utils/monday_theme.dart';
import 'inline_text_editor.dart';

class MondayTaskRow extends ConsumerWidget {
  final TaskModel task;
  final String projectId;
  final String groupId;

  const MondayTaskRow({
    super.key,
    required this.task,
    required this.projectId,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(boardControllerProvider);

    return Container(
      height: 44, 
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 30,
            child: Icon(Icons.drag_indicator, color: Colors.black12, size: 16),
          ),

          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.only(right: 16),
              alignment: Alignment.centerLeft,
              child: InlineTextEditor(
                text: task.name,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
                onSave: (val) => controller.updateTaskName(projectId, groupId, task.id, val),
              ),
            ),
          ),

          Expanded(flex: 3, child: _buildStatusCell(ref, task.status)),

          Expanded(flex: 3, child: _buildPriorityCell(ref, task.priority)),

          Expanded(flex: 3, child: _buildDeadlineCell(context, ref, task.endDate)),

          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.grey),
            tooltip: "Delete Task",
            onPressed: () {
               controller.deleteTask(projectId, groupId, task.id);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCell(WidgetRef ref, TaskStatus status) {
    return GestureDetector(
      onTap: () {
        final next = TaskStatus.values[(status.index + 1) % TaskStatus.values.length];
        ref.read(boardControllerProvider).updateTaskStatus(projectId, groupId, task.id, next);
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        color: MondayTheme.getStatusColor(status),
        alignment: Alignment.center,
        child: Text(
          status.name.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPriorityCell(WidgetRef ref, Priority priority) {
    return PopupMenuButton<Priority>(
      initialValue: priority,
      tooltip: "Change Priority",
      color: Colors.white,
      onSelected: (val) {
        ref.read(boardControllerProvider).updateTaskPriority(projectId, groupId, task.id, val);
      },
      itemBuilder: (context) => Priority.values.map((p) {
        return PopupMenuItem(
          value: p,
          child: Row(
            children: [
              Icon(Icons.flag, color: MondayTheme.getPriorityColor(p), size: 16),
              const SizedBox(width: 8),
              Text(p.name.toUpperCase(), style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
      }).toList(),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          priority.name.toUpperCase(),
          style: TextStyle(
            color: MondayTheme.getPriorityColor(priority),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDeadlineCell(BuildContext context, WidgetRef ref, DateTime? date) {
    final isOverdue = date != null && date.isBefore(DateTime.now()) && task.status != TaskStatus.done;
    
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          ref.read(boardControllerProvider).updateTaskDeadline(projectId, groupId, task.id, picked);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: isOverdue ? Colors.red.withOpacity(0.9) : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          date != null ? DateFormat('MMM d').format(date) : "-",
          style: const TextStyle(color: Colors.white, fontSize: 11),
        ),
      ),
    );
  }
}