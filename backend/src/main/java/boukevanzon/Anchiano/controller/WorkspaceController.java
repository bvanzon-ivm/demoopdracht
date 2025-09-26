package boukevanzon.Anchiano.controller;

import boukevanzon.Anchiano.dto.WorkspaceDto;
import boukevanzon.Anchiano.service.WorkspaceService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/workspaces")
public class WorkspaceController {

    private final WorkspaceService workspaceService;

    public WorkspaceController(WorkspaceService workspaceService) {
        this.workspaceService = workspaceService;
    }

    @GetMapping
    public ResponseEntity<List<WorkspaceDto>> list(Authentication auth) {
        return ResponseEntity.ok(workspaceService.getMyWorkspaces(auth));
    }

    @GetMapping("/{workspaceId}")
    public ResponseEntity<WorkspaceDto> getOne(
            Authentication auth,
            @PathVariable Long workspaceId
    ) {
        return ResponseEntity.ok(workspaceService.getWorkspace(auth, workspaceId));
    }

    @PostMapping
    public ResponseEntity<WorkspaceDto> create(
            Authentication auth,
            @Valid @RequestBody WorkspaceDto dto
    ) {
        return ResponseEntity.ok(workspaceService.createWorkspace(auth, dto));
    }

    @PutMapping("/{workspaceId}")
    public ResponseEntity<WorkspaceDto> update(
            Authentication auth,
            @PathVariable Long workspaceId,
            @Valid @RequestBody WorkspaceDto dto
    ) {
        return ResponseEntity.ok(workspaceService.updateWorkspace(auth, workspaceId, dto));
    }

    @DeleteMapping("/{workspaceId}")
    public ResponseEntity<Void> delete(
            Authentication auth,
            @PathVariable Long workspaceId
    ) {
        workspaceService.deleteWorkspace(auth, workspaceId);
        return ResponseEntity.noContent().build();
    }
}
