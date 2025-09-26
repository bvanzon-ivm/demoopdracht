import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/tasks/models/task.dart';
import '../../features/attachments/bloc/attachment_bloc.dart';
import '../../features/attachments/repositories/attachment_repository.dart';
import '../../features/attachments/ui/attachment_list.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(task.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Priority: ${task.priority}'),
              Text('Status: ${task.status}'),
              if (task.description != null)
                Text('Description: ${task.description}'),
              if (task.dueDate != null) Text('Due: ${task.dueDate}'),
              const SizedBox(height: 20),
              Text('Labels: will be implemented later'),
              Text(
                'Assignees: will be implemented later',
              ),
              const Divider(height: 40),
              const Text(
                "Attachments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              BlocProvider(
                create: (_) =>
                    AttachmentBloc(context.read<AttachmentRepository>())
                      ..add(LoadAttachments(task.workspaceId, task.id)),
                child: AttachmentList(
                  workspaceId: task.workspaceId,
                  taskId: task.id,
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(
      //       context,
      //       '/attachments/new', 
      //       arguments: {'workspaceId': task.workspaceId, 'taskId': task.id},
      //     );
      //   },
      //   child: const Icon(Icons.upload_file),
      // ),
    );
  }
}
