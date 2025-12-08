import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:taskflow_app/models/task_model.dart';
import 'package:taskflow_app/features/project_features/board_controller.dart';
import 'package:taskflow_app/utils/monday_theme.dart';
import 'package:taskflow_app/widgets/inline_text_editor.dart';
import 'package:taskflow_app/models/app_user_model.dart';

class MondayTaskRow extends ConsumerWidget {
  final TaskModel task;
  final String projectId;
  final String groupId;
  final List<AppUserModel> projectMembers;

  const MondayTaskRow({
    super.key,
    required this.task,
    required this.projectId,
    required this.groupId,
    this.projectMembers = const [],
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
          // 1. Drag Handle Spacer (Dots removed, space kept for alignment)
          const SizedBox(width: 30),

          // 2. Editable Name (Matches Header: Expanded flex 6)
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.only(left: 12, right: 16),
              alignment: Alignment.centerLeft,
              child: InlineTextEditor(
                text: task.name,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
                onSave: (val) => controller.updateTaskName(projectId, groupId, task.id, val),
              ),
            ),
          ),

          // 3. OWNER ASSIGNMENT (Matches Header: Fixed Width 40)
          SizedBox(
            width: 40,
            child: Center(child: _buildOwnerCell(ref)),
          ),

          // 4. Status (Matches Header: Expanded flex 3)
          Expanded(flex: 3, child: _buildStatusCell(ref, task.status)),

          // 5. Priority (Matches Header: Expanded flex 3)
          Expanded(flex: 3, child: _buildPriorityCell(ref, task.priority)),

          // 6. Deadline (Matches Header: Expanded flex 4)
          Expanded(flex: 3, child: _buildDeadlineCell(context, ref, task.endDate)),

          // 7. Rounded Delete Button (Matches Header: Spacer 40)
          SizedBox(
            width: 40,
            child: Center(
              child: InkWell(
                onTap: () {
                   controller.deleteTask(projectId, groupId, task.id);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 24, 
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100, // Subtle background
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(
                    Icons.close, // Clean "X" symbol
                    size: 14, 
                    color: Colors.grey
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildOwnerCell(WidgetRef ref) {
    // Find the current owner object
    final ownerUser = projectMembers.firstWhere(
      (user) => user.id == task.ownerId, 
      orElse: () => const AppUserModel(id: '', email: '', displayName: ''), 
    );
    final isUnassigned = task.ownerId == 'Unassigned' || task.ownerId.isEmpty;
    
    return PopupMenuButton<String>(
      tooltip: "Assign to...",
      padding: EdgeInsets.zero,
      itemBuilder: (context) {
        return [
           const PopupMenuItem(value: 'Unassigned', child: Text("Clear Assignment")),
           ...projectMembers.map((user) => PopupMenuItem(
             value: user.id,
             child: Row(
               children: [
                 CircleAvatar(
                    radius: 10, 
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : '?', 
                      style: const TextStyle(fontSize: 10)
                    ),
                 ),
                 const SizedBox(width: 8),
                 Text(user.displayName, style: const TextStyle(fontSize: 13)),
               ],
             ),
           )),
        ];
      },
      onSelected: (newOwnerId) {
        ref.read(boardControllerProvider).updateTaskOwner(
           projectId, groupId, task.id, newOwnerId
        );
      },
      child: CircleAvatar(
        radius: 13, 
        backgroundColor: isUnassigned ? Colors.grey.shade300 : Colors.blue,
        child: isUnassigned 
            ? const Icon(Icons.person_outline, size: 16, color: Colors.white)
            : Text(
                ownerUser.displayName.isNotEmpty ? ownerUser.displayName[0].toUpperCase() : '?', 
                style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
              ),
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
      padding: EdgeInsets.zero,
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