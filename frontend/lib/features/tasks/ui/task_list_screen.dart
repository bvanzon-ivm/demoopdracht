import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_list_bloc.dart';
import '../repositories/task_repository.dart';
import '../services/task_service.dart';
import 'task_form_screen.dart';
import 'widgets/kanban_board.dart';

import '../../auth/bloc/auth_bloc.dart';

class TaskListScreen extends StatelessWidget {
  final int workspaceId;

  const TaskListScreen({super.key, required this.workspaceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskListBloc(
        TaskRepository(TaskService()),
        context.read<AuthBloc>(),
      )..add(LoadTasks(workspaceId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Kanban Board momenteel na het aanmaken van een taak moet je terug naar vorgie pagina en weer terug ')),
        body: BlocBuilder<TaskListBloc, TaskListState>(
          builder: (context, state) {
            if (state is TaskListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskListLoaded) {
              return KanbanBoard(
                tasks: state.tasks,
                workspaceId: workspaceId,
              );
            } else if (state is TaskListError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => TaskFormScreen(workspaceId: workspaceId)),
            );
            if (!context.mounted) return;
            context.read<TaskListBloc>().add(LoadTasks(workspaceId));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
