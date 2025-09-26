package boukevanzon.Anchiano.controller;

import boukevanzon.Anchiano.dto.CommentDto;
import boukevanzon.Anchiano.service.CommentService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/workspaces/{workspaceId}/tasks/{taskId}/comments")
public class CommentController {

    private final CommentService commentService;

    public CommentController(CommentService commentService) {
        this.commentService = commentService;
    }

    @GetMapping
    public ResponseEntity<List<CommentDto>> list(
            Authentication auth,
            @PathVariable Long workspaceId,
            @PathVariable Long taskId
    ) {
        return ResponseEntity.ok(commentService.getComments(auth, workspaceId, taskId));
    }

    @PostMapping
    public ResponseEntity<CommentDto> create(
            Authentication auth,
            @PathVariable Long workspaceId,
            @PathVariable Long taskId,
            @Valid @RequestBody CommentDto dto
    ) {
        return ResponseEntity.ok(commentService.addComment(auth, workspaceId, taskId, dto));
    }

    @PutMapping("/{commentId}")
    public ResponseEntity<CommentDto> update(
            Authentication auth,
            @PathVariable Long workspaceId,
            @PathVariable Long taskId,
            @PathVariable Long commentId,
            @Valid @RequestBody CommentDto dto
    ) {
        return ResponseEntity.ok(commentService.updateComment(auth, workspaceId, taskId, commentId, dto));
    }

    @DeleteMapping("/{commentId}")
    public ResponseEntity<Void> delete(
            Authentication auth,
            @PathVariable Long workspaceId,
            @PathVariable Long taskId,
            @PathVariable Long commentId
    ) {
        commentService.deleteComment(auth, workspaceId, taskId, commentId);
        return ResponseEntity.noContent().build();
    }
}
