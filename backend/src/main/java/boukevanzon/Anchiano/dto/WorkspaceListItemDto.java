// dto/WorkspaceListItemDto.java
package boukevanzon.Anchiano.dto;

public record WorkspaceListItemDto(
    Long id,
    String name,
    String description,
    UserDto owner,
    boolean isOwner,
    int memberCount
) {}
