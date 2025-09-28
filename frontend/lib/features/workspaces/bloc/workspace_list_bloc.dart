import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../models/workspace.dart';
import '../repositories/workspace_repository.dart';

abstract class WorkspaceListEvent {}

class LoadWorkspaces extends WorkspaceListEvent {}

abstract class WorkspaceListState {}

class WorkspaceListInitial extends WorkspaceListState {}

class WorkspaceListLoading extends WorkspaceListState {}

class WorkspaceListLoaded extends WorkspaceListState {
  final List<Workspace> workspaces;
  WorkspaceListLoaded(this.workspaces);
}

class WorkspaceListError extends WorkspaceListState {
  final String message;
  WorkspaceListError(this.message);
}

class CreateWorkspace extends WorkspaceListEvent {
  final String name;
  final String description;
  CreateWorkspace(this.name, this.description);
}

class WorkspaceListBloc extends Bloc<WorkspaceListEvent, WorkspaceListState> {
  final WorkspaceRepository _repo;
  final AuthBloc _authBloc;

  WorkspaceListBloc(this._repo, this._authBloc)
      : super(WorkspaceListInitial()) {
    on<LoadWorkspaces>(_onLoadWorkspaces);
    on<CreateWorkspace>(_onCreateWorkspace);
  }
  Future<void> _onCreateWorkspace(
      CreateWorkspace event, Emitter<WorkspaceListState> emit) async {
    try {
      final authState = _authBloc.state;
      if (authState is AuthAuthenticated) {
        final ws = await _repo.createWorkspace(authState.token, {
          "name": event.name,
          "description": event.description,
        });

        if (state is WorkspaceListLoaded) {
          final updated =
              List<Workspace>.from((state as WorkspaceListLoaded).workspaces)
                ..add(ws);
          emit(WorkspaceListLoaded(updated));
        } else {
          emit(WorkspaceListLoaded([ws]));
        }
      }
    } catch (e) {
      emit(WorkspaceListError("Create failed: $e"));
    }
  }

  Future<void> _onLoadWorkspaces(
      LoadWorkspaces event, Emitter<WorkspaceListState> emit) async {
    emit(WorkspaceListLoading());
    try {
      final state = _authBloc.state;
      if (state is AuthAuthenticated) {
        final workspaces = await _repo.getWorkspaces(state.token);
        emit(WorkspaceListLoaded(workspaces));
      } else {
        emit(WorkspaceListError('Not authenticated'));
      }
    } catch (e) {
      emit(WorkspaceListError(e.toString()));
    }
  }
}
