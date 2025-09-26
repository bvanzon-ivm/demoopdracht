package boukevanzon.Anchiano.dto;

import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WorkspaceDetailDto {
    private Long id;
    private String name;
    private List<UserDto> members;
}
