import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/workspace.dart';
import '../repositories/workspace_repository.dart';

sealed class WorkspaceListEvent {}
class LoadWorkspaces extends WorkspaceListEvent {}

sealed class WorkspaceListState {}
class WorkspaceListInitial extends WorkspaceListState {}
class WorkspaceListLoading extends WorkspaceListState {}
class WorkspaceListLoaded extends WorkspaceListState {
  
  final List<Workspace> workspaces;
  WorkspaceListLoaded(this.workspaces);
}
class CreateWorkspaceRequested extends WorkspaceListEvent { 
  final String name;
  final String description;
  CreateWorkspaceRequested(this.name, this.description);
}
class WorkspaceListError extends WorkspaceListState {
  final String message;
  WorkspaceListError(this.message);
}

class WorkspaceListBloc extends Bloc<WorkspaceListEvent, WorkspaceListState> {
  final WorkspaceRepository repo;

  WorkspaceListBloc(this.repo) : super(WorkspaceListInitial()) {
    on<LoadWorkspaces>((event, emit) async {
      emit(WorkspaceListLoading());
      try {
        final list = await repo.list();
        emit(WorkspaceListLoaded(list));
      } catch (e) {
        emit(WorkspaceListError(e.toString()));
      }
    });
    on<CreateWorkspaceRequested>((event, emit) async { 
      try {
        await repo.create(event.name, event.description);
        final list = await repo.list(); 
        emit(WorkspaceListLoaded(list));
      } catch (e) {
        emit(WorkspaceListError(e.toString()));
      }
    });
  }
}

