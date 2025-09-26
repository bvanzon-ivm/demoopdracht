package boukevanzon.Anchiano.service.impl;

import boukevanzon.Anchiano.dto.WorkspaceDto;
import boukevanzon.Anchiano.mapper.WorkspaceMapper;
import boukevanzon.Anchiano.model.User;
import boukevanzon.Anchiano.model.Workspace;
import boukevanzon.Anchiano.repository.UserRepository;
import boukevanzon.Anchiano.repository.WorkspaceRepository;
import boukevanzon.Anchiano.service.WorkspaceService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WorkspaceServiceImpl implements WorkspaceService {

    private final WorkspaceRepository wsRepo;
    private final UserRepository userRepo;
    private final WorkspaceMapper wsMapper;

    public WorkspaceServiceImpl(WorkspaceRepository wsRepo, UserRepository userRepo, WorkspaceMapper wsMapper) {
        this.wsRepo = wsRepo;
        this.userRepo = userRepo;
        this.wsMapper = wsMapper;
    }

    @Override
    public List<WorkspaceDto> getMyWorkspaces(Authentication auth) {
        User user = userRepo.findByEmailIgnoreCase(auth.getName()).orElseThrow();
        return wsRepo.findByOwner(user).stream().map(wsMapper::toDto).toList();
    }

    @Override
    public WorkspaceDto getWorkspace(Authentication auth, Long workspaceId) {
        Workspace ws = wsRepo.findById(workspaceId).orElseThrow();
        return wsMapper.toDto(ws);
    }

    @Override
    public WorkspaceDto createWorkspace(Authentication auth, WorkspaceDto dto) {
        User user = userRepo.findByEmailIgnoreCase(auth.getName()).orElseThrow();
        Workspace ws = wsMapper.toEntity(dto);
        ws.setOwner(user);
        wsRepo.save(ws);
        return wsMapper.toDto(ws);
    }

    @Override
    public WorkspaceDto updateWorkspace(Authentication auth, Long workspaceId, WorkspaceDto dto) {
        Workspace ws = wsRepo.findById(workspaceId).orElseThrow();
        ws.setName(dto.getName());
        ws.setDescription(dto.getDescription());
        wsRepo.save(ws);
        return wsMapper.toDto(ws);
    }

    @Override
    public void deleteWorkspace(Authentication auth, Long workspaceId) {
        wsRepo.deleteById(workspaceId);
    }
}
