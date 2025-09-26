package boukevanzon.Anchiano.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class LoginDto {
    @Email
    @NotBlank
    private String email;

    @NotBlank
    private String password;
}
