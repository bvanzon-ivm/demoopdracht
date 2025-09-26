import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/workspaces/bloc/workspace_list_bloc.dart';
import '../features/workspaces/models/workspace.dart';

import 'task_list_screen.dart';
import '../features/auth/models/user.dart';

import '../features/tasks/bloc/task_list_bloc.dart';
import '../features/tasks/repositories/task_repository.dart';
import '../features/auth/bloc/auth_bloc.dart';
import 'login_screen.dart';
import '../features/workspaces/bloc/workspace_detail_bloc.dart';
import '../features/workspaces/repositories/workspace_repository.dart';
import 'workspace_detail_screen.dart';


class WorkspaceListScreen extends StatelessWidget {
  final User user;
  const WorkspaceListScreen({super.key, required this.user});
  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(LogoutRequested());
    // Navigatie terug naar login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
  void _openCreateDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Create Workspace"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Workspace name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final description = descriptionController.text.trim();
              if (name.isNotEmpty) {
                context.read<WorkspaceListBloc>().add(
                  CreateWorkspaceRequested(name, description),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Workspaces (${user.name})"),
      actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () => _logout(context),
          ),
        ],),
      body: BlocBuilder<WorkspaceListBloc, WorkspaceListState>(
        builder: (context, state) {
          if (state is WorkspaceListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkspaceListLoaded) {
            if (state.workspaces.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("You don’t belong to any workspace yet."),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _openCreateDialog(context),
                      child: const Text("Create Workspace"),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.workspaces.length,
              itemBuilder: (ctx, i) {
                final Workspace ws = state.workspaces[i];
                return ListTile(
                  title: Text(ws.name),
                  subtitle: Text("Members: ${ws.members.length}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => WorkspaceDetailBloc(
                              context.read<WorkspaceRepository>(),
                            )..add(LoadWorkspaceDetail(ws.id)),
                            child: WorkspaceDetailScreen(workspace: ws),
                          ),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) =>
                              TaskListBloc(context.read<TaskRepository>())
                                ..add(LoadTasks(ws.id)),
                          child: TaskListScreen(workspaceId: ws.id),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is WorkspaceListError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
