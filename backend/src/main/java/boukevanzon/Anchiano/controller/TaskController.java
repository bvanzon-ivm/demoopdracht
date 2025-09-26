package boukevanzon.Anchiano.controller;

import boukevanzon.Anchiano.dto.TaskDto;
import boukevanzon.Anchiano.service.TaskService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/workspaces/{workspaceId}/tasks")
public class TaskController {

    private final TaskService taskService;

    public TaskController(TaskService taskService) {
        this.taskService = taskService;
    }

    @GetMapping
    public ResponseEntity<List<TaskDto>> getTasks(
            Authentication auth,
            @PathVariable Long workspaceId
    ) {
        return ResponseEntity.ok(taskService.getTasks(auth, workspaceId));
    }

    @GetMapping("/{taskId}")
    public ResponseEntity<TaskDto> getTask(
            Authentication auth,
            @PathVariable Long workspaceId,
            @PathVariable Long taskId
    ) {
        return ResponseEntity.ok(taskService.getTask(auth, workspaceId, taskId));
    }

    @PostMapping
    public ResponseEntity<TaskDto> createTask(
            Authentication auth,
            @PathVariable Long workspaceId,
            @Valid @RequestBody TaskDto dto
    ) {
        return ResponseEntity.ok(taskService.createTask(auth, workspaceId, dto));
    }

    @PutMapping("/{taskId}")
    public ResponseEntity<TaskDto> updateTask(
            Authentication auth,
            @PathVariable Long workspaceId,
            @PathVariable Long taskId,
            @Valid @RequestBody TaskDto dto
    ) {
        return ResponseEntity.ok(taskService.updateTask(auth, workspaceId, taskId, dto));
    }

    @DeleteMapping("/{taskId}")
    public ResponseEntity<Void> deleteTask(
            Authentication auth,
            @PathVariable Long workspaceId,
            @PathVariable Long taskId
    ) {
        taskService.deleteTask(auth, workspaceId, taskId);
        return ResponseEntity.noContent().build();
    }
}
