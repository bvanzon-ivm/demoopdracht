package boukevanzon.Anchiano.mapper;

import boukevanzon.Anchiano.dto.UserDto;
import boukevanzon.Anchiano.model.User;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserMapper {
    UserDto toDto(User user);
    User toEntity(UserDto dto);
}
