package iuh.fit.xstore.repository;

import iuh.fit.xstore.model.Promotion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface PromotionRepository extends JpaRepository<Promotion, Integer> {
    List<Promotion> findByIsActiveTrue();

    @Query("SELECT p FROM Promotion p WHERE p.isActive = true AND p.startDate <= :currentDate AND p.endDate >= :currentDate")
    List<Promotion> findActivePromotions(@Param("currentDate") LocalDateTime currentDate);

    @Query("SELECT p FROM Promotion p WHERE p.isActive = true AND p.startDate <= :currentDate AND p.endDate >= :currentDate AND (p.usageLimit IS NULL OR p.usedCount < p.usageLimit)")
    List<Promotion> findAvailablePromotions(@Param("currentDate") LocalDateTime currentDate);
}
