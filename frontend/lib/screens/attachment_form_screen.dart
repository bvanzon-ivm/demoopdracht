// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/tasks/bloc/task_list_bloc.dart';

class TaskFormScreen extends StatefulWidget {
  final int workspaceId;
  final int? taskId; // null = create, anders edit

  const TaskFormScreen({
    super.key,
    required this.workspaceId,
    this.taskId,
  });

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _status = "TODO";
  String _priority = "MEDIUM";
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskId == null ? "Create Task" : "Edit Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Title is required" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: "Status"),
                items: const [
                  DropdownMenuItem(value: "TODO", child: Text("To Do")),
                  DropdownMenuItem(value: "IN_PROGRESS", child: Text("In Progress")),
                  DropdownMenuItem(value: "DONE", child: Text("Done")),
                ],
                onChanged: (val) => setState(() => _status = val!),
              ),
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: const InputDecoration(labelText: "Priority"),
                items: const [
                  DropdownMenuItem(value: "LOW", child: Text("Low")),
                  DropdownMenuItem(value: "MEDIUM", child: Text("Medium")),
                  DropdownMenuItem(value: "HIGH", child: Text("High")),
                ],
                onChanged: (val) => setState(() => _priority = val!),
              ),
              ListTile(
                title: Text(_dueDate == null
                    ? "No due date"
                    : "Due: ${_dueDate!.toLocal().toString().split(" ").first}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 1)),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _dueDate = picked);
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  final data = {
                    "title": _titleController.text,
                    "description": _descriptionController.text,
                    "status": _status,
                    "priority": _priority,
                    if (_dueDate != null)
                      "dueDate": _dueDate!.toIso8601String(),
                  };

                  if (widget.taskId == null) {
                    context.read<TaskListBloc>().add(
                          CreateTaskRequested(widget.workspaceId, data),
                        );
                  } else {
                    context.read<TaskListBloc>().add(
                          UpdateTaskRequested(widget.workspaceId, widget.taskId!, data),
                        );
                  }

                  Navigator.pop(context); // terug naar lijst
                },
                child: Text(widget.taskId == null ? "Create" : "Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
