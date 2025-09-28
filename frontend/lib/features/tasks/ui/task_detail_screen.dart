import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_detail_bloc.dart';
import '../repositories/task_repository.dart';
import '../services/task_service.dart';
import '../../auth/bloc/auth_bloc.dart';

class TaskDetailScreen extends StatelessWidget {
  final int workspaceId;
  final int taskId;
  const TaskDetailScreen({super.key, required this.workspaceId, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskDetailBloc(TaskRepository(TaskService()), context.read<AuthBloc>())
        ..add(LoadTaskDetail(workspaceId, taskId)),
      child: Scaffold(
        appBar: AppBar(title: const Text("Task Detail")),
        body: BlocBuilder<TaskDetailBloc, TaskDetailState>(
          builder: (context, state) {
            if (state is TaskDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskDetailLoaded) {
              final task = state.task;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task.title, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(task.description),
                    const SizedBox(height: 16),
                    Text("Status: ${task.status.name}"),
                    Text("Priority: ${task.priority.name}"),
                  ],
                ),
              );
            } else if (state is TaskDetailError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
