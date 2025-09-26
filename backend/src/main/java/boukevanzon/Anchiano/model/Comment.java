package boukevanzon.Anchiano.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.Instant;

@Entity
@Table(name = "comments")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Comment {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "task_id")
    private Task task;

    @ManyToOne(optional = false)
    @JoinColumn(name = "author_id")
    private User author;

    @ManyToOne
    @JoinColumn(name = "parent_comment_id")
    private Comment parentComment;

    @Lob
    @Column(nullable = false)
    private String body;

    @Column(nullable = false)
    private Instant createdAt = Instant.now();

     @Column(nullable = false)
    private Instant editedAt = Instant.now();

    @ManyToOne
    @JoinColumn(name = "edited_by")
    private User editedBy;
}
