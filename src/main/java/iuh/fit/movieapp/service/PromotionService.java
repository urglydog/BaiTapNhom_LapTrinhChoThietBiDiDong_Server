package iuh.fit.movieapp.service;

import iuh.fit.movieapp.dto.response.AppException;
import iuh.fit.movieapp.dto.response.ErrorCode;
import iuh.fit.movieapp.model.Promotion;
import iuh.fit.movieapp.repository.PromotionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
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
        return promotionRepo.findByCode(code)
                .orElseThrow(() -> new AppException(ErrorCode.PROMOTION_NOT_FOUND));
    }

    public Promotion validateAndGetPromotion(String code, BigDecimal totalAmount) {
        Promotion promotion = findByCode(code);

        // Kiểm tra promotion có active không
        if (!promotion.getActive()) {
            throw new AppException(ErrorCode.PROMOTION_NOT_AVAILABLE);
        }

        // Kiểm tra thời gian hiệu lực
        LocalDateTime now = LocalDateTime.now();
        if (now.isBefore(promotion.getStartDate()) || now.isAfter(promotion.getEndDate())) {
            throw new AppException(ErrorCode.PROMOTION_EXPIRED);
        }

        // Kiểm tra số lần sử dụng
        if (promotion.getUsageLimit() != null &&
                promotion.getUsedCount() >= promotion.getUsageLimit()) {
            throw new AppException(ErrorCode.PROMOTION_LIMIT_REACHED);
        }

        // Kiểm tra số tiền tối thiểu
        if (totalAmount.compareTo(promotion.getMinAmount()) < 0) {
            throw new AppException(ErrorCode.PROMOTION_MIN_AMOUNT_NOT_MET);
        }

        return promotion;
    }

    public BigDecimal calculateDiscount(Promotion promotion, BigDecimal totalAmount) {
        BigDecimal discount = BigDecimal.ZERO;

        if (promotion.getDiscountType() == Promotion.DiscountType.PERCENTAGE) {
            // Tính theo phần trăm
            discount = totalAmount.multiply(promotion.getDiscountValue())
                    .divide(BigDecimal.valueOf(100), 2, java.math.RoundingMode.HALF_UP);

            // Áp dụng giới hạn tối đa nếu có
            if (promotion.getMaxDiscount() != null && discount.compareTo(promotion.getMaxDiscount()) > 0) {
                discount = promotion.getMaxDiscount();
            }
        } else if (promotion.getDiscountType() == Promotion.DiscountType.FIXED_AMOUNT) {
            // Giảm giá cố định
            discount = promotion.getDiscountValue();

            // Không được vượt quá tổng tiền
            if (discount.compareTo(totalAmount) > 0) {
                discount = totalAmount;
            }
        }

        return discount;
    }

    @Transactional
    public void incrementUsedCount(Promotion promotion) {
        promotion.setUsedCount(promotion.getUsedCount() + 1);
        promotionRepo.save(promotion);
    }

    public Promotion createPromotion(Promotion promotion) {
        // Kiểm tra duplicate theo code
        if (promotion.getCode() != null && !promotion.getCode().trim().isEmpty()) {
            Optional<Promotion> existingPromotion = promotionRepo.findByCode(promotion.getCode());
            if (existingPromotion.isPresent()) {
                throw new AppException(ErrorCode.PROMOTION_EXISTED);
            }
        }
        return promotionRepo.save(promotion);
    }

    public Promotion updatePromotion(Promotion promotion) {
        Promotion existedPromotion = findById(promotion.getId());
        
        // Kiểm tra duplicate code nếu code thay đổi
        if (promotion.getCode() != null && !promotion.getCode().trim().isEmpty()) {
            if (!promotion.getCode().equals(existedPromotion.getCode())) {
                Optional<Promotion> existingPromotionWithCode = promotionRepo.findByCode(promotion.getCode());
                if (existingPromotionWithCode.isPresent() && existingPromotionWithCode.get().getId() != promotion.getId()) {
                    throw new AppException(ErrorCode.PROMOTION_EXISTED);
                }
            }
        }
        
        existedPromotion.setCode(promotion.getCode());
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
