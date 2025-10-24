package iuh.fit.xstore.repository;

import iuh.fit.xstore.model.Favourite;
import iuh.fit.xstore.model.FavouriteID;
import iuh.fit.xstore.model.Product;
import iuh.fit.xstore.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FavouriteRepository extends JpaRepository<Favourite, FavouriteID> {
    // Tìm tất cả sản phẩm yêu thích của 1 user
    Optional<Favourite> findByUser(User user);

    // Kiểm tra xem favourate đã tồn tại chưa
    Boolean existsByUserAndProduct(User user, Product product);

    Optional<Favourite> findByFavouriteID(FavouriteID favouriteID);

    List<Favourite> findAllByUser(User user);
}
