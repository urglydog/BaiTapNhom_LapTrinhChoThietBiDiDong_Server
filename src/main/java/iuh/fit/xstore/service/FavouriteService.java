package iuh.fit.xstore.service;

import iuh.fit.xstore.dto.request.FavouriteRequest;
import iuh.fit.xstore.dto.response.AppException;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.model.Favourite;
import iuh.fit.xstore.model.FavouriteID;
import iuh.fit.xstore.model.Product;
import iuh.fit.xstore.model.User;
import iuh.fit.xstore.repository.FavouriteRepository;
import iuh.fit.xstore.repository.ProductRepository;
import iuh.fit.xstore.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FavouriteService {

    private final FavouriteRepository favouriteRepo;
    private final UserRepository userRepo;
    private final ProductRepository productRepo;

    public List<Favourite> findAll() {
        return favouriteRepo.findAll();
    }

    public Favourite createFavourite(FavouriteRequest req) {
        User user = userRepo.findById(req.getUserId())
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));

        Product product = productRepo.findById(req.getProductId())
                .orElseThrow(() -> new AppException(ErrorCode.PRODUCT_NOT_FOUND));

        if (favouriteRepo.existsByUserAndProduct(user, product)) {
            throw new AppException(ErrorCode.FAVOURITE_EXISTED);
        }

        Favourite favourite = Favourite.builder()
                .favouriteID(new FavouriteID(user.getId(), product.getId()))
                .user(user)
                .product(product)
                .build();

        return favouriteRepo.save(favourite);
    }

    public Favourite findFavouriteById(FavouriteID id) {
        return favouriteRepo.findByFavouriteID(id)
                .orElseThrow(() -> new AppException(ErrorCode.FAVOURITE_NOT_FOUND));
    }

    public FavouriteID deleteFavourite(int userId, int productId) {
        FavouriteID id = new FavouriteID(userId, productId);
        Favourite fav = findFavouriteById(id);
        favouriteRepo.delete(fav);
        return id;
    }

    public List<Favourite> findByUserId(int userId) {
        User user = userRepo.findById(userId)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));
        return favouriteRepo.findAllByUser((user));
    }
}
