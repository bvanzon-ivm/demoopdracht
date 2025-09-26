import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
import '../../attachments/repositories/attachment_repository.dart';

abstract class TaskDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTaskDetail extends TaskDetailEvent {
  final int workspaceId;
  final int taskId;
  LoadTaskDetail(this.workspaceId, this.taskId);
}

class UploadAttachmentRequested extends TaskDetailEvent {
  final int workspaceId;
  final int taskId;
  final String name;
  final List<int> bytes;
  UploadAttachmentRequested(
    this.workspaceId,
    this.taskId,
    this.name,
    this.bytes,
  );
}

class RollbackFieldRequested extends TaskDetailEvent {
  final int workspaceId;
  final int taskId;
  final String field;
  final int versionId;
  RollbackFieldRequested(
    this.workspaceId,
    this.taskId,
    this.field,
    this.versionId,
  );
}

abstract class TaskDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskDetailInitial extends TaskDetailState {}

class TaskDetailLoading extends TaskDetailState {}

class TaskDetailLoaded extends TaskDetailState {
  final Task task;
  final List<Map<String, dynamic>> audit;
  TaskDetailLoaded(this.task, this.audit);
  @override
  List<Object?> get props => [task, audit];
}

class TaskDetailError extends TaskDetailState {
  final String message;
  TaskDetailError(this.message);
  @override
  List<Object?> get props => [message];
}
class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  final TaskRepository taskRepo;
  final AttachmentRepository attachmentRepo;

  TaskDetailBloc({
    required this.taskRepo,
    required this.attachmentRepo,
  }) : super(TaskDetailInitial()) {
    on<LoadTaskDetail>(_onLoad);
    on<UploadAttachmentRequested>(_onUpload);
    on<RollbackFieldRequested>(_onRollback);
  }

  Future<void> _onLoad(
      LoadTaskDetail e, Emitter<TaskDetailState> emit) async {
    emit(TaskDetailLoading());
    try {
      final task = await taskRepo.get(e.workspaceId, e.taskId);
      final audit = await taskRepo.audit(e.workspaceId, e.taskId);
      emit(TaskDetailLoaded(task, audit));
    } catch (err) {
      emit(TaskDetailError(err.toString()));
    }
  }

  Future<void> _onUpload(
      UploadAttachmentRequested e, Emitter<TaskDetailState> emit) async {
    if (state is! TaskDetailLoaded) return;
    try {
      await attachmentRepo.upload(e.workspaceId, e.taskId, e.name, e.bytes);
      add(LoadTaskDetail(e.workspaceId, e.taskId));
    } catch (err) {
      emit(TaskDetailError(err.toString()));
    }
  }

  Future<void> _onRollback(
      RollbackFieldRequested e, Emitter<TaskDetailState> emit) async {
    if (state is! TaskDetailLoaded) return;
    try {
      await taskRepo.rollback(e.workspaceId, e.taskId, e.field, e.versionId);
      add(LoadTaskDetail(e.workspaceId, e.taskId));
    } catch (err) {
      emit(TaskDetailError(err.toString()));
    }
  }
}