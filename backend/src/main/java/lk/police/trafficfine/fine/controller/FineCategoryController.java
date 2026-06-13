package lk.police.trafficfine.fine.controller;

import lk.police.trafficfine.common.ApiResponse;
import lk.police.trafficfine.fine.entity.FineCategory;
import lk.police.trafficfine.fine.service.FineCategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
public class FineCategoryController {

    private final FineCategoryService categoryService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<FineCategory>>> getAllCategories() {
        List<FineCategory> categories = categoryService.getAllCategories();
        return ResponseEntity.ok(ApiResponse.success("Categories retrieved successfully", categories));
    }
}
