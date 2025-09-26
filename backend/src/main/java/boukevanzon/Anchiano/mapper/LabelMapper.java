package boukevanzon.Anchiano.mapper;

import boukevanzon.Anchiano.dto.LabelDto;
import boukevanzon.Anchiano.model.Label;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface LabelMapper {

    @Mapping(source = "workspace.id", target = "workspaceId")
    LabelDto toDto(Label label);

    @Mapping(source = "workspaceId", target = "workspace.id")
    Label toEntity(LabelDto dto);
}
