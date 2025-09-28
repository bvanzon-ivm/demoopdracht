import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../task_detail_screen.dart';


class KanbanBoard extends StatelessWidget {
  final List<Task> tasks;
  final int workspaceId;

  const KanbanBoard({super.key, required this.tasks, required this.workspaceId});

  @override
  Widget build(BuildContext context) {
    final todo = tasks.where((t) => t.status == TaskStatus.TODO).toList();
    final progress = tasks.where((t) => t.status == TaskStatus.IN_PROGRESS).toList();
    final done = tasks.where((t) => t.status == TaskStatus.DONE).toList();

    Widget buildColumn(String title, List<Task> tasks) {
      return Expanded(
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: tasks
                    .map((t) => Card(
                          child: ListTile(
                            title: Text(t.title),
                            subtitle: Text(t.description),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TaskDetailScreen(
                                    workspaceId: workspaceId,
                                    taskId: t.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildColumn("TODO", todo),
        buildColumn("IN PROGRESS", progress),
        buildColumn("DONE", done),
      ],
    );
  }
}
