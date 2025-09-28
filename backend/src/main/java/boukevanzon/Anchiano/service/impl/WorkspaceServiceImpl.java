package boukevanzon.Anchiano.service.impl;

import boukevanzon.Anchiano.dto.MembershipDto;
import boukevanzon.Anchiano.dto.WorkspaceDto;
import boukevanzon.Anchiano.enums.WorkspaceRole;
import boukevanzon.Anchiano.mapper.MembershipMapper;
import boukevanzon.Anchiano.mapper.WorkspaceMapper;
import boukevanzon.Anchiano.model.Membership;
import boukevanzon.Anchiano.model.User;
import boukevanzon.Anchiano.model.Workspace;
import boukevanzon.Anchiano.repository.MembershipRepository;
import boukevanzon.Anchiano.repository.UserRepository;
import boukevanzon.Anchiano.repository.WorkspaceRepository;
import boukevanzon.Anchiano.service.WorkspaceService;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;


import java.util.List;
import java.util.stream.Stream;

@Service
public class WorkspaceServiceImpl implements WorkspaceService {

    private final WorkspaceRepository wsRepo;
    private final UserRepository userRepo;
    private final MembershipRepository membershipRepo;
    private final WorkspaceMapper wsMapper;
    private final MembershipMapper membershipMapper;

    public WorkspaceServiceImpl(
            WorkspaceRepository wsRepo,
            UserRepository userRepo,
            MembershipRepository membershipRepo,
            WorkspaceMapper wsMapper,
            MembershipMapper membershipMapper
    ) {
        this.wsRepo = wsRepo;
        this.userRepo = userRepo;
        this.membershipRepo = membershipRepo;
        this.wsMapper = wsMapper;
        this.membershipMapper = membershipMapper;
    }

    @Override
    public List<WorkspaceDto> getMyWorkspaces(Authentication auth) {
        User user = userRepo.findByEmailIgnoreCase(auth.getName()).orElseThrow();

        // Workspaces waarvan je eigenaar bent
        List<Workspace> owned = wsRepo.findByOwner(user);

        // Workspaces waarvan je member bent
        List<Workspace> memberOf = membershipRepo.findByUser(user)
                .stream()
                .map(Membership::getWorkspace)
                .toList();

        return Stream.concat(owned.stream(), memberOf.stream())
                .distinct()
                .map(wsMapper::toDto)
                .toList();
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

        // ook een membership voor de owner
        Membership ownerMembership = Membership.builder()
                .workspace(ws)
                .user(user)
                .role(WorkspaceRole.OWNER)
                .build();
        membershipRepo.save(ownerMembership);

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


    @Override
    public List<MembershipDto> getMembers(Authentication auth, Long workspaceId) {
        User user = userRepo.findByEmailIgnoreCase(auth.getName()).orElseThrow();
        Workspace ws = wsRepo.findById(workspaceId).orElseThrow();

        boolean isMember = ws.getOwner().equals(user) ||
                membershipRepo.findByWorkspaceAndUser(ws, user).isPresent();

        if (!isMember) {
            throw new AccessDeniedException("Not a member of this workspace");
        }

        return membershipRepo.findByWorkspace(ws)
                .stream()
                .map(membershipMapper::toDto)
                .toList();
    }

    @Override
    public void addMember(Authentication auth, Long workspaceId, Long userId, String role) {
        User currentUser = userRepo.findByEmailIgnoreCase(auth.getName()).orElseThrow();
        Workspace ws = wsRepo.findById(workspaceId).orElseThrow();

        // Alleen owner of admin mag toevoegen
        boolean isAllowed = ws.getOwner().equals(currentUser) ||
                membershipRepo.findByWorkspaceAndUser(ws, currentUser)
                        .map(m -> m.getRole() == WorkspaceRole.ADMIN)
                        .orElse(false);

        if (!isAllowed) {
            throw new AccessDeniedException("Not allowed to add members");
        }

        User newUser = userRepo.findById(userId).orElseThrow();

        Membership membership = Membership.builder()
                .workspace(ws)
                .user(newUser)
                .role(WorkspaceRole.valueOf(role))
                .build();

        membershipRepo.save(membership);
    }
}
