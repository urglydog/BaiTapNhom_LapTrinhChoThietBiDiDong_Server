package iuh.fit.xstore.service;

import iuh.fit.xstore.dto.response.AppException;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.model.Favourite;
import iuh.fit.xstore.model.Movie;
import iuh.fit.xstore.model.User;
import iuh.fit.xstore.repository.FavouriteRepository;
import iuh.fit.xstore.repository.MovieRepository;
import iuh.fit.xstore.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class FavouriteService {

    private final FavouriteRepository favouriteRepo;
    private final UserRepository userRepo;
    private final MovieRepository movieRepo;

    public List<Favourite> findAll() {
        return favouriteRepo.findAll();
    }

    public Favourite createFavourite(int userId, int movieId) {
        User user = userRepo.findById(userId)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));

        Movie movie = movieRepo.findById(movieId)
                .orElseThrow(() -> new AppException(ErrorCode.MOVIE_NOT_FOUND));

        if (favouriteRepo.existsByUserAndMovie(user, movie)) {
            throw new AppException(ErrorCode.FAVOURITE_EXISTED);
        }

        Favourite favourite = Favourite.builder()
                .user(user)
                .movie(movie)
                .build();

        return favouriteRepo.save(favourite);
    }

    public Favourite findById(int id) {
        return favouriteRepo.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.FAVOURITE_NOT_FOUND));
    }

    public void deleteFavourite(int id) {
        Favourite favourite = findById(id);
        favouriteRepo.delete(favourite);
    }

    public List<Favourite> findByUserId(int userId) {
        User user = userRepo.findById(userId)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));
        return favouriteRepo.findByUser(user);
    }

    public boolean isFavourite(int userId, int movieId) {
        User user = userRepo.findById(userId)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));
        Movie movie = movieRepo.findById(movieId)
                .orElseThrow(() -> new AppException(ErrorCode.MOVIE_NOT_FOUND));
        return favouriteRepo.existsByUserAndMovie(user, movie);
    }
}
