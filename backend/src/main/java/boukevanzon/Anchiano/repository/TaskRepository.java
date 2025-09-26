package boukevanzon.Anchiano.repository;

import boukevanzon.Anchiano.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface TaskRepository extends JpaRepository<Task, Long> {
    List<Task> findByWorkspace_IdAndDeletedAtIsNull(Long workspaceId);
    Optional<Task> findByIdAndWorkspace_IdAndDeletedAtIsNull(Long id, Long workspaceId);
}
