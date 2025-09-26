package boukevanzon.Anchiano.repository;

import boukevanzon.Anchiano.model.Workspace;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface WorkspaceRepository extends JpaRepository<Workspace, Long> {

    List<Workspace> findByOwner_Id(Long ownerId);

    @Query("""
           select distinct w
           from Workspace w
           left join WorkspaceMembership m on m.workspace = w
           where w.owner.id = :userId or m.user.id = :userId
           """)
    List<Workspace> findAllVisibleToUser(@Param("userId") Long userId);
}
