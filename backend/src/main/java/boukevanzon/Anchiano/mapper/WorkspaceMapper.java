package boukevanzon.Anchiano.mapper;

import boukevanzon.Anchiano.dto.WorkspaceDto;
import boukevanzon.Anchiano.model.Workspace;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring", uses = { UserMapper.class })
public interface WorkspaceMapper {

    @Mapping(source = "owner", target = "owner")
    WorkspaceDto toDto(Workspace workspace);

    @Mapping(source = "owner", target = "owner")
    Workspace toEntity(WorkspaceDto dto);
}
