package boukevanzon.Anchiano.dto;

import lombok.*;
import java.time.LocalDateTime;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class AttachmentDto {
    private Long id;
    private Long taskId;
    private String filename;
    private String contentType;
    private long size;
    private String path;
    private LocalDateTime uploadedAt;
}
