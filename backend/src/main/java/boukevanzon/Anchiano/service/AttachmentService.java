package boukevanzon.Anchiano.service;

import boukevanzon.Anchiano.dto.AttachmentDto;
import org.springframework.security.core.Authentication;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface AttachmentService {
    List<AttachmentDto> getAttachments(Authentication auth, Long workspaceId, Long taskId);
    AttachmentDto uploadAttachment(Authentication auth, Long workspaceId, Long taskId, MultipartFile file);
    void deleteAttachment(Authentication auth, Long workspaceId, Long taskId, Long attachmentId);
}
