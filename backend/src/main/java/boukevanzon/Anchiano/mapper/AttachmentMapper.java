package boukevanzon.Anchiano.mapper;

import boukevanzon.Anchiano.dto.AttachmentDto;
import boukevanzon.Anchiano.model.Attachment;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface AttachmentMapper {

    @Mapping(source = "task.id", target = "taskId")
    AttachmentDto toDto(Attachment attachment);

    @Mapping(source = "taskId", target = "task.id")
    Attachment toEntity(AttachmentDto dto);
}
