package boukevanzon.Anchiano.service.impl;

import boukevanzon.Anchiano.dto.AuditDto;
import boukevanzon.Anchiano.mapper.AuditMapper;
import boukevanzon.Anchiano.model.Workspace;
import boukevanzon.Anchiano.repository.AuditRepository;
import boukevanzon.Anchiano.repository.WorkspaceRepository;
import boukevanzon.Anchiano.service.AuditService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AuditServiceImpl implements AuditService {

    private final AuditRepository auditRepo;
    private final WorkspaceRepository wsRepo;
    private final AuditMapper mapper;

    public AuditServiceImpl(AuditRepository auditRepo, WorkspaceRepository wsRepo, AuditMapper mapper) {
        this.auditRepo = auditRepo;
        this.wsRepo = wsRepo;
        this.mapper = mapper;
    }

    @Override
    public List<AuditDto> getAudits(Authentication auth, Long workspaceId) {
        Workspace ws = wsRepo.findById(workspaceId).orElseThrow();
        return auditRepo.findByWorkspaceOrderByTimestampDesc(ws).stream().map(mapper::toDto).toList();
    }
}
