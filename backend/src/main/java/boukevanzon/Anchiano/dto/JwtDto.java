package boukevanzon.Anchiano.dto;

import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class JwtDto {
    private String token;
    private UserDto user;
}
