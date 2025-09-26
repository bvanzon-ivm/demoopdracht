package boukevanzon.Anchiano.dto;

import lombok.*;
import java.time.LocalDateTime;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class WorkspaceDto {
    private Long id;
    private String name;
    private String description;
    private UserDto owner;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;
}
