import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_app/models/project_model.dart';
import 'package:taskflow_app/models/group_model.dart';
import 'package:taskflow_app/models/app_user_model.dart';
import 'package:taskflow_app/widgets/monday_group.dart';
import 'package:taskflow_app/widgets/inline_text_editor.dart';
import 'package:taskflow_app/features/project_features/board_controller.dart';
import 'package:taskflow_app/providers/app_providers.dart';
import 'package:taskflow_app/widgets/sidebar.dart';
import 'package:taskflow_app/widgets/timeline_view.dart'; 

final groupsProvider = StreamProvider.family<List<GroupModel>, String>((ref, projectId) {
  return ref.watch(projectRepoProvider).watchGroups(projectId);
});

// NEW: Provider to watch the single, live project document
final liveProjectProvider = StreamProvider.family<ProjectModel?, String>((ref, projectId) {
  return ref.watch(projectRepoProvider).watchProject(projectId);
});

// Fetch all members of this project
final projectMembersProvider = StreamProvider.family<List<AppUserModel>, List<String>>((ref, memberIds) {
  return ref.watch(userRepoProvider).watchUsers(memberIds);
});

class ProjectBoardScreen extends ConsumerStatefulWidget {
  // <input> // Screen now takes ID
  final String projectId; 

  const ProjectBoardScreen({super.key, required this.projectId});

  @override
  ConsumerState<ProjectBoardScreen> createState() => _ProjectBoardScreenState();
}

class _ProjectBoardScreenState extends ConsumerState<ProjectBoardScreen> {
  bool _isTimelineView = false; 

  Future<void> _showInviteDialog(String projectId) async {
    final emailCtrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Invite Member"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter the email of the user to invite."),
            const SizedBox(height: 16),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (emailCtrl.text.isNotEmpty) {
                try {
                  await ref.read(boardControllerProvider).inviteUserToProject(
                    projectId, 
                    emailCtrl.text.trim()
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("User invited successfully!")),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text("Invite"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. WATCH THE LIVE PROJECT STATE
    final liveProjectAsync = ref.watch(liveProjectProvider(widget.projectId));

    // 2. Safely extract the live project data and build the UI
    return liveProjectAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => Scaffold(body: Center(child: Text("Error loading project: $e"))),
      data: (project) {
        if (project == null) return const Scaffold(body: Center(child: Text("Project not found")));

        // Use the LIVE project object from the stream
        final groupsAsync = ref.watch(groupsProvider(project.id));
        final membersAsync = ref.watch(projectMembersProvider(project.memberIds));
        
        final int score = project.auditScore;
        final String feedback = project.auditFeedback;

        final Color scoreColor = score >= 80 ? Colors.green 
                             : score >= 50 ? Colors.orange 
                             : Colors.red;
                             
        // Format feedback for clean tooltip steps
        final formattedFeedback = feedback
            .split(RegExp(r'(?=Step \d+:)'))
            .where((s) => s.trim().isNotEmpty)
            .map((s) => "• ${s.trim()}")
            .join("\n");

        return Scaffold(
          backgroundColor: Colors.white,
          drawer: const Sidebar(currentPage: 'ProjectBoard'),
          
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            
            title: Row(
              children: [
                Expanded(
                  // USES LIVE DATA FOR TITLE
                  child: InlineTextEditor(
                    text: project.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 20),
                    onSave: (newName) {
                      ref.read(boardControllerProvider).updateProjectName(project.id, newName);
                    },
                  ),
                ),
                
                // ACCURACY BADGE WITH STEPS TOOLTIP
                if (score > 0) 
                  Tooltip(
                    message: formattedFeedback, // Shows clean list on hover
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(8),
                    textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: scoreColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: scoreColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, size: 14, color: scoreColor),
                          const SizedBox(width: 4),
                          Text(
                            "$score%", 
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: scoreColor),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black87),
            actions: [
               IconButton(
                 icon: Icon(_isTimelineView ? Icons.table_chart : Icons.calendar_month),
                 tooltip: _isTimelineView ? "Switch to Board" : "Switch to Timeline",
                 onPressed: () => setState(() => _isTimelineView = !_isTimelineView),
               ),
               IconButton(
                  icon: const Icon(Icons.person_add_alt), 
                  tooltip: "Invite Member", 
                  onPressed: () => _showInviteDialog(project.id) // Pass the live ID to the dialog
               ),
               IconButton(
                 icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                 tooltip: "Delete Project",
                 onPressed: () async {
                   // <input> // Ensure showDialog is correctly formatted
                   final confirm = await showDialog<bool>(
                     context: context, 
                     builder: (c) => AlertDialog(
                       title: const Text("Delete Project?"),
                       content: const Text("This cannot be undone."),
                       actions: [
                         TextButton(onPressed: () => Navigator.pop(c, false), child: const Text("Cancel")),
                         TextButton(onPressed: () => Navigator.pop(c, true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
                       ],
                     ),
                   );

                   if (confirm == true) {
                     await ref.read(boardControllerProvider).deleteProject(project.id);
                     if (context.mounted) Navigator.pop(context); // Go back to Dashboard
                   }
                 },
               ),
            ],
          ),
          
          body: groupsAsync.when(
            data: (groups) {
              if (_isTimelineView) {
                return ProjectTimelineView(projectId: project.id, groups: groups);
              } else {
                return membersAsync.when(
                  data: (members) => ListView.builder(
                    padding: const EdgeInsets.only(bottom: 50),
                    itemCount: groups.length,
                    itemBuilder: (c, i) => MondayGroup(
                      projectId: project.id, 
                      group: groups[i],
                      projectMembers: members, 
                    ),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e,s) => Center(child: Text("Error loading members: $e")),
                );
              }
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text("Error: $e")),
          ),
        );
      },
    );
  }
}