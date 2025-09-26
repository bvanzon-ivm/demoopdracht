package boukevanzon.Anchiano.dto;

import lombok.*;
import java.time.LocalDateTime;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class AuditDto {
    private Long id;
    private Long workspaceId;
    private Long userId;
    private String userName;
    private String userEmail;
    private String action;
    private LocalDateTime timestamp;
    private String oldValue;
    private String newValue;
}
