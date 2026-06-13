package lk.police.trafficfine.admin.service;

import lk.police.trafficfine.admin.dto.CategoryCollectionDto;
import lk.police.trafficfine.admin.dto.DistrictCollectionDto;
import lk.police.trafficfine.admin.dto.SummaryDto;
import lk.police.trafficfine.fine.entity.FineStatus;
import lk.police.trafficfine.fine.repository.FineRepository;
import lk.police.trafficfine.payment.repository.PaymentRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminAnalyticsService {

    private final FineRepository fineRepository;
    private final PaymentRepository paymentRepository;

    public SummaryDto getSummary() {
        long totalFines = fineRepository.count();
        long totalPaid = fineRepository.countByStatus(FineStatus.PAID);
        BigDecimal totalAmount = paymentRepository.sumTotalAmountCollected();

        return SummaryDto.builder()
                .totalFines(totalFines)
                .totalPaid(totalPaid)
                .totalAmountCollected(totalAmount != null ? totalAmount : BigDecimal.ZERO)
                .build();
    }

    public List<DistrictCollectionDto> getDistrictCollections() {
        return paymentRepository.sumByDistrict().stream()
                .map(row -> DistrictCollectionDto.builder()
                        .district((String) row[0])
                        .totalCollected((BigDecimal) row[1])
                        .build())
                .toList();
    }

    public List<CategoryCollectionDto> getCategoryCollections() {
        return paymentRepository.sumByCategory().stream()
                .map(row -> CategoryCollectionDto.builder()
                        .category((String) row[0])
                        .totalCollected((BigDecimal) row[1])
                        .build())
                .toList();
    }
}
