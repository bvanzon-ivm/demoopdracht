package boukevanzon.Anchiano.service.impl;

import boukevanzon.Anchiano.dto.AttachmentDto;
import boukevanzon.Anchiano.mapper.AttachmentMapper;
import boukevanzon.Anchiano.model.Attachment;
import boukevanzon.Anchiano.model.Task;
import boukevanzon.Anchiano.repository.AttachmentRepository;
import boukevanzon.Anchiano.repository.TaskRepository;
import boukevanzon.Anchiano.service.AttachmentService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

@Service
public class AttachmentServiceImpl implements AttachmentService {

    private final AttachmentRepository attachmentRepo;
    private final TaskRepository taskRepo;
    private final AttachmentMapper mapper;

    public AttachmentServiceImpl(AttachmentRepository attachmentRepo, TaskRepository taskRepo, AttachmentMapper mapper) {
        this.attachmentRepo = attachmentRepo;
        this.taskRepo = taskRepo;
        this.mapper = mapper;
    }

    @Override
    public List<AttachmentDto> getAttachments(Authentication auth, Long workspaceId, Long taskId) {
        Task task = taskRepo.findById(taskId).orElseThrow();
        return attachmentRepo.findByTask(task).stream().map(mapper::toDto).toList();
    }

    @Override
    public AttachmentDto uploadAttachment(Authentication auth, Long workspaceId, Long taskId, MultipartFile file) {
        Task task = taskRepo.findById(taskId).orElseThrow();
        try {
            Path path = Files.createTempFile("upload_", "_" + file.getOriginalFilename());
            file.transferTo(path);

            Attachment att = Attachment.builder()
                    .task(task)
                    .filename(file.getOriginalFilename())
                    .contentType(file.getContentType())
                    .size(file.getSize())
                    .path(path.toString())
                    .build();

            attachmentRepo.save(att);
            return mapper.toDto(att);
        } catch (IOException e) {
            throw new RuntimeException("File upload failed", e);
        }
    }

    @Override
    public void deleteAttachment(Authentication auth, Long workspaceId, Long taskId, Long attachmentId) {
        attachmentRepo.deleteById(attachmentId);
    }
}
