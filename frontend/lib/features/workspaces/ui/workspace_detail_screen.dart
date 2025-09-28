import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../auth/models/user.dart';
import '../../auth/repositories/user_repository.dart';
import '../../auth/services/user_service.dart';
import '../bloc/workspace_detail_bloc.dart';
import '../repositories/workspace_repository.dart';
import '../services/workspace_service.dart';

class WorkspaceDetailScreen extends StatelessWidget {
  final int workspaceId;
  const WorkspaceDetailScreen({super.key, required this.workspaceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => WorkspaceDetailBloc(
        WorkspaceRepository(WorkspaceService()),
        ctx.read<AuthBloc>(),
      ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text("Workspace Details")),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.person_add),
                  label: const Text("Lid toevoegen"),
                  onPressed: () async {
                    final controller = TextEditingController();
                    List<User> results = [];
                    bool loading = false;
                    Timer? debounce;

                    final selectedUser = await showDialog<User>(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            Future<void> search(String q) async {
                              if (q.length < 2) {
                                setState(() {
                                  results = [];
                                  loading = false;
                                });
                                return;
                              }
                              final auth = context.read<AuthBloc>().state;
                              if (auth is! AuthAuthenticated) return;

                              setState(() => loading = true);
                              try {
                                final repo = UserRepository(UserService());
                                final users =
                                    await repo.searchUsers(auth.token, q);
                                setState(() {
                                  results = users;
                                  loading = false;
                                });
                              } catch (_) {
                                setState(() => loading = false);
                              }
                            }

                            return Dialog(
                              child: SizedBox(
                                width: 480,
                                height: 400,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        "Zoek gebruiker op e-mail",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        controller: controller,
                                        decoration: const InputDecoration(
                                          labelText: "Email",
                                          hintText: "bijv. alice@ex.com",
                                        ),
                                        onChanged: (value) {
                                          debounce?.cancel();
                                          debounce = Timer(
                                            const Duration(milliseconds: 250),
                                            () => search(value),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      if (loading)
                                        const LinearProgressIndicator(),
                                      Expanded(
                                        child: results.isNotEmpty
                                            ? ListView.separated(
                                                itemCount: results.length,
                                                separatorBuilder: (_, __) =>
                                                    const Divider(height: 1),
                                                itemBuilder: (context, index) {
                                                  final u = results[index];
                                                  return ListTile(
                                                    leading: const Icon(
                                                        Icons.person),
                                                    title: Text(u.name),
                                                    subtitle: Text(u.email),
                                                    onTap: () =>
                                                        Navigator.pop(
                                                            context, u),
                                                  );
                                                },
                                              )
                                            : controller.text.length >= 2 &&
                                                    !loading
                                                ? const Center(
                                                    child: Text(
                                                        "Geen resultaten"),
                                                  )
                                                : const SizedBox.shrink(),
                                      ),
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Sluiten"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );

                    debounce?.cancel();

                    if (selectedUser != null) {
                      context
                          .read<WorkspaceDetailBloc>()
                          .add(AddMember(workspaceId, selectedUser.id));

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${selectedUser.name} is toegevoegd aan de workspace",
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
