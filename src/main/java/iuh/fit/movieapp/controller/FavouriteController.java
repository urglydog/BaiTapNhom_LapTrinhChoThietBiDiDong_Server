package iuh.fit.movieapp.controller;

import iuh.fit.movieapp.dto.request.FavouriteRequest;
import iuh.fit.movieapp.dto.response.ApiResponse;
import iuh.fit.movieapp.dto.response.ErrorCode;
import iuh.fit.movieapp.dto.response.SuccessCode;
import iuh.fit.movieapp.model.Favourite;
import iuh.fit.movieapp.model.User;
import iuh.fit.movieapp.repository.UserRepository;
import iuh.fit.movieapp.service.FavouriteService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/favourites")
@RequiredArgsConstructor
public class FavouriteController {

    private final FavouriteService favouriteService;
    private final UserRepository userRepository;

    @GetMapping
    public ApiResponse<List<Favourite>> getMyFavourites() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth.getName() == null) {
            return new ApiResponse<>(ErrorCode.UNAUTHORIZED);
        }
        String username = auth.getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, favouriteService.findByUserId(user.getId()));
    }

    @PostMapping
    public ApiResponse<Favourite> create(@RequestBody FavouriteRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth.getName() == null) {
            return new ApiResponse<>(ErrorCode.UNAUTHORIZED);
        }
        String username = auth.getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Favourite favourite = favouriteService.createFavourite(user.getId(), request.getMovieId());
        return new ApiResponse<>(SuccessCode.FAVOURITE_CREATED, favourite);
    }

    @DeleteMapping("/{movieId}")
    public ApiResponse<Void> deleteByMovieId(@PathVariable int movieId) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth.getName() == null) {
            return new ApiResponse<>(ErrorCode.UNAUTHORIZED);
        }
        String username = auth.getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        favouriteService.deleteFavouriteByMovieId(user.getId(), movieId);
        return new ApiResponse<>(SuccessCode.FAVOURITE_DELETED, null);
    }

    // Legacy endpoints for backward compatibility
    @PostMapping("/user/{userId}/movie/{movieId}")
    public ApiResponse<Favourite> createLegacy(@PathVariable int userId, @PathVariable int movieId) {
        Favourite favourite = favouriteService.createFavourite(userId, movieId);
        return new ApiResponse<>(SuccessCode.FAVOURITE_CREATED, favourite);
    }

    @DeleteMapping("/id/{id}")
    public ApiResponse<Void> delete(@PathVariable int id) {
        favouriteService.deleteFavourite(id);
        return new ApiResponse<>(SuccessCode.FAVOURITE_DELETED, null);
    }

    @GetMapping("/user/{userId}")
    public ApiResponse<List<Favourite>> findByUser(@PathVariable int userId) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, favouriteService.findByUserId(userId));
    }

    @GetMapping("/user/{userId}/movie/{movieId}/check")
    public ApiResponse<Boolean> isFavourite(@PathVariable int userId, @PathVariable int movieId) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, favouriteService.isFavourite(userId, movieId));
    }
}
