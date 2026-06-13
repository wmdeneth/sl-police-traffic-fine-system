package lk.police.trafficfine.payment.service;

import lk.police.trafficfine.common.BadRequestException;
import lk.police.trafficfine.fine.entity.Fine;
import lk.police.trafficfine.fine.entity.FineCategory;
import lk.police.trafficfine.fine.entity.FineStatus;
import lk.police.trafficfine.fine.repository.FineCategoryRepository;
import lk.police.trafficfine.fine.service.FineService;
import lk.police.trafficfine.payment.dto.PaymentReceiptDto;
import lk.police.trafficfine.payment.dto.PaymentRequest;
import lk.police.trafficfine.payment.entity.Payment;
import lk.police.trafficfine.payment.repository.PaymentRepository;
import lk.police.trafficfine.user.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final FineService fineService;
    private final FineCategoryRepository categoryRepository;
    private final SmsService smsService;

    @Transactional
    public PaymentReceiptDto processPayment(PaymentRequest request) {
        Fine fine = fineService.getFineByReference(request.getReferenceNo());

        if (!fine.getCategory().getId().equals(request.getCategoryId())) {
            throw new BadRequestException("Category ID does not match the fine");
        }

        if (fine.getStatus() == FineStatus.PAID) {
            throw new BadRequestException("Fine is already paid");
        }

        FineCategory category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new BadRequestException("Invalid category"));

        fineService.markAsPaid(fine);

        String transactionRef = "TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();

        Payment payment = Payment.builder()
                .fine(fine)
                .amountPaid(category.getAmount())
                .paymentMethod(request.getPaymentMethod())
                .channel(request.getChannel())
                .transactionRef(transactionRef)
                .build();

        payment = paymentRepository.save(payment);

        User officer = fine.getOfficer();
        if (officer.getPhone() != null && !officer.getPhone().isBlank()) {
            String message = String.format(
                    "Traffic fine %s paid. Driver: %s. Vehicle: %s. You may release the driver's license.",
                    fine.getReferenceNo(),
                    fine.getDriverName(),
                    fine.getVehicleNo()
            );
            smsService.send(officer.getPhone(), message);
        }

        return PaymentReceiptDto.builder()
                .referenceNo(fine.getReferenceNo())
                .amountPaid(payment.getAmountPaid())
                .paymentMethod(payment.getPaymentMethod())
                .channel(payment.getChannel())
                .transactionRef(payment.getTransactionRef())
                .paidAt(payment.getPaidAt())
                .driverName(fine.getDriverName())
                .vehicleNo(fine.getVehicleNo())
                .build();
    }
}
