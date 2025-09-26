package boukevanzon.Anchiano.service;

import boukevanzon.Anchiano.dto.JwtDto;
import boukevanzon.Anchiano.dto.LoginDto;
import boukevanzon.Anchiano.dto.RegisterDto;

public interface AuthService {
    JwtDto login(LoginDto dto);
    JwtDto register(RegisterDto dto);
}
