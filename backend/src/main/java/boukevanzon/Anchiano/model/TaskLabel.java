package boukevanzon.Anchiano.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "task_labels")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TaskLabel {
    @Id
    @ManyToOne
    @JoinColumn(name = "task_id")
    private Task task;

    @Id
    @ManyToOne
    @JoinColumn(name = "label_id")
    private Label label;
}

