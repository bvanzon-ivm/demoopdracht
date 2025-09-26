package boukevanzon.Anchiano.service;

import boukevanzon.Anchiano.dto.WorkspaceDto;
import org.springframework.security.core.Authentication;

import java.util.List;

public interface WorkspaceService {
    List<WorkspaceDto> getMyWorkspaces(Authentication auth);
    WorkspaceDto getWorkspace(Authentication auth, Long workspaceId);
    WorkspaceDto createWorkspace(Authentication auth, WorkspaceDto dto);
    WorkspaceDto updateWorkspace(Authentication auth, Long workspaceId, WorkspaceDto dto);
    void deleteWorkspace(Authentication auth, Long workspaceId);
}
