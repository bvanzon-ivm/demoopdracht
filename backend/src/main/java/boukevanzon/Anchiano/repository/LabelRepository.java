package boukevanzon.Anchiano.repository;

import boukevanzon.Anchiano.model.Label;
import boukevanzon.Anchiano.model.Workspace;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface LabelRepository extends JpaRepository<Label, Long> {
    List<Label> findByWorkspaceAndActiveTrue(Workspace workspace);
    Optional<Label> findByWorkspaceAndNameIgnoreCase(Workspace workspace, String name);
}
