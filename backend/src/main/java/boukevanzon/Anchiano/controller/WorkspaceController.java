package boukevanzon.Anchiano.controller;

import boukevanzon.Anchiano.dto.*;
import boukevanzon.Anchiano.model.*;
import boukevanzon.Anchiano.repository.*;
import org.springframework.http.*;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/workspaces")
public class WorkspaceController {

    private final WorkspaceRepository workspaceRepository;
    private final WorkspaceMembershipRepository membershipRepository;
    private final UserRepository userRepository;

    public WorkspaceController(WorkspaceRepository workspaceRepository,
                               WorkspaceMembershipRepository membershipRepository,
                               UserRepository userRepository) {
        this.workspaceRepository = workspaceRepository;
        this.membershipRepository = membershipRepository;
        this.userRepository = userRepository;
    }

    // --- helpers -------------------------------------------------------------

    private User requireMe(Authentication auth) {
        return userRepository.findByEmail(auth.getName())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not found"));
    }

    private Workspace requireWorkspace(Long id) {
        return workspaceRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
    }

    private boolean isOwner(User me, Workspace ws) {
        return ws.getOwner() != null && me.getId().equals(ws.getOwner().getId());
    }

    private boolean isMember(Long wsId, Long userId) {
        return membershipRepository.existsByWorkspace_IdAndUser_Id(wsId, userId);
    }

    private static UserDto toUserDto(User u) {
        return new UserDto(u.getId(), u.getName(), u.getEmail());
    }

    // --- endpoints -----------------------------------------------------------

    /** Lijst van workspaces waar je owner of member van bent (lichte DTO). */
    @GetMapping
    public List<WorkspaceListItemDto> getMine(Authentication authentication) {
        User me = requireMe(authentication);

     
            List<Workspace> visible = workspaceRepository.findAllVisibleToUser(me.getId());

        return visible.stream().map(ws -> new WorkspaceListItemDto(
            ws.getId(),
            ws.getName(),
            ws.getDescription(),
            toUserDto(ws.getOwner()),
            isOwner(me, ws),
            (int) membershipRepository.countByWorkspace_Id(ws.getId())
        )).toList();
    }

    /** Aanmaken: owner = ingelogde user. */
    @PostMapping
    public ResponseEntity<WorkspaceDetailDto> create(Authentication authentication,
                                                     @RequestBody CreateWorkspaceRequest req) {
        User owner = requireMe(authentication);

        Workspace ws = new Workspace();
        ws.setName(req.name());
        ws.setDescription(req.description());
        ws.setOwner(owner);
        ws.setCreatedAt(Instant.now());
        ws.setUpdatedAt(Instant.now());
        Workspace saved = workspaceRepository.save(ws);

        // desgewenst: membership OWNER registreren
        // WorkspaceMembership mem = new WorkspaceMembership();
        // mem.setWorkspace(saved);
        // mem.setUser(owner);
        // mem.setRole(WorkspaceRole.OWNER);
        // membershipRepository.save(mem);

        WorkspaceDetailDto dto = new WorkspaceDetailDto(
                saved.getId(),
                saved.getName(),
                saved.getDescription(),
                toUserDto(owner),
                true,
                List.of(toUserDto(owner)) // minimaal owner in members
        );
        return ResponseEntity.status(HttpStatus.CREATED).body(dto);
    }

    /** Detail: alleen zichtbaar als je owner of member bent. */
    @GetMapping("/{id}")
    public ResponseEntity<WorkspaceDetailDto> getById(@PathVariable Long id, Authentication auth) {
        User me = requireMe(auth);
        Workspace ws = requireWorkspace(id);
        if (!(isOwner(me, ws) || isMember(id, me.getId()))) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }

        List<UserDto> members = membershipRepository.findByWorkspace_Id(id).stream()
                .map(WorkspaceMembership::getUser)
                .map(WorkspaceController::toUserDto)
                .collect(Collectors.toList());

        // Owner minimaal opnemen in weergave (als hij niet reeds als membership staat)
        if (ws.getOwner() != null && members.stream().noneMatch(u -> u.id().equals(ws.getOwner().getId()))) {
            members = new ArrayList<>(members);
            members.add(toUserDto(ws.getOwner()));
        }

        WorkspaceDetailDto dto = new WorkspaceDetailDto(
                ws.getId(),
                ws.getName(),
                ws.getDescription(),
                toUserDto(ws.getOwner()),
                isOwner(me, ws),
                members
        );
        return ResponseEntity.ok(dto);
    }

    /** Member toevoegen op EMAIL (past bij je frontend). Body: { "email": "x@y.z" } */
    @PostMapping("/{id}/members")
    public ResponseEntity<Void> addMemberByEmail(@PathVariable Long id,
                                                 @RequestBody Map<String, Object> body,
                                                 Authentication authentication) {
        User me = requireMe(authentication);
        Workspace ws = requireWorkspace(id);
        if (!isOwner(me, ws)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Only owner can add members");
        }

        String email = Optional.ofNullable(body.get("email"))
                .map(Object::toString)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "email required"));

        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        if (!isMember(id, user.getId())) {
            WorkspaceMembership m = new WorkspaceMembership();
            m.setWorkspace(ws);
            m.setUser(user);
            // default role = MEMBER
            membershipRepository.save(m);
        }
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    /** Member verwijderen op userId (blijft handig). */
    @DeleteMapping("/{id}/members/{userId}")
    public ResponseEntity<Void> removeMember(@PathVariable Long id,
                                             @PathVariable Long userId,
                                             Authentication authentication) {
        User me = requireMe(authentication);
        Workspace ws = requireWorkspace(id);
        if (!isOwner(me, ws)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Only owner can remove members");
        }
        membershipRepository.deleteByWorkspace_IdAndUser_Id(id, userId);
        return ResponseEntity.noContent().build();
    }
}
