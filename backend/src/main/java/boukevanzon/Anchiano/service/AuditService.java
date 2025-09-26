package boukevanzon.Anchiano.service;

import boukevanzon.Anchiano.dto.AuditDto;
import org.springframework.security.core.Authentication;

import java.util.List;

public interface AuditService {
    List<AuditDto> getAudits(Authentication auth, Long workspaceId);
}
