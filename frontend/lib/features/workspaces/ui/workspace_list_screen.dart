import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/workspace_list_bloc.dart';
import '../repositories/workspace_repository.dart';
import '../services/workspace_service.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../tasks/ui/task_list_screen.dart';
import 'workspace_detail_screen.dart';

class WorkspaceListScreen extends StatelessWidget {
  const WorkspaceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => WorkspaceListBloc(
        WorkspaceRepository(WorkspaceService()),
        ctx.read<AuthBloc>(), 
      )..add(LoadWorkspaces()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Workspaces')),
            body: BlocBuilder<WorkspaceListBloc, WorkspaceListState>(
              builder: (context, state) {
                if (state is WorkspaceListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WorkspaceListLoaded) {
                  if (state.workspaces.isEmpty) {
                    return const Center(child: Text("Nog geen workspaces"));
                  }
                  return ListView.builder(
                    itemCount: state.workspaces.length,
                    itemBuilder: (context, index) {
                      final ws = state.workspaces[index];
                      return ListTile(
                        title: Text(ws.name),
                        subtitle: Text(ws.description),
                        onTap: () {
              
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  TaskListScreen(workspaceId: ws.id),
                            ),
                          );
                        },
                        // trailing: IconButton(
                        //   icon: const Icon(Icons.settings),
                        //   onPressed: () {
             
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (_) =>
                        //             WorkspaceDetailScreen(workspaceId: ws.id),
                        //       ),
                        //     );
                        //   },
                        // ),
                      );
                    },
                  );
                } else if (state is WorkspaceListError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const SizedBox.shrink();
              },
            ),

           
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final nameController = TextEditingController();
                final descController = TextEditingController();

                final result = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Nieuwe Workspace"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: "Naam"),
                        ),
                        TextField(
                          controller: descController,
                          decoration:
                              const InputDecoration(labelText: "Beschrijving"),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Annuleer"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Opslaan"),
                      ),
                    ],
                  ),
                );

                if (result == true) {
                  context.read<WorkspaceListBloc>().add(
                        CreateWorkspace(
                          nameController.text,
                          descController.text,
                        ),
                      );
                }
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
