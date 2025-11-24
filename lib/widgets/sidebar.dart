import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:taskflow_app/providers/app_providers.dart';
import 'package:taskflow_app/features/dashboard/dashboard_screen.dart';
import 'package:taskflow_app/features/create_project/create_project_screen.dart';
import 'package:taskflow_app/settings_screen.dart';
import 'package:taskflow_app/models/project_model.dart';
import 'package:taskflow_app/models/search_history_model.dart'; 
import 'package:taskflow_app/features/project_features/project_board_screen.dart';

final sidebarProjectsProvider = StreamProvider<List<ProjectModel>>((ref) {
  final authState = ref.watch(authStateChangesProvider); 
  
  return authState.when(
    data: (user) {
      if (user == null) return const Stream.empty();
      return ref.watch(projectRepoProvider).watchProjects(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

final sidebarHistoryProvider = StreamProvider<List<SearchHistoryModel>>((ref) {
  final authState = ref.watch(authStateChangesProvider); 

  return authState.when(
    data: (user) {
      if (user == null) return const Stream.empty();
      return ref.watch(historyRepoProvider).watchHistory(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});

class Sidebar extends ConsumerWidget {
  final String currentPage;

  const Sidebar({
    super.key,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final projectsAsync = ref.watch(sidebarProjectsProvider);
    final historyAsync = ref.watch(sidebarHistoryProvider);
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Container(
        color: theme.scaffoldBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("TaskFlow AI"),
              accountEmail: Text(user?.email ?? "Guest"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: colorScheme.onPrimary,
                child: Text(
                  (user?.email?.isNotEmpty == true ? user!.email![0] : "G").toUpperCase(),
                  style: TextStyle(fontSize: 24, color: colorScheme.primary),
                ),
              ),
              decoration: BoxDecoration(color: colorScheme.primary),
            ),

            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              selected: currentPage == 'Dashboard',
              selectedTileColor: colorScheme.primaryContainer,
              selectedColor: colorScheme.primary,
              onTap: () {
                Navigator.pop(context);
                if (currentPage != 'Dashboard') {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Create Project'),
              selected: currentPage == 'CreateProject',
              selectedTileColor: colorScheme.primaryContainer,
              selectedColor: colorScheme.primary,
              onTap: () {
                Navigator.pop(context);
                if (currentPage != 'CreateProject') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateProjectScreen()),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              selected: currentPage == 'Settings',
              selectedTileColor: colorScheme.primaryContainer,
              selectedColor: colorScheme.primary,
              onTap: () {
                Navigator.pop(context);
                if (currentPage != 'Settings') {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                }
              },
            ),

            const Divider(),

            ExpansionTile(
              leading: const Icon(Icons.folder_open),
              title: const Text("My Projects"),
              initiallyExpanded: true,
              children: projectsAsync.when(
                data: (projects) => projects.map((project) {
                  return ListTile(
                    title: Text(project.name),
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 24, right: 16),
                    leading: Icon(Icons.circle, size: 8, color: Color(project.colorValue)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProjectBoardScreen(project: project),
                        ),
                      );
                    },
                  );
                }).toList(),
                loading: () => [const LinearProgressIndicator(minHeight: 2)],
                error: (e, s) => [const SizedBox()],
              ),
            ),

            const Divider(),

            ExpansionTile(
              leading: const Icon(Icons.history),
              title: const Text("History"),
              initiallyExpanded: false,
              children: historyAsync.when(
                data: (history) {
                  if (history.isEmpty) {
                    return [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("No recent searches.", style: TextStyle(color: Colors.grey)),
                      )
                    ];
                  }
                  return history.map((item) {
                    final dateStr = DateFormat('MM/dd').format(item.createdAt);
                    return ListTile(
                      title: Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text("${item.strategy} • $dateStr", maxLines: 1, overflow: TextOverflow.ellipsis),
                      dense: true,
                      leading: const Icon(Icons.replay, size: 16, color: Colors.grey),
                      contentPadding: const EdgeInsets.only(left: 24, right: 16),
                      onTap: () {
                        Navigator.pop(context); 
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreateProjectScreen(
                              initialDescription: item.description,
                              initialStrategy: item.strategy,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList();
                },
                loading: () => [const LinearProgressIndicator(minHeight: 2)],
                error: (e, s) => [const SizedBox()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}