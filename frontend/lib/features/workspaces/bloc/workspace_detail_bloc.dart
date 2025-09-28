import 'package:flutter_bloc/flutter_bloc.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../repositories/workspace_repository.dart';
import '../../auth/repositories/user_repository.dart';
import '../../auth/models/user.dart';
import '../../auth/services/user_service.dart';

/// Events
abstract class WorkspaceDetailEvent {}

class LoadMembers extends WorkspaceDetailEvent {
  final int workspaceId;
  LoadMembers(this.workspaceId);
}

class AddMember extends WorkspaceDetailEvent {
  final int workspaceId;
  final int userId;
  AddMember(this.workspaceId, this.userId);
}

class SearchUsers extends WorkspaceDetailEvent {
  final String query;
  SearchUsers(this.query);
}

/// States
abstract class WorkspaceDetailState {}

class WorkspaceDetailInitial extends WorkspaceDetailState {}

class WorkspaceDetailLoading extends WorkspaceDetailState {}

class MembersLoaded extends WorkspaceDetailState {
  final List<Map<String, dynamic>> members;
  MembersLoaded(this.members);
}

class UsersFound extends WorkspaceDetailState {
  final List<User> results;
  UsersFound(this.results);
}

class WorkspaceDetailError extends WorkspaceDetailState {
  final String message;
  WorkspaceDetailError(this.message);
}

/// Bloc
class WorkspaceDetailBloc
    extends Bloc<WorkspaceDetailEvent, WorkspaceDetailState> {
  final WorkspaceRepository _repo;
  final AuthBloc _authBloc;

  WorkspaceDetailBloc(this._repo, this._authBloc)
      : super(WorkspaceDetailInitial()) {
    on<LoadMembers>(_onLoadMembers);
    on<AddMember>(_onAddMember);
    on<SearchUsers>(_onSearchUsers);
  }

  Future<void> _onLoadMembers(
      LoadMembers event, Emitter<WorkspaceDetailState> emit) async {
    emit(WorkspaceDetailLoading());
    try {
      final authState = _authBloc.state;
      if (authState is AuthAuthenticated) {
        final members =
            await _repo.getMembers(authState.token, event.workspaceId);
        emit(MembersLoaded(members));
      } else {
        emit(WorkspaceDetailError("Not authenticated"));
      }
    } catch (e) {
      emit(WorkspaceDetailError("Members load failed: $e"));
    }
  }

  Future<void> _onAddMember(
      AddMember event, Emitter<WorkspaceDetailState> emit) async {
    try {
      final authState = _authBloc.state;
      if (authState is AuthAuthenticated) {
        await _repo.addMember(authState.token, event.workspaceId, event.userId);
        // Refresh members after adding
        final members =
            await _repo.getMembers(authState.token, event.workspaceId);
        emit(MembersLoaded(members));
      } else {
        emit(WorkspaceDetailError("Not authenticated"));
      }
    } catch (e) {
      emit(WorkspaceDetailError("Add member failed: $e"));
    }
  }

  Future<void> _onSearchUsers(
      SearchUsers event, Emitter<WorkspaceDetailState> emit) async {
    try {
      final authState = _authBloc.state;
      if (authState is AuthAuthenticated) {
        final repo = UserRepository(UserService());
        final users = await repo.searchUsers(authState.token, event.query);
        emit(UsersFound(users));
      } else {
        emit(WorkspaceDetailError("Not authenticated"));
      }
    } catch (e) {
      emit(WorkspaceDetailError("Search failed: $e"));
    }
  }
}
