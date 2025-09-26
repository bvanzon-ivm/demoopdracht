package boukevanzon.Anchiano.mapper;

import boukevanzon.Anchiano.dto.TaskDto;
import boukevanzon.Anchiano.model.Task;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring", uses = { UserMapper.class, LabelMapper.class })
public interface TaskMapper {

    @Mapping(source = "workspace.id", target = "workspaceId")
    @Mapping(source = "createdBy", target = "createdBy")
    TaskDto toDto(Task task);

    @Mapping(source = "workspaceId", target = "workspace.id")
    Task toEntity(TaskDto dto);
}
