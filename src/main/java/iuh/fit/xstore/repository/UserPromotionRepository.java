package iuh.fit.xstore.repository;

import iuh.fit.xstore.model.Promotion;
import iuh.fit.xstore.model.User;
import iuh.fit.xstore.model.UserPromotion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserPromotionRepository extends JpaRepository<UserPromotion, Integer> {
    List<UserPromotion> findByUser(User user);

    List<UserPromotion> findByPromotion(Promotion promotion);

    Optional<UserPromotion> findByUserAndPromotion(User user, Promotion promotion);

    boolean existsByUserAndPromotion(User user, Promotion promotion);
}
