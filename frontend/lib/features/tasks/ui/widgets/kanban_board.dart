import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/task_list_bloc.dart';
import '../../models/task.dart';
import '../../../../screens/task_detail_screen.dart';

class TaskBoardScreen extends StatelessWidget {
  final int workspaceId;
  const TaskBoardScreen({super.key, required this.workspaceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TaskListBloc, TaskListState>(
        builder: (context, state) {
          if (state is TaskListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskListLoaded) {
            final todo = state.tasks.where((t) => t.status == 'TODO').toList();
            final doing = state.tasks.where((t) => t.status == 'DOING').toList();
            final done = state.tasks.where((t) => t.status == 'DONE').toList();

            return Row(
              children: [
                _buildColumn(context, 'TODO', todo),
                _buildColumn(context, 'DOING', doing),
                _buildColumn(context, 'DONE', done),
              ],
            );
          } else if (state is TaskListError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          final titleController = TextEditingController();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Nieuw task'),
              content: TextField(controller: titleController),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<TaskListBloc>().add(
                          CreateTaskRequested(workspaceId, {
                            'title': titleController.text,
                            'status': 'TODO',
                            'priority': 'MEDIUM',
                          }),
                        );
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildColumn(BuildContext context, String status, List<Task> tasks) {
    return Expanded(
      child: Column(
        children: [
          Text(status, style: Theme.of(context).textTheme.titleLarge),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, i) {
                final task = tasks[i];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.priority),
                  trailing: TextButton(
                    child: const Text('Details'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TaskDetailScreen(task: task),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
