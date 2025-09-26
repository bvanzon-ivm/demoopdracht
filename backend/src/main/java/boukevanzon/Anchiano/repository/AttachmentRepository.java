package boukevanzon.Anchiano.repository;

import boukevanzon.Anchiano.model.Attachment;
import boukevanzon.Anchiano.model.Task;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AttachmentRepository extends JpaRepository<Attachment, Long> {
    List<Attachment> findByTask(Task task);
    void deleteByTaskId(Long taskId);
}
