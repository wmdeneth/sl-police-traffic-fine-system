package lk.police.trafficfine.admin.controller;

import lk.police.trafficfine.admin.dto.CategoryCollectionDto;
import lk.police.trafficfine.admin.dto.DistrictCollectionDto;
import lk.police.trafficfine.admin.dto.SummaryDto;
import lk.police.trafficfine.admin.service.AdminAnalyticsService;
import lk.police.trafficfine.common.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
public class AdminController {

    private final AdminAnalyticsService analyticsService;

    @GetMapping("/summary")
    public ResponseEntity<ApiResponse<SummaryDto>> getSummary() {
        SummaryDto summary = analyticsService.getSummary();
        return ResponseEntity.ok(ApiResponse.success("Summary retrieved successfully", summary));
    }

    @GetMapping("/collections/district")
    public ResponseEntity<ApiResponse<List<DistrictCollectionDto>>> getDistrictCollections() {
        List<DistrictCollectionDto> data = analyticsService.getDistrictCollections();
        return ResponseEntity.ok(ApiResponse.success("District collections retrieved successfully", data));
    }

    @GetMapping("/collections/category")
    public ResponseEntity<ApiResponse<List<CategoryCollectionDto>>> getCategoryCollections() {
        List<CategoryCollectionDto> data = analyticsService.getCategoryCollections();
        return ResponseEntity.ok(ApiResponse.success("Category collections retrieved successfully", data));
    }
}
