package boukevanzon.Anchiano.service.impl;

import boukevanzon.Anchiano.dto.LabelDto;
import boukevanzon.Anchiano.mapper.LabelMapper;
import boukevanzon.Anchiano.model.Label;
import boukevanzon.Anchiano.model.Workspace;
import boukevanzon.Anchiano.repository.LabelRepository;
import boukevanzon.Anchiano.repository.WorkspaceRepository;
import boukevanzon.Anchiano.service.LabelService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LabelServiceImpl implements LabelService {

    private final LabelRepository labelRepo;
    private final WorkspaceRepository wsRepo;
    private final LabelMapper mapper;

    public LabelServiceImpl(LabelRepository labelRepo, WorkspaceRepository wsRepo, LabelMapper mapper) {
        this.labelRepo = labelRepo;
        this.wsRepo = wsRepo;
        this.mapper = mapper;
    }

    @Override
    public List<LabelDto> getLabels(Authentication auth, Long workspaceId) {
        Workspace ws = wsRepo.findById(workspaceId).orElseThrow();
        return labelRepo.findByWorkspaceAndActiveTrue(ws).stream().map(mapper::toDto).toList();
    }

    @Override
    public LabelDto createLabel(Authentication auth, Long workspaceId, LabelDto dto) {
        Workspace ws = wsRepo.findById(workspaceId).orElseThrow();
        Label label = mapper.toEntity(dto);
        label.setWorkspace(ws);
        labelRepo.save(label);
        return mapper.toDto(label);
    }

    @Override
    public void deleteLabel(Authentication auth, Long workspaceId, Long labelId) {
        labelRepo.deleteById(labelId);
    }
}
