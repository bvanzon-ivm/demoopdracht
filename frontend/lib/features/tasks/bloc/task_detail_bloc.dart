import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';

abstract class TaskDetailEvent {}
class LoadTaskDetail extends TaskDetailEvent {
  final int workspaceId;
  final int taskId;
  LoadTaskDetail(this.workspaceId, this.taskId);
}

abstract class TaskDetailState {}
class TaskDetailInitial extends TaskDetailState {}
class TaskDetailLoading extends TaskDetailState {}
class TaskDetailLoaded extends TaskDetailState {
  final Task task;
  TaskDetailLoaded(this.task);
}
class TaskDetailError extends TaskDetailState {
  final String message;
  TaskDetailError(this.message);
}

class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  final TaskRepository _repo;
  final AuthBloc _authBloc;

  TaskDetailBloc(this._repo, this._authBloc) : super(TaskDetailInitial()) {
    on<LoadTaskDetail>(_onLoadTaskDetail);
  }

  Future<void> _onLoadTaskDetail(
      LoadTaskDetail event, Emitter<TaskDetailState> emit) async {
    emit(TaskDetailLoading());
    try {
      final authState = _authBloc.state;
      if (authState is AuthAuthenticated) {
        final task =
            await _repo.getTask(authState.token, event.workspaceId, event.taskId);
        emit(TaskDetailLoaded(task));
      } else {
        emit(TaskDetailError("Not authenticated"));
      }
    } catch (e) {
      emit(TaskDetailError(e.toString()));
    }
  }
}
