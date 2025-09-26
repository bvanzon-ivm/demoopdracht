import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/tasks/bloc/task_list_bloc.dart';
import '../features/tasks/bloc/task_detail_bloc.dart';
import '../features/tasks/repositories/task_repository.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';
import '../features/attachments/repositories/attachment_repository.dart';
import '../features/auth/bloc/auth_bloc.dart';
import 'login_screen.dart';

class TaskListScreen extends StatelessWidget {
  final int workspaceId;
  const TaskListScreen({super.key, required this.workspaceId});
  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(LogoutRequested());
    // Navigatie terug naar login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TaskListBloc(context.read<TaskRepository>())
            ..add(LoadTasks(workspaceId)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Tasks"),

              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: "Logout",
                  onPressed: () => _logout(context),
                ),
              ],
            ),
            body: BlocBuilder<TaskListBloc, TaskListState>(
              builder: (context, state) {
                if (state is TaskListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TaskListLoaded) {
                  return ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (ctx, i) {
                      final task = state.tasks[i];
                      return ListTile(
                        title: Text(task.title),
                        subtitle: Text("Status: ${task.status}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) =>
                                    TaskDetailBloc(
                                      taskRepo: context.read<TaskRepository>(),
                                      attachmentRepo: context
                                          .read<AttachmentRepository>(),
                                    )..add(
                                      LoadTaskDetail(task.workspaceId, task.id),
                                    ),
                                child: TaskDetailScreen(task: task),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is TaskListError) {
                  return Center(child: Text("Error: ${state.message}"));
                }
                return const SizedBox.shrink();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context
                          .read<TaskListBloc>(), // zelfde bloc meegeven
                      child: TaskFormScreen(workspaceId: workspaceId),
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
