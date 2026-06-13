package lk.police.trafficfine.payment.controller;

import jakarta.validation.Valid;
import lk.police.trafficfine.common.ApiResponse;
import lk.police.trafficfine.payment.dto.PaymentReceiptDto;
import lk.police.trafficfine.payment.dto.PaymentRequest;
import lk.police.trafficfine.payment.service.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService paymentService;

    @PostMapping
    public ResponseEntity<ApiResponse<PaymentReceiptDto>> processPayment(
            @Valid @RequestBody PaymentRequest request
    ) {
        PaymentReceiptDto receipt = paymentService.processPayment(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Payment processed successfully", receipt));
    }
}
