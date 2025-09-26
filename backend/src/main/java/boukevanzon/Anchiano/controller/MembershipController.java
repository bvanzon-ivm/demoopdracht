package boukevanzon.Anchiano.controller;

import boukevanzon.Anchiano.dto.MembershipDto;
import boukevanzon.Anchiano.service.MembershipService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/workspaces/{workspaceId}/memberships")
public class MembershipController {

    private final MembershipService membershipService;

    public MembershipController(MembershipService membershipService) {
        this.membershipService = membershipService;
    }

    @GetMapping
    public ResponseEntity<List<MembershipDto>> list(Authentication auth, @PathVariable Long workspaceId) {
        return ResponseEntity.ok(membershipService.getMembers(auth, workspaceId));
    }

    @PostMapping
    public ResponseEntity<MembershipDto> add(
            Authentication auth,
            @PathVariable Long workspaceId,
            @Valid @RequestBody MembershipDto dto
    ) {
        return ResponseEntity.ok(membershipService.addMember(auth, workspaceId, dto));
    }

    @DeleteMapping("/{memberId}")
    public ResponseEntity<Void> remove(
            Authentication auth,
            @PathVariable Long workspaceId,
            @PathVariable Long memberId
    ) {
        membershipService.removeMember(auth, workspaceId, memberId);
        return ResponseEntity.noContent().build();
    }
}
