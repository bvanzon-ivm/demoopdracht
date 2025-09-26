package boukevanzon.Anchiano.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.Instant;

@Entity @Table(name = "task_versions")
@Data
public class TaskVersion {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @ManyToOne(optional = false) @JoinColumn(name = "task_id") private Task task;
    @Column(nullable=false) private String fieldName;
    @Column(columnDefinition="TEXT") private String oldValue;
    @Column(columnDefinition="TEXT") private String newValue;
    @Column(nullable=false) private Instant createdAt = Instant.now();
}
