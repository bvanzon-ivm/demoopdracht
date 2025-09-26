import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/attachment_bloc.dart';

class AttachmentList extends StatelessWidget {
  final int workspaceId;
  final int taskId;

  const AttachmentList({
    super.key,
    required this.workspaceId,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttachmentBloc, AttachmentState>(
      builder: (context, state) {
        if (state is AttachmentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AttachmentLoaded) {
          if (state.attachments.isEmpty) {
            return const Text('Will be implemented later');
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.attachments.length,
            itemBuilder: (ctx, i) {
              final a = state.attachments[i];
              return ListTile(
                leading: const Icon(Icons.attach_file),
                title: Text(a.fileName),
                subtitle: Text("${a.size} bytes"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    context.read<AttachmentBloc>().add(
                          DeleteAttachment(workspaceId, taskId, a.id),
                        );
                  },
                ),
              );
            },
          );
        } else if (state is AttachmentError) {
          return Text('Error: ${state.message}');
        }
        return const SizedBox.shrink();
      },
    );
  }
}
