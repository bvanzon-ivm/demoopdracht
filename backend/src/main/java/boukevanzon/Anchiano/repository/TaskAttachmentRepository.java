package boukevanzon.Anchiano.repository;

import boukevanzon.Anchiano.model.TaskAttachment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface TaskAttachmentRepository extends JpaRepository<TaskAttachment, Long> {
    List<TaskAttachment> findByTask_Id(Long taskId);
}
