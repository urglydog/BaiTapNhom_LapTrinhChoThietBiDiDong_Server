package iuh.fit.movieapp.service;

import iuh.fit.movieapp.dto.response.AppException;
import iuh.fit.movieapp.dto.response.ErrorCode;
import iuh.fit.movieapp.model.Favourite;
import iuh.fit.movieapp.model.Movie;
import iuh.fit.movieapp.model.User;
import iuh.fit.movieapp.repository.FavouriteRepository;
import iuh.fit.movieapp.repository.MovieRepository;
import iuh.fit.movieapp.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

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
