package boukevanzon.Anchiano.repository;

import boukevanzon.Anchiano.model.WorkspaceMembership;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface WorkspaceMembershipRepository extends JpaRepository<WorkspaceMembership, Long> {
    boolean existsByWorkspace_IdAndUser_Id(Long workspaceId, Long userId);
    long countByWorkspace_Id(Long workspaceId);
    void deleteByWorkspace_IdAndUser_Id(Long workspaceId, Long userId);
    List<WorkspaceMembership> findByWorkspace_Id(Long workspaceId);
    List<WorkspaceMembership> findByUser_Id(Long userId);
}

