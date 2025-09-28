package boukevanzon.Anchiano.service;
import boukevanzon.Anchiano.model.User;
import boukevanzon.Anchiano.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public List<User> searchByEmail(String query) {
        return userRepository.findByEmailContainingIgnoreCase(query);
    }
}
