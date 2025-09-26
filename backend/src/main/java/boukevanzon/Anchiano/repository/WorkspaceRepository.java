package boukevanzon.Anchiano.repository;

import boukevanzon.Anchiano.model.User;
import boukevanzon.Anchiano.model.Workspace;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface WorkspaceRepository extends JpaRepository<Workspace, Long> {
    List<Workspace> findByOwner(User owner);
}
