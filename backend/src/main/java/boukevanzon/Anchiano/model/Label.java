package boukevanzon.Anchiano.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "labels", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"workspace_id", "name"})
})
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Label {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "workspace_id")
    private Workspace workspace;

    @Column(nullable = false, length = 50)
    private String name;

    @Column(nullable = false, length = 7)
    private String color; // #RRGGBB
}

