package boukevanzon.Anchiano.service.impl;

import boukevanzon.Anchiano.dto.TaskDto;
import boukevanzon.Anchiano.mapper.TaskMapper;
import boukevanzon.Anchiano.model.Task;
import boukevanzon.Anchiano.model.Workspace;
import boukevanzon.Anchiano.repository.TaskRepository;
import boukevanzon.Anchiano.repository.WorkspaceRepository;
import boukevanzon.Anchiano.service.TaskService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TaskServiceImpl implements TaskService {

    private final TaskRepository taskRepo;
    private final WorkspaceRepository wsRepo;
    private final TaskMapper taskMapper;

    public TaskServiceImpl(TaskRepository taskRepo, WorkspaceRepository wsRepo, TaskMapper taskMapper) {
        this.taskRepo = taskRepo;
        this.wsRepo = wsRepo;
        this.taskMapper = taskMapper;
    }

    @Override
    public List<TaskDto> getTasks(Authentication auth, Long workspaceId) {
        Workspace ws = wsRepo.findById(workspaceId).orElseThrow();
        return taskRepo.findByWorkspace(ws).stream().map(taskMapper::toDto).toList();
    }

    @Override
    public TaskDto getTask(Authentication auth, Long workspaceId, Long taskId) {
        Task task = taskRepo.findById(taskId).orElseThrow();
        return taskMapper.toDto(task);
    }

    @Override
    public TaskDto createTask(Authentication auth, Long workspaceId, TaskDto dto) {
        Workspace ws = wsRepo.findById(workspaceId).orElseThrow();
        Task task = taskMapper.toEntity(dto);
        task.setWorkspace(ws);
        taskRepo.save(task);
        return taskMapper.toDto(task);
    }

    @Override
    public TaskDto updateTask(Authentication auth, Long workspaceId, Long taskId, TaskDto dto) {
        Task task = taskRepo.findById(taskId).orElseThrow();
        task.setTitle(dto.getTitle());
        task.setDescription(dto.getDescription());
        task.setStatus(dto.getStatus());
        task.setPriority(dto.getPriority());
        taskRepo.save(task);
        return taskMapper.toDto(task);
    }

    @Override
    public void deleteTask(Authentication auth, Long workspaceId, Long taskId) {
        taskRepo.deleteById(taskId);
    }
}
