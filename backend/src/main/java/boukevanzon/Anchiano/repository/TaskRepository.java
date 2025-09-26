package boukevanzon.Anchiano.repository;

import boukevanzon.Anchiano.model.Task;
import boukevanzon.Anchiano.model.Workspace;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TaskRepository extends JpaRepository<Task, Long> {
    List<Task> findByWorkspace(Workspace workspace);
}
