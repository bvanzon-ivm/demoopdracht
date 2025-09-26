package boukevanzon.Anchiano.controller;

import boukevanzon.Anchiano.dto.AttachmentDto;
import boukevanzon.Anchiano.service.AttachmentService;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/workspaces/{workspaceId}/tasks/{taskId}/attachments")
public class AttachmentController {

    private final AttachmentService attachmentService;

    public AttachmentController(AttachmentService attachmentService) {
        this.attachmentService = attachmentService;
    }

    @GetMapping
    public ResponseEntity<List<AttachmentDto>> list(
            Authentication auth,
            @PathVariable Long workspaceId,
            @PathVariable Long taskId
    ) {
        return ResponseEntity.ok(attachmentService.getAttachments(auth, workspaceId, taskId));
    }

    @PostMapping
    public ResponseEntity<AttachmentDto> upload(
            Authentication auth,
            @PathVariable Long workspaceId,
            @PathVariable Long taskId,
            @RequestParam("file") MultipartFile file
    ) {
        return ResponseEntity.ok(attachmentService.uploadAttachment(auth, workspaceId, taskId, file));
    }

    @DeleteMapping("/{attachmentId}")
    public ResponseEntity<Void> delete(
            Authentication auth,
            @PathVariable Long workspaceId,
            @PathVariable Long taskId,
            @PathVariable Long attachmentId
    ) {
        attachmentService.deleteAttachment(auth, workspaceId, taskId, attachmentId);
        return ResponseEntity.noContent().build();
    }
}
