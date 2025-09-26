package boukevanzon.Anchiano.service;

import boukevanzon.Anchiano.dto.MembershipDto;
import org.springframework.security.core.Authentication;

import java.util.List;

public interface MembershipService {
    List<MembershipDto> getMembers(Authentication auth, Long workspaceId);
    MembershipDto addMember(Authentication auth, Long workspaceId, MembershipDto dto);
    void removeMember(Authentication auth, Long workspaceId, Long memberId);
}
