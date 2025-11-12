package iuh.fit.movieapp.controller;

import iuh.fit.movieapp.dto.response.ApiResponse;
import iuh.fit.movieapp.dto.response.SuccessCode;
import iuh.fit.movieapp.model.Promotion;
import iuh.fit.movieapp.service.PromotionService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/promotions")
@RequiredArgsConstructor
public class PromotionController {

    private final PromotionService promotionService;

    @GetMapping
    public ApiResponse<List<Promotion>> getAllPromotions() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, promotionService.findAll());
    }

    @GetMapping("/active")
    public ApiResponse<List<Promotion>> getActivePromotions() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, promotionService.findActivePromotions());
    }

    @GetMapping("/available")
    public ApiResponse<List<Promotion>> getAvailablePromotions() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, promotionService.findAvailablePromotions());
    }

    @GetMapping("/{id}")
    public ApiResponse<Promotion> getPromotion(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, promotionService.findById(id));
    }

    @GetMapping("/code/{code}")
    public ApiResponse<Promotion> getPromotionByCode(@PathVariable String code) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, promotionService.findByCode(code));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    public ApiResponse<Promotion> createPromotion(@RequestBody Promotion promotion) {
        Promotion createdPromotion = promotionService.createPromotion(promotion);
        return new ApiResponse<>(SuccessCode.PROMOTION_CREATED, createdPromotion);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    public ApiResponse<Promotion> updatePromotion(@PathVariable int id, @RequestBody Promotion promotion) {
        promotion.setId(id);
        Promotion updatedPromotion = promotionService.updatePromotion(promotion);
        return new ApiResponse<>(SuccessCode.PROMOTION_UPDATED, updatedPromotion);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<Void> deletePromotion(@PathVariable int id) {
        promotionService.deletePromotion(id);
        return new ApiResponse<>(SuccessCode.PROMOTION_DELETED, null);
    }
}
