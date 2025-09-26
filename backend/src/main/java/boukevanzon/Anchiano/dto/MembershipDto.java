package boukevanzon.Anchiano.dto;

import boukevanzon.Anchiano.enums.WorkspaceRole;
import lombok.*;
import java.time.LocalDateTime;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class MembershipDto {
    private Long id;
    private Long workspaceId;
    private UserDto user;
    private WorkspaceRole role;
    private LocalDateTime createdAt;
}
