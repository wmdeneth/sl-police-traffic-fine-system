package lk.police.trafficfine.fine.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.util.UUID;

@Data
public class FineRequest {

    @NotNull(message = "Category ID is required")
    private UUID categoryId;

    @NotBlank(message = "Driver name is required")
    private String driverName;

    @NotBlank(message = "Vehicle number is required")
    private String vehicleNo;

    @NotBlank(message = "District is required")
    private String district;
}
