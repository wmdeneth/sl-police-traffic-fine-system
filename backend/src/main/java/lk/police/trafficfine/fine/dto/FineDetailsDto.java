package lk.police.trafficfine.fine.dto;

import lk.police.trafficfine.fine.entity.FineStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FineDetailsDto {
    private UUID id;
    private String referenceNo;
    private UUID categoryId;
    private String categoryCode;
    private String categoryDescription;
    private BigDecimal amount;
    private String driverName;
    private String vehicleNo;
    private String district;
    private FineStatus status;
    private Instant issuedAt;
}
