package lk.police.trafficfine.admin.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SummaryDto {
    private long totalFines;
    private long totalPaid;
    private BigDecimal totalAmountCollected;
}
