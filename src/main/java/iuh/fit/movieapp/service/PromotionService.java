package iuh.fit.movieapp.service;

import iuh.fit.movieapp.dto.response.AppException;
import iuh.fit.movieapp.dto.response.ErrorCode;
import iuh.fit.movieapp.model.Promotion;
import iuh.fit.movieapp.repository.PromotionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class PromotionService {
    private final PromotionRepository promotionRepo;

    public List<Promotion> findAll() {
        return promotionRepo.findAll();
    }

    public List<Promotion> findActivePromotions() {
        return promotionRepo.findActivePromotions(LocalDateTime.now());
    }

    public List<Promotion> findAvailablePromotions() {
        return promotionRepo.findAvailablePromotions(LocalDateTime.now());
    }

    public Promotion findById(int id) {
        return promotionRepo.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.PROMOTION_NOT_FOUND));
    }

    public Promotion findByCode(String code) {
        // Tìm promotion theo code (nếu có field code trong model)
        // Nếu không có, có thể tìm theo name hoặc tạo field code
        return promotionRepo.findAll().stream()
                .filter(p -> p.getName().equalsIgnoreCase(code) || 
                            (p.getDescription() != null && p.getDescription().contains(code)))
                .findFirst()
                .orElseThrow(() -> new AppException(ErrorCode.PROMOTION_NOT_FOUND));
    }

    public Promotion createPromotion(Promotion promotion) {
        return promotionRepo.save(promotion);
    }

    public Promotion updatePromotion(Promotion promotion) {
        Promotion existedPromotion = findById(promotion.getId());
        existedPromotion.setName(promotion.getName());
        existedPromotion.setDescription(promotion.getDescription());
        existedPromotion.setDiscountType(promotion.getDiscountType());
        existedPromotion.setDiscountValue(promotion.getDiscountValue());
        existedPromotion.setMinAmount(promotion.getMinAmount());
        existedPromotion.setMaxDiscount(promotion.getMaxDiscount());
        existedPromotion.setStartDate(promotion.getStartDate());
        existedPromotion.setEndDate(promotion.getEndDate());
        existedPromotion.setUsageLimit(promotion.getUsageLimit());
        existedPromotion.setActive(promotion.getActive());
        return promotionRepo.save(existedPromotion);
    }

    public void deletePromotion(int id) {
        Promotion promotion = findById(id);
        promotion.setActive(false);
        promotionRepo.save(promotion);
    }
}

