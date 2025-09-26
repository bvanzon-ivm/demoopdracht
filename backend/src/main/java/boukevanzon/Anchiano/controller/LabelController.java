package boukevanzon.Anchiano.controller;

import boukevanzon.Anchiano.dto.LabelDto;
import boukevanzon.Anchiano.service.LabelService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/workspaces/{workspaceId}/labels")
public class LabelController {

    private final LabelService labelService;

    public LabelController(LabelService labelService) {
        this.labelService = labelService;
    }

    @GetMapping
    public ResponseEntity<List<LabelDto>> list(Authentication auth, @PathVariable Long workspaceId) {
        return ResponseEntity.ok(labelService.getLabels(auth, workspaceId));
    }

    @PostMapping
    public ResponseEntity<LabelDto> create(
            Authentication auth,
            @PathVariable Long workspaceId,
            @Valid @RequestBody LabelDto dto
    ) {
        return ResponseEntity.ok(labelService.createLabel(auth, workspaceId, dto));
    }

    @DeleteMapping("/{labelId}")
    public ResponseEntity<Void> delete(
            Authentication auth,
            @PathVariable Long workspaceId,
            @PathVariable Long labelId
    ) {
        labelService.deleteLabel(auth, workspaceId, labelId);
        return ResponseEntity.noContent().build();
    }
}
