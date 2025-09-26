package boukevanzon.Anchiano.service.impl;

import boukevanzon.Anchiano.dto.JwtDto;
import boukevanzon.Anchiano.dto.LoginDto;
import boukevanzon.Anchiano.dto.RegisterDto;
import boukevanzon.Anchiano.mapper.UserMapper;
import boukevanzon.Anchiano.model.User;
import boukevanzon.Anchiano.repository.UserRepository;
import boukevanzon.Anchiano.security.JwtTokenProvider;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthServiceImpl implements boukevanzon.Anchiano.service.AuthService {

    private final AuthenticationManager authManager;
    private final UserRepository userRepo;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtProvider;
    private final UserMapper userMapper;

    public AuthServiceImpl(AuthenticationManager authManager, UserRepository userRepo,
                           PasswordEncoder passwordEncoder, JwtTokenProvider jwtProvider, UserMapper userMapper) {
        this.authManager = authManager;
        this.userRepo = userRepo;
        this.passwordEncoder = passwordEncoder;
        this.jwtProvider = jwtProvider;
        this.userMapper = userMapper;
    }

    @Override
    public JwtDto login(LoginDto dto) {
        authManager.authenticate(new UsernamePasswordAuthenticationToken(dto.getEmail(), dto.getPassword()));
        User user = userRepo.findByEmailIgnoreCase(dto.getEmail()).orElseThrow();
        String token = jwtProvider.generateToken(user.getEmail());
        return JwtDto.builder().token(token).user(userMapper.toDto(user)).build();
    }

    @Override
    public JwtDto register(RegisterDto dto) {
        if (userRepo.existsByEmailIgnoreCase(dto.getEmail())) {
            throw new RuntimeException("Email already in use");
        }
        User user = User.builder()
                .name(dto.getName())
                .email(dto.getEmail().toLowerCase())
                .passwordHash(passwordEncoder.encode(dto.getPassword()))
                .build();
        userRepo.save(user);
        String token = jwtProvider.generateToken(user.getEmail());
        return JwtDto.builder().token(token).user(userMapper.toDto(user)).build();
    }
}
