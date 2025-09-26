import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/workspace.dart';
import '../repositories/workspace_repository.dart';

/// Events
sealed class WorkspaceDetailEvent {}

class LoadWorkspaceDetail extends WorkspaceDetailEvent {
  final int workspaceId;
  LoadWorkspaceDetail(this.workspaceId);
}

class RemoveUserRequested extends WorkspaceDetailEvent {
  final int workspaceId;
  final int userId;
  RemoveUserRequested(this.workspaceId, this.userId);
}

/// States
sealed class WorkspaceDetailState {}

class WorkspaceDetailInitial extends WorkspaceDetailState {}

class WorkspaceDetailLoading extends WorkspaceDetailState {}

class WorkspaceDetailLoaded extends WorkspaceDetailState {
  final Workspace workspace;
  final List<Map<String, dynamic>> auditLogs;

  WorkspaceDetailLoaded(this.workspace, this.auditLogs);
}

class WorkspaceDetailError extends WorkspaceDetailState {
  final String message;
  WorkspaceDetailError(this.message);
}

/// Bloc
class WorkspaceDetailBloc extends Bloc<WorkspaceDetailEvent, WorkspaceDetailState> {
  final WorkspaceRepository repo;

  WorkspaceDetailBloc(this.repo) : super(WorkspaceDetailInitial()) {
    on<LoadWorkspaceDetail>((event, emit) async {
      emit(WorkspaceDetailLoading());
      try {
        final ws = await repo.get(event.workspaceId);
        final audit = await repo.audit(event.workspaceId);
        emit(WorkspaceDetailLoaded(ws, audit));
      } catch (e) {
        emit(WorkspaceDetailError(e.toString()));
      }
    });

    on<RemoveUserRequested>((event, emit) async {
      if (state is! WorkspaceDetailLoaded) return;
      try {
        await repo.removeUser(event.workspaceId, event.userId);
        final ws = await repo.get(event.workspaceId);
        final audit = await repo.audit(event.workspaceId);
        emit(WorkspaceDetailLoaded(ws, audit));
      } catch (e) {
        emit(WorkspaceDetailError(e.toString()));
      }
    });
  }
}
