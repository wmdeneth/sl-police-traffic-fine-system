package lk.police.trafficfine.payment.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lk.police.trafficfine.payment.entity.PaymentChannel;
import lombok.Data;

import java.util.UUID;

@Data
public class PaymentRequest {

    @NotBlank(message = "Reference number is required")
    private String referenceNo;

    @NotNull(message = "Category ID is required")
    private UUID categoryId;

    @NotBlank(message = "Payment method is required")
    private String paymentMethod;

    @NotNull(message = "Payment channel is required")
    private PaymentChannel channel;

    private String cardHolderName;
}
