package boukevanzon.Anchiano.mapper;

import boukevanzon.Anchiano.dto.MembershipDto;
import boukevanzon.Anchiano.model.Membership;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring", uses = { UserMapper.class })
public interface MembershipMapper {

    @Mapping(source = "workspace.id", target = "workspaceId")
    MembershipDto toDto(Membership membership);

    @Mapping(source = "workspaceId", target = "workspace.id")
    Membership toEntity(MembershipDto dto);
}
