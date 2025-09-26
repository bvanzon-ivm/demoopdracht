package boukevanzon.Anchiano.mapper;

import boukevanzon.Anchiano.dto.AuditDto;
import boukevanzon.Anchiano.model.Audit;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface AuditMapper {

    @Mapping(source = "workspace.id", target = "workspaceId")
    @Mapping(source = "user.id", target = "userId")
    AuditDto toDto(Audit audit);

    @Mapping(source = "workspaceId", target = "workspace.id")
    @Mapping(source = "userId", target = "user.id")
    Audit toEntity(AuditDto dto);
}
