package lk.police.trafficfine.fine.entity;

import jakarta.persistence.*;
import lk.police.trafficfine.user.entity.User;
import lombok.*;

import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "fines")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Fine {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, unique = true)
    private String referenceNo;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "category_id", nullable = false)
    private FineCategory category;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "officer_id", nullable = false)
    private User officer;

    @Column(nullable = false)
    private String driverName;

    @Column(nullable = false)
    private String vehicleNo;

    @Column(nullable = false)
    private String district;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private FineStatus status;

    @Column(nullable = false, updatable = false)
    private Instant issuedAt;

    @PrePersist
    protected void onCreate() {
        if (issuedAt == null) {
            issuedAt = Instant.now();
        }
        if (status == null) {
            status = FineStatus.PENDING;
        }
    }
}
