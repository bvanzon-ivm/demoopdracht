package boukevanzon.Anchiano.service;

import boukevanzon.Anchiano.dto.LabelDto;
import org.springframework.security.core.Authentication;

import java.util.List;

public interface LabelService {
    List<LabelDto> getLabels(Authentication auth, Long workspaceId);
    LabelDto createLabel(Authentication auth, Long workspaceId, LabelDto dto);
    void deleteLabel(Authentication auth, Long workspaceId, Long labelId);
}
