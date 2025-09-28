package boukevanzon.Anchiano.controller;

import boukevanzon.Anchiano.dto.TaskDto;
import boukevanzon.Anchiano.service.TaskService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import boukevanzon.Anchiano.dto.UserDto;
import boukevanzon.Anchiano.service.UserService;
import lombok.RequiredArgsConstructor;

import java.util.List;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/search")
    public List<UserDto> search(@RequestParam("email") String email) {
        return userService.searchByEmail(email).stream()
                .map(UserDto::fromEntity)
                .toList();
    }
}
