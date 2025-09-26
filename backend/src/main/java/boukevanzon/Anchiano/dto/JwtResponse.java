package boukevanzon.Anchiano.dto;

import boukevanzon.Anchiano.model.User;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class JwtResponse {
    private String token;
    private String type = "Bearer";
    private User user;

    public JwtResponse(String token, User user) {
        this.token = token;
        this.user = user;
    }

}
