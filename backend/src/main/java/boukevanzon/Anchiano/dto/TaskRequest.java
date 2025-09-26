package boukevanzon.Anchiano.dto;

import boukevanzon.Anchiano.enums.TaskPriority;
import boukevanzon.Anchiano.enums.TaskStatus;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class TaskRequest {
    @NotBlank private String title;
    private String description;
    private TaskPriority priority = TaskPriority.MEDIUM;
    private TaskStatus status = TaskStatus.TODO;
    private LocalDateTime dueDate;

    private List<String> labels;
    private List<Long> assigneeIds;
}
