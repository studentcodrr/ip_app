import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskflow_app/models/project_model.dart';
import 'package:taskflow_app/features/project_features/project_board_screen.dart';
import 'package:taskflow_app/features/create_project/create_project_screen.dart';
import 'package:taskflow_app/providers/app_providers.dart';
import 'package:taskflow_app/widgets/sidebar.dart';


final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
// --- PROJECT LIST PROVIDER ---
// This remains local because it's specific to the dashboard logic
final projectListProvider = StreamProvider<List<ProjectModel>>((ref) {
  // 1. Use the central Auth Provider
  final authState = ref.watch(authStateChangesProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        return const Stream.empty();
      }
      // 2. Use the central Repo Provider
      return ref.watch(projectRepoProvider).watchProjects(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (err, stack) => const Stream.empty(),
  );
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectListProvider);

    return Scaffold(
      drawer: const Sidebar(currentPage: 'Dashboard'),
      
      appBar: AppBar(
        title: const Text("My Projects"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_to_photos),
        label: const Text("New AI Plan"),
        onPressed: () => Navigator.push(
          context, 
          MaterialPageRoute(builder: (_) => const CreateProjectScreen())
        ),
      ),
      
      body: projectsAsync.when(
        data: (projects) {
          if (projects.isEmpty) {
             return Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const Icon(Icons.folder_open, size: 64, color: Colors.grey),
                   const SizedBox(height: 16),
                   const Text("No projects found.", style: TextStyle(fontSize: 18, color: Colors.grey)),
                   const SizedBox(height: 8),
                   ElevatedButton(
                     onPressed: () => Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (_) => const CreateProjectScreen())
                     ),
                     child: const Text("Create Your First Project"),
                   )
                 ],
               ),
             );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(project.colorValue),
                    child: Text(
                      project.name.isNotEmpty ? project.name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(project.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    project.description.isNotEmpty ? project.description : "No description", 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProjectBoardScreen(project: project),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}