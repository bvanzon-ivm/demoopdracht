package boukevanzon.Anchiano.service.impl;

import boukevanzon.Anchiano.dto.CommentDto;
import boukevanzon.Anchiano.mapper.CommentMapper;
import boukevanzon.Anchiano.model.Comment;
import boukevanzon.Anchiano.model.Task;
import boukevanzon.Anchiano.model.User;
import boukevanzon.Anchiano.repository.CommentRepository;
import boukevanzon.Anchiano.repository.TaskRepository;
import boukevanzon.Anchiano.repository.UserRepository;
import boukevanzon.Anchiano.service.CommentService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CommentServiceImpl implements CommentService {

    private final CommentRepository commentRepo;
    private final TaskRepository taskRepo;
    private final UserRepository userRepo;
    private final CommentMapper mapper;

    public CommentServiceImpl(CommentRepository commentRepo, TaskRepository taskRepo,
                              UserRepository userRepo, CommentMapper mapper) {
        this.commentRepo = commentRepo;
        this.taskRepo = taskRepo;
        this.userRepo = userRepo;
        this.mapper = mapper;
    }

    @Override
    public List<CommentDto> getComments(Authentication auth, Long workspaceId, Long taskId) {
        Task task = taskRepo.findById(taskId).orElseThrow();
        return commentRepo.findByTask(task).stream().map(mapper::toDto).toList();
    }

    @Override
    public CommentDto addComment(Authentication auth, Long workspaceId, Long taskId, CommentDto dto) {
        Task task = taskRepo.findById(taskId).orElseThrow();
        User user = userRepo.findByEmailIgnoreCase(auth.getName()).orElseThrow();
        Comment comment = mapper.toEntity(dto);
        comment.setTask(task);
        comment.setAuthor(user);
        commentRepo.save(comment);
        return mapper.toDto(comment);
    }

    @Override
    public CommentDto updateComment(Authentication auth, Long workspaceId, Long taskId, Long commentId, CommentDto dto) {
        Comment comment = commentRepo.findById(commentId).orElseThrow();
        comment.setBody(dto.getBody());
        commentRepo.save(comment);
        return mapper.toDto(comment);
    }

    @Override
    public void deleteComment(Authentication auth, Long workspaceId, Long taskId, Long commentId) {
        commentRepo.deleteById(commentId);
    }
}
