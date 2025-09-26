package boukevanzon.Anchiano.repository;

import boukevanzon.Anchiano.model.Membership;
import boukevanzon.Anchiano.model.User;
import boukevanzon.Anchiano.model.Workspace;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MembershipRepository extends JpaRepository<Membership, Long> {
    List<Membership> findByWorkspace(Workspace workspace);
    Optional<Membership> findByWorkspaceAndUser(Workspace workspace, User user);
    boolean existsByWorkspaceAndUser(Workspace workspace, User user);
}
