package boukevanzon.Anchiano.dto;

import lombok.*;
import java.time.LocalDateTime;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class CommentDto {
    private Long id;
    private Long taskId;
    private Long authorId;
    private Long parentCommentId;
    private String body;
    private LocalDateTime createdAt;
    private LocalDateTime editedAt;
    private Long editedById;
}
