package boukevanzon.Anchiano.controller;

import boukevanzon.Anchiano.dto.AuditDto;
import boukevanzon.Anchiano.service.AuditService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/workspaces/{workspaceId}/audits")
public class AuditController {

    private final AuditService auditService;

    public AuditController(AuditService auditService) {
        this.auditService = auditService;
    }

    @GetMapping
    public ResponseEntity<List<AuditDto>> list(Authentication auth, @PathVariable Long workspaceId) {
        return ResponseEntity.ok(auditService.getAudits(auth, workspaceId));
    }
}
