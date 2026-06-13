package lk.police.trafficfine.payment.dto;

import lk.police.trafficfine.payment.entity.PaymentChannel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PaymentReceiptDto {
    private String referenceNo;
    private BigDecimal amountPaid;
    private String paymentMethod;
    private PaymentChannel channel;
    private String transactionRef;
    private Instant paidAt;
    private String driverName;
    private String vehicleNo;
}
