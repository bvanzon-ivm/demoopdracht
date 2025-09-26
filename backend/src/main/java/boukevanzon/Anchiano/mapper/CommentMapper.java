package boukevanzon.Anchiano.mapper;

import boukevanzon.Anchiano.dto.CommentDto;
import boukevanzon.Anchiano.model.Comment;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface CommentMapper {

    @Mapping(source = "task.id", target = "taskId")
    @Mapping(source = "author.id", target = "authorId")
    @Mapping(source = "parentComment.id", target = "parentCommentId")
    @Mapping(source = "editedBy.id", target = "editedById")
    CommentDto toDto(Comment comment);

    @Mapping(source = "taskId", target = "task.id")
    @Mapping(source = "authorId", target = "author.id")
    @Mapping(source = "parentCommentId", target = "parentComment.id")
    @Mapping(source = "editedById", target = "editedBy.id")
    Comment toEntity(CommentDto dto);
}
