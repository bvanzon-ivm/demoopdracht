import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/task_repository.dart';
import '../models/task.dart';

sealed class TaskListEvent {}
class LoadTasks extends TaskListEvent {
  final int workspaceId;
  LoadTasks(this.workspaceId);
}
class CreateTaskRequested extends TaskListEvent {
  final int workspaceId;
  final Map<String, dynamic> data;
  CreateTaskRequested(this.workspaceId, this.data);
}
class UpdateTaskRequested extends TaskListEvent {
  final int workspaceId;
  final int taskId;
  final Map<String, dynamic> data;
  UpdateTaskRequested(this.workspaceId, this.taskId, this.data);
}
class DeleteTaskRequested extends TaskListEvent {
  final int workspaceId;
  final int taskId;
  DeleteTaskRequested(this.workspaceId, this.taskId);
}

sealed class TaskListState {}
class TaskListInitial extends TaskListState {}
class TaskListLoading extends TaskListState {}
class TaskListLoaded extends TaskListState {
  final List<Task> tasks;
  TaskListLoaded(this.tasks);
}
class TaskListError extends TaskListState {
  final String message;
  TaskListError(this.message);
}

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final TaskRepository repo; // ✅ ipv TaskService

  TaskListBloc(this.repo) : super(TaskListInitial()) {
    on<LoadTasks>((event, emit) async {
      emit(TaskListLoading());
      try {
        final tasks = await repo.list(event.workspaceId);
        emit(TaskListLoaded(tasks));
      } catch (e) {
        emit(TaskListError(e.toString()));
      }
    });

    on<CreateTaskRequested>((event, emit) async {
      if (state is! TaskListLoaded) return;
      try {
        await repo.create(event.workspaceId, event.data);
        final tasks = await repo.list(event.workspaceId);
        emit(TaskListLoaded(tasks));
      } catch (e) {
        emit(TaskListError(e.toString()));
      }
    });

    on<UpdateTaskRequested>((event, emit) async {
      if (state is! TaskListLoaded) return;
      try {
        await repo.update(event.workspaceId, event.taskId, event.data);
        final tasks = await repo.list(event.workspaceId);
        emit(TaskListLoaded(tasks));
      } catch (e) {
        emit(TaskListError(e.toString()));
      }
    });

    on<DeleteTaskRequested>((event, emit) async {
      if (state is! TaskListLoaded) return;
      try {
        await repo.delete(event.workspaceId, event.taskId);
        final tasks = await repo.list(event.workspaceId);
        emit(TaskListLoaded(tasks));
      } catch (e) {
        emit(TaskListError(e.toString()));
      }
    });
  }
}
