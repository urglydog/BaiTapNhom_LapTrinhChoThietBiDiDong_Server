package iuh.fit.xstore.controller;

import iuh.fit.xstore.dto.response.ApiResponse;
import iuh.fit.xstore.dto.response.SuccessCode;
import iuh.fit.xstore.model.Favourite;
import iuh.fit.xstore.service.FavouriteService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/favourites")
@RequiredArgsConstructor
public class FavouriteController {

    private final FavouriteService favouriteService;

    @GetMapping
    public ApiResponse<List<Favourite>> getAll() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, favouriteService.findAll());
    }

    @PostMapping("/user/{userId}/movie/{movieId}")
    public ApiResponse<Favourite> create(@PathVariable int userId, @PathVariable int movieId) {
        Favourite favourite = favouriteService.createFavourite(userId, movieId);
        return new ApiResponse<>(SuccessCode.FAVOURITE_CREATED, favourite);
    }

    @DeleteMapping("/{id}")
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
