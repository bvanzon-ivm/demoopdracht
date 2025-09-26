package boukevanzon.Anchiano.service;

import boukevanzon.Anchiano.dto.TaskDto;
import org.springframework.security.core.Authentication;

import java.util.List;

public interface TaskService {
    List<TaskDto> getTasks(Authentication auth, Long workspaceId);
    TaskDto getTask(Authentication auth, Long workspaceId, Long taskId);
    TaskDto createTask(Authentication auth, Long workspaceId, TaskDto dto);
    TaskDto updateTask(Authentication auth, Long workspaceId, Long taskId, TaskDto dto);
    void deleteTask(Authentication auth, Long workspaceId, Long taskId);
}
