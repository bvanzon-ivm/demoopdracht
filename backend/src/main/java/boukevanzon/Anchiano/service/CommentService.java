package boukevanzon.Anchiano.service;

import boukevanzon.Anchiano.dto.CommentDto;
import org.springframework.security.core.Authentication;

import java.util.List;

public interface CommentService {
    List<CommentDto> getComments(Authentication auth, Long workspaceId, Long taskId);
    CommentDto addComment(Authentication auth, Long workspaceId, Long taskId, CommentDto dto);
    CommentDto updateComment(Authentication auth, Long workspaceId, Long taskId, Long commentId, CommentDto dto);
    void deleteComment(Authentication auth, Long workspaceId, Long taskId, Long commentId);
}
