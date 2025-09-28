import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

abstract class TaskListEvent {}
class LoadTasks extends TaskListEvent {
  final int workspaceId;
  LoadTasks(this.workspaceId);
}

abstract class TaskListState {}
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
  final TaskRepository _repo;
  final AuthBloc _authBloc;

  TaskListBloc(this._repo, this._authBloc) : super(TaskListInitial()) {
    on<LoadTasks>(_onLoadTasks);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskListState> emit) async {
    emit(TaskListLoading());
    try {
      final authState = _authBloc.state;
      if (authState is AuthAuthenticated) {
        final tasks = await _repo.getTasks(authState.token, event.workspaceId);
        emit(TaskListLoaded(tasks));
      } else {
        emit(TaskListError("Not authenticated"));
      }
    } catch (e) {
      emit(TaskListError(e.toString()));
    }
  }
}
