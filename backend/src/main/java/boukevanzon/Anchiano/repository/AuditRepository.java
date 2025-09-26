package boukevanzon.Anchiano.repository;

import boukevanzon.Anchiano.model.Audit;
import boukevanzon.Anchiano.model.Workspace;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AuditRepository extends JpaRepository<Audit, Long> {
    List<Audit> findByWorkspaceOrderByTimestampDesc(Workspace workspace);
}
