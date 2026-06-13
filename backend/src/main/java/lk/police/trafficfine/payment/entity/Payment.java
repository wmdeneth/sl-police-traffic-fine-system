package lk.police.trafficfine.payment.entity;

import jakarta.persistence.*;
import lk.police.trafficfine.fine.entity.Fine;
import lombok.*;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "payments")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "fine_id", nullable = false, unique = true)
    private Fine fine;

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal amountPaid;

    @Column(nullable = false)
    private String paymentMethod;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PaymentChannel channel;

    @Column(nullable = false)
    private Instant paidAt;

    @Column(nullable = false, unique = true)
    private String transactionRef;

    @PrePersist
    protected void onCreate() {
        if (paidAt == null) {
            paidAt = Instant.now();
        }
    }
}
