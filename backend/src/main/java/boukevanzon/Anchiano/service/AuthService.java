package boukevanzon.Anchiano.service;

import boukevanzon.Anchiano.dto.LoginRequest;
import boukevanzon.Anchiano.dto.RegisterRequest;
import boukevanzon.Anchiano.dto.JwtResponse;
import boukevanzon.Anchiano.model.User;
import boukevanzon.Anchiano.repository.UserRepository;
import boukevanzon.Anchiano.security.JwtTokenProvider;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.Instant;

@Service
public class AuthService {

    private final AuthenticationManager authenticationManager;
    private final JwtTokenProvider jwtTokenProvider;
    private final PasswordEncoder passwordEncoder;
    private final UserRepository userRepository;

    public AuthService(AuthenticationManager authenticationManager,
                       JwtTokenProvider jwtTokenProvider,
                       PasswordEncoder passwordEncoder,
                       UserRepository userRepository) {
        this.authenticationManager = authenticationManager;
        this.jwtTokenProvider = jwtTokenProvider;
        this.passwordEncoder = passwordEncoder;
        this.userRepository = userRepository;
    }

public JwtResponse login(LoginRequest request) {
    Authentication authentication = authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(
                    request.getEmail(),
                    request.getPassword()
            )
    );

    String token = jwtTokenProvider.generateToken(authentication.getName());
    User user = userRepository.findByEmail(request.getEmail())
            .orElseThrow(() -> new RuntimeException("User not found"));

    return new JwtResponse(token, user);
}

public JwtResponse register(RegisterRequest request) {
    if (userRepository.existsByEmail(request.getEmail())) {
        throw new RuntimeException("Email is already in use: " + request.getEmail());
    }

    User user = new User();
    user.setEmail(request.getEmail());
    user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
    user.setName(request.getName());
    user.setCreatedAt(Instant.now());

    User saved = userRepository.save(user);

    // meteen token genereren
    String token = jwtTokenProvider.generateToken(saved.getEmail());
    return new JwtResponse(token, saved);
}

}
