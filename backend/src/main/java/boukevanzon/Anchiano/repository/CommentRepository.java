package boukevanzon.Anchiano.repository;

import boukevanzon.Anchiano.model.Comment;
import boukevanzon.Anchiano.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findByTask(Task task);
    List<Comment> findByParentCommentId(Long parentId);
}
