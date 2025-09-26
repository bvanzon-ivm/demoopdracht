// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/workspaces/bloc/workspace_detail_bloc.dart';
import '../features/workspaces/models/workspace.dart';

class WorkspaceDetailScreen extends StatelessWidget {
  final Workspace workspace;
  const WorkspaceDetailScreen({super.key, required this.workspace});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkspaceDetailBloc(
        context.read(), // haalt WorkspaceRepository uit context
      )..add(LoadWorkspaceDetail(workspace.id)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(workspace.name),
        ),
        body: BlocBuilder<WorkspaceDetailBloc, WorkspaceDetailState>(
          builder: (context, state) {
            if (state is WorkspaceDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WorkspaceDetailLoaded) {
              final ws = state.workspace;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ws.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Owner: ${ws.owner.name} (${ws.owner.email})",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Divider(height: 32),
                    Text(
                      "Members",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ...ws.members.map(
                      (m) => ListTile(
                        title: Text(m.name),
                        subtitle: Text(m.email),
                        trailing: ws.owner.id == m.id
                            ? const Text("Owner")
                            : IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () {
                                  context.read<WorkspaceDetailBloc>().add(
                                        RemoveUserRequested(ws.id, m.id),
                                      );
                                },
                              ),
                      ),
                    ),
                    const Divider(height: 32),
                    Text(
                      "Audit logs",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    if (state.auditLogs.isEmpty)
                      const Text("No audit logs yet.")
                    else
                      Column(
                        children: state.auditLogs.map((log) {
                          return ListTile(
                            title: Text(log['action'] ?? "Unknown"),
                            subtitle: Text(log['timestamp'] ?? ""),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              );
            } else if (state is WorkspaceDetailError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
