import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskflow_app/models/project_model.dart';
import 'package:taskflow_app/models/group_model.dart';
import 'package:taskflow_app/widgets/monday_group.dart';
import 'package:taskflow_app/widgets/inline_text_editor.dart';
import 'package:taskflow_app/features/project_features/board_controller.dart';
import 'package:taskflow_app/providers/app_providers.dart';
import 'package:taskflow_app/widgets/sidebar.dart';
import 'package:taskflow_app/widgets/timeline_view.dart'; 

final groupsProvider = StreamProvider.family<List<GroupModel>, String>((ref, projectId) {
  return ref.watch(projectRepoProvider).watchGroups(projectId);
});

class ProjectBoardScreen extends ConsumerStatefulWidget {
  final ProjectModel project;

  const ProjectBoardScreen({super.key, required this.project});

  @override
  ConsumerState<ProjectBoardScreen> createState() => _ProjectBoardScreenState();
}

class _ProjectBoardScreenState extends ConsumerState<ProjectBoardScreen> {
  bool _isTimelineView = false; 

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(groupsProvider(widget.project.id));

    return Scaffold(
      drawer: const Sidebar(currentPage: 'ProjectBoard'),
      
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: InlineTextEditor(
          text: widget.project.name,
          style: const TextStyle(
             fontWeight: FontWeight.bold, 
             color: Colors.black87, 
             fontSize: 20
          ),
          onSave: (newName) {
            ref.read(boardControllerProvider).updateProjectName(widget.project.id, newName);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
           IconButton(
             icon: Icon(_isTimelineView ? Icons.table_chart : Icons.calendar_month),
             tooltip: _isTimelineView ? "Switch to Board" : "Switch to Timeline",
             onPressed: () {
               setState(() {
                 _isTimelineView = !_isTimelineView;
               });
             },
           ),

           IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
           IconButton(icon: const Icon(Icons.person_add_alt), onPressed: () {}),
           
           IconButton(
             icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
             tooltip: "Delete Project",
             onPressed: () async {
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
                 await ref.read(boardControllerProvider).deleteProject(widget.project.id);
                 if (context.mounted) {
                   Navigator.pop(context);
                 }
               }
             },
           ),
        ],
      ),
      
      body: groupsAsync.when(
        data: (groups) {
          if (_isTimelineView) {
            return ProjectTimelineView(
              projectId: widget.project.id, 
              groups: groups
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 50),
              itemCount: groups.length,
              itemBuilder: (c, i) => MondayGroup(
                projectId: widget.project.id, 
                group: groups[i]
              ),
            );
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text("Error: $e")),
      ),
    );
  }
}