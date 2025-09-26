package boukevanzon.Anchiano.dto;

import boukevanzon.Anchiano.enums.TaskPriority;
import boukevanzon.Anchiano.enums.TaskStatus;
import lombok.*;
import java.time.LocalDateTime;
import java.util.List;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class TaskDto {
    private Long id;
    private Long workspaceId;
    private String title;
    private String description;
    private TaskStatus status;
    private TaskPriority priority;
    private LocalDateTime dueDate;

    private List<LabelDto> labels;
    private List<UserDto> assignees;
    private UserDto createdBy;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;
}
