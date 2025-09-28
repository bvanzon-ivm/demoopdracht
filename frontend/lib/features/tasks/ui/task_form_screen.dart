import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../repositories/task_repository.dart';
import '../services/task_service.dart';

class TaskFormScreen extends StatefulWidget {
  final int workspaceId;
  const TaskFormScreen({super.key, required this.workspaceId});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  String description = '';
  String status = 'TODO';
  String priority = 'MEDIUM';
  DateTime? dueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nieuwe taak')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Titel'),
                onSaved: (val) => title = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Titel verplicht' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Omschrijving'),
                onSaved: (val) => description = val ?? '',
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Status'),
                value: status,
                items: ['TODO', 'IN_PROGRESS', 'DONE']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => status = val!),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Prioriteit'),
                value: priority,
                items: ['LOW', 'MEDIUM', 'HIGH']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) => setState(() => priority = val!),
              ),
              ListTile(
                title: Text(dueDate == null
                    ? "Geen einddatum gekozen"
                    : "Deadline: ${dueDate!.toLocal()}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    initialDate: dueDate ?? DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      dueDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final auth = context.read<AuthBloc>().state;
                    if (auth is AuthAuthenticated) {
                      final repo = TaskRepository(TaskService());

                      await repo.createTask(auth.token, widget.workspaceId, {
                        "title": title,
                        "description": description,
                        "status": status,
                        "priority": priority,
                        "dueDate": dueDate?.toIso8601String(),
                        "labels": [],
                        "assignees": [
                          {
                            "id": auth.user.id,
                            "name": auth.user.name,
                            "email": auth.user.email,
                            "createdAt": auth.user.createdAt?.toIso8601String(),
                            "lastLoginAt":
                                auth.user.lastLoginAt?.toIso8601String(),
                          }
                        ]
                      });

                      if (context.mounted) Navigator.pop(context, true);
                    }
                  }
                },
                child: const Text('Opslaan'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
