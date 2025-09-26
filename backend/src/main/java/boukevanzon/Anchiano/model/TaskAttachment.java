package boukevanzon.Anchiano.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.Instant;

@Entity @Table(name = "task_attachments")
@Data
public class TaskAttachment {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @ManyToOne(optional = false) @JoinColumn(name="task_id") private Task task;
    @Column(nullable=false) private String filename;
    @Column(nullable=false) private String contentType;
    @Column(nullable=false) private long size;
    @Column(nullable=false) private String path;
    @Column(nullable=false) private Instant uploadedAt = Instant.now();
}
