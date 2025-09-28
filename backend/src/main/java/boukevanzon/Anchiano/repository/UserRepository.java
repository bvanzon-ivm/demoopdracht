package boukevanzon.Anchiano.repository;

import boukevanzon.Anchiano.model.Membership;
import boukevanzon.Anchiano.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmailIgnoreCase(String email);
    boolean existsByEmailIgnoreCase(String email);
    List<User> findByEmailContainingIgnoreCase(String emailPart);
}
