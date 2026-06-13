package lk.police.trafficfine.fine.controller;

import jakarta.validation.Valid;
import lk.police.trafficfine.common.ApiResponse;
import lk.police.trafficfine.fine.dto.FineDetailsDto;
import lk.police.trafficfine.fine.dto.FineRequest;
import lk.police.trafficfine.fine.dto.FineResponse;
import lk.police.trafficfine.fine.service.FineService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/fines")
@RequiredArgsConstructor
public class FineController {

    private final FineService fineService;

    @PostMapping
    public ResponseEntity<ApiResponse<FineResponse>> issueFine(
            @Valid @RequestBody FineRequest request,
            @AuthenticationPrincipal UserDetails userDetails
    ) {
        FineResponse response = fineService.issueFine(request, userDetails.getUsername());
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Fine issued successfully", response));
    }

    @GetMapping("/{referenceNo}")
    public ResponseEntity<ApiResponse<FineDetailsDto>> lookupFine(@PathVariable String referenceNo) {
        FineDetailsDto details = fineService.lookupByReference(referenceNo);
        return ResponseEntity.ok(ApiResponse.success("Fine retrieved successfully", details));
    }
}
