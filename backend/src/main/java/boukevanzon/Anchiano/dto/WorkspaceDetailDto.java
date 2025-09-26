// dto/WorkspaceDetailDto.java
package boukevanzon.Anchiano.dto;

import java.util.List;

public record WorkspaceDetailDto(
    Long id,
    String name,
    String description,
    UserDto owner,
    boolean isOwner,
    List<UserDto> members
) {}
