package boukevanzon.Anchiano.service.impl;

import boukevanzon.Anchiano.dto.MembershipDto;
import boukevanzon.Anchiano.mapper.MembershipMapper;
import boukevanzon.Anchiano.model.Membership;
import boukevanzon.Anchiano.model.User;
import boukevanzon.Anchiano.model.Workspace;
import boukevanzon.Anchiano.repository.MembershipRepository;
import boukevanzon.Anchiano.repository.UserRepository;
import boukevanzon.Anchiano.repository.WorkspaceRepository;
import boukevanzon.Anchiano.service.MembershipService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MembershipServiceImpl implements MembershipService {

    private final MembershipRepository membershipRepo;
    private final WorkspaceRepository wsRepo;
    private final UserRepository userRepo;
    private final MembershipMapper mapper;

    public MembershipServiceImpl(MembershipRepository membershipRepo, WorkspaceRepository wsRepo,
                                 UserRepository userRepo, MembershipMapper mapper) {
        this.membershipRepo = membershipRepo;
        this.wsRepo = wsRepo;
        this.userRepo = userRepo;
        this.mapper = mapper;
    }

    @Override
    public List<MembershipDto> getMembers(Authentication auth, Long workspaceId) {
        Workspace ws = wsRepo.findById(workspaceId).orElseThrow();
        return membershipRepo.findByWorkspace(ws).stream().map(mapper::toDto).toList();
    }

    @Override
    public MembershipDto addMember(Authentication auth, Long workspaceId, MembershipDto dto) {
        Workspace ws = wsRepo.findById(workspaceId).orElseThrow();
        User user = userRepo.findById(dto.getUser().getId()).orElseThrow();
        Membership member = Membership.builder()
                .workspace(ws)
                .user(user)
                .role(dto.getRole())
                .build();
        membershipRepo.save(member);
        return mapper.toDto(member);
    }

    @Override
    public void removeMember(Authentication auth, Long workspaceId, Long memberId) {
        membershipRepo.deleteById(memberId);
    }
}
