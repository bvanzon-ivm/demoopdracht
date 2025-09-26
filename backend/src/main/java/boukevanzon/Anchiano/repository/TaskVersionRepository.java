package boukevanzon.Anchiano.repository;

import boukevanzon.Anchiano.model.TaskVersion;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface TaskVersionRepository extends JpaRepository<TaskVersion, Long> {
    List<TaskVersion> findByTask_IdOrderByIdDesc(Long taskId);
}
