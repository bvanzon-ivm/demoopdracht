import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/attachment.dart';
import '../repositories/attachment_repository.dart';

abstract class AttachmentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAttachments extends AttachmentEvent {
  final int workspaceId;
  final int taskId;
  LoadAttachments(this.workspaceId, this.taskId);
}

class UploadAttachment extends AttachmentEvent {
  final int workspaceId;
  final int taskId;
  final String name;
  final List<int> bytes;
  UploadAttachment(this.workspaceId, this.taskId, this.name, this.bytes);
}

class DeleteAttachment extends AttachmentEvent {
  final int workspaceId;
  final int taskId;
  final int attachmentId;
  DeleteAttachment(this.workspaceId, this.taskId, this.attachmentId);
}

abstract class AttachmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AttachmentInitial extends AttachmentState {}

class AttachmentLoading extends AttachmentState {}

class AttachmentLoaded extends AttachmentState {
  final List<Attachment> attachments;
  AttachmentLoaded(this.attachments);
  @override
  List<Object?> get props => [attachments];
}

class AttachmentError extends AttachmentState {
  final String message;
  AttachmentError(this.message);
  @override
  List<Object?> get props => [message];
}

class AttachmentBloc extends Bloc<AttachmentEvent, AttachmentState> {
  final AttachmentRepository repo;
  AttachmentBloc(this.repo) : super(AttachmentInitial()) {
    on<LoadAttachments>(_onLoad);
    on<UploadAttachment>(_onUpload);
    on<DeleteAttachment>(_onDelete);
  }

  Future<void> _onLoad(LoadAttachments e, Emitter<AttachmentState> emit) async {
    emit(AttachmentLoading());
    try {
      final attachments = await repo.list(e.workspaceId, e.taskId);
      emit(AttachmentLoaded(attachments));
    } catch (err) {
      emit(AttachmentError(err.toString()));
    }
  }

  Future<void> _onUpload(UploadAttachment e, Emitter<AttachmentState> emit) async {
    try {
      await repo.upload(e.workspaceId, e.taskId, e.name, e.bytes);
      add(LoadAttachments(e.workspaceId, e.taskId));
    } catch (err) {
      emit(AttachmentError(err.toString()));
    }
  }

  Future<void> _onDelete(DeleteAttachment e, Emitter<AttachmentState> emit) async {
    try {
      await repo.delete(e.workspaceId, e.taskId, e.attachmentId);
      add(LoadAttachments(e.workspaceId, e.taskId));
    } catch (err) {
      emit(AttachmentError(err.toString()));
    }
  }
}
