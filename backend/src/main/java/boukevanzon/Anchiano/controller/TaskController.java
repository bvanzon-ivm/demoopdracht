package boukevanzon.Anchiano.controller;

import boukevanzon.Anchiano.dto.TaskRequest;
import boukevanzon.Anchiano.enums.TaskStatus;
import boukevanzon.Anchiano.model.*;
import boukevanzon.Anchiano.repository.*;
import jakarta.validation.Valid;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.*;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.LocalDateTime;
import java.util.*;

@RestController
@RequestMapping("/api/workspaces/{workspaceId}/tasks")
public class TaskController {

    private final TaskRepository tasks;
    private final WorkspaceRepository workspaces;
    private final WorkspaceMembershipRepository memberships;
    private final TaskVersionRepository versions;
    private final TaskAttachmentRepository attachments;
    private final UserRepository users;

    public TaskController(TaskRepository tasks,
            WorkspaceRepository workspaces,
            WorkspaceMembershipRepository memberships,
            TaskVersionRepository versions,
            TaskAttachmentRepository attachments,
            UserRepository users) {
        this.tasks = tasks;
        this.workspaces = workspaces;
        this.memberships = memberships;
        this.versions = versions;
        this.attachments = attachments;
        this.users = users;
    }

    private User me(Authentication auth) {
        return users.findByEmail(auth.getName())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED));
    }

    private Workspace workspaceOr404(Long id) {
        return workspaces.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Workspace not found"));
    }

    private void checkMember(Workspace ws, User me) {
        if (!memberships.existsByWorkspace_IdAndUser_Id(ws.getId(), me.getId()) &&
                !Objects.equals(ws.getOwner().getId(), me.getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Not a member of workspace");
        }
    }

    @GetMapping
    public List<Task> list(@PathVariable Long workspaceId, Authentication auth) {
        var ws = workspaceOr404(workspaceId);
        checkMember(ws, me(auth));
        return tasks.findByWorkspace_IdAndDeletedAtIsNull(workspaceId);
    }

    @PostMapping
    public Task create(@PathVariable Long workspaceId,
            @Valid @RequestBody TaskRequest req,
            Authentication auth) {
        var ws = workspaceOr404(workspaceId);
        var user = me(auth);
        checkMember(ws, user);

        var t = new Task();
        t.setWorkspace(ws);
        t.setTitle(req.getTitle());
        t.setDescription(req.getDescription());
        t.setPriority(req.getPriority());
        t.setStatus(req.getStatus());
        t.setDueDate(req.getDueDate());
        t.setLabels(Optional.ofNullable(req.getLabels()).orElse(List.of()));

        if (req.getAssigneeIds() != null && !req.getAssigneeIds().isEmpty()) {
            var usersFound = new HashSet<User>(users.findAllById(req.getAssigneeIds()));
            t.setAssignees(usersFound);
        }
        t.setCreatedBy(user);
        t.setCreatedAt(LocalDateTime.now());
        t.setUpdatedAt(LocalDateTime.now());
        return tasks.save(t);
    }

    @GetMapping("{id}")
    public Task get(@PathVariable Long workspaceId, @PathVariable Long id, Authentication auth) {
        var ws = workspaceOr404(workspaceId);
        checkMember(ws, me(auth));
        return tasks.findByIdAndWorkspace_IdAndDeletedAtIsNull(id, workspaceId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
    }

    @PatchMapping("{id}")
    public Task update(@PathVariable Long workspaceId, @PathVariable Long id,
            @RequestBody Map<String, Object> patch, Authentication auth) {
        var ws = workspaceOr404(workspaceId);
        var user = me(auth);
        checkMember(ws, user);

        var t = tasks.findByIdAndWorkspace_IdAndDeletedAtIsNull(id, workspaceId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        // audit per veld
        patch.forEach((k, v) -> {
            var oldVal = switch (k) {
                case "title" -> t.getTitle();
                case "description" -> t.getDescription();
                case "status" -> t.getStatus() != null ? t.getStatus().name() : null;
                default -> null;
            };
            if (Objects.equals(k, "title"))
                t.setTitle((String) v);
            if (Objects.equals(k, "description"))
                t.setDescription((String) v);
            if (Objects.equals(k, "status"))
                t.setStatus(TaskStatus.valueOf(v.toString()));
            // evt. andere velden idem

            var tv = new TaskVersion();
            tv.setTask(t);
            tv.setFieldName(k);
            tv.setOldValue(Objects.toString(oldVal, null));
            tv.setNewValue(Objects.toString(v, null));
            versions.save(tv);
        });
        t.setUpdatedAt(LocalDateTime.now());
        return tasks.save(t);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<Void> delete(@PathVariable Long workspaceId, @PathVariable Long id, Authentication auth) {
        var ws = workspaceOr404(workspaceId);
        checkMember(ws, me(auth));
        var t = tasks.findByIdAndWorkspace_IdAndDeletedAtIsNull(id, workspaceId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        t.setDeletedAt(LocalDateTime.now());
        tasks.save(t);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("{id}/audit")
    public List<TaskVersion> audit(@PathVariable Long workspaceId, @PathVariable Long id, Authentication auth) {
        var ws = workspaceOr404(workspaceId);
        checkMember(ws, me(auth));
        return versions.findByTask_IdOrderByIdDesc(id);
    }

    @PostMapping("{id}/rollback")
    public ResponseEntity<Void> rollback(@PathVariable Long workspaceId, @PathVariable Long id,
            @RequestBody Map<String, String> body, Authentication auth) {
        var ws = workspaceOr404(workspaceId);
        checkMember(ws, me(auth));
        var field = body.get("field");
        var versionId = Long.parseLong(body.get("versionId"));
        var v = versions.findById(versionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        var t = tasks.findByIdAndWorkspace_IdAndDeletedAtIsNull(id, workspaceId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

        if (!Objects.equals(v.getTask().getId(), t.getId())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Version does not belong to task");
        }

        if ("title".equals(field))
            t.setTitle(v.getOldValue());
        if ("description".equals(field))
            t.setDescription(v.getOldValue());
        if ("status".equals(field))
            t.setStatus(TaskStatus.valueOf(v.getOldValue()));
        t.setUpdatedAt(LocalDateTime.now());
        tasks.save(t);
        return ResponseEntity.noContent().build();
    }

    // --- Attachments ---
    private Path baseDir(Long wsId, Long taskId) {
        return Path.of("data", "attachments", String.valueOf(wsId), String.valueOf(taskId));
    }

    @PostMapping(value = "{id}/attachments", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Void> upload(@PathVariable Long workspaceId, @PathVariable Long id,
            @RequestPart("file") MultipartFile file, Authentication auth) throws Exception {
        var ws = workspaceOr404(workspaceId);
        checkMember(ws, me(auth));
        var t = tasks.findByIdAndWorkspace_IdAndDeletedAtIsNull(id, workspaceId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));

        Files.createDirectories(baseDir(workspaceId, id));
        var target = baseDir(workspaceId, id).resolve(file.getOriginalFilename());
        file.transferTo(target);

        var att = new TaskAttachment();
        att.setTask(t);
        att.setFilename(file.getOriginalFilename());
        att.setContentType(file.getContentType() != null ? file.getContentType() : "application/octet-stream");
        att.setSize(file.getSize());
        att.setPath(target.toString());
        attachments.save(att);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @GetMapping("{id}/attachments")
    public List<TaskAttachment> listAttachments(@PathVariable Long workspaceId, @PathVariable Long id,
            Authentication auth) {
        var ws = workspaceOr404(workspaceId);
        checkMember(ws, me(auth));
        return attachments.findByTask_Id(id);
    }

    @GetMapping("{id}/attachments/{attachmentId}")
    public ResponseEntity<FileSystemResource> download(@PathVariable Long workspaceId,
            @PathVariable Long id,
            @PathVariable Long attachmentId,
            Authentication auth) {
        var ws = workspaceOr404(workspaceId);
        checkMember(ws, me(auth));
        var att = attachments.findById(attachmentId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND));
        var file = new File(att.getPath());
        if (!file.exists())
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        var res = new FileSystemResource(file);
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(att.getContentType()))
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"%s\"".formatted(att.getFilename()))
                .body(res);
    }
}
