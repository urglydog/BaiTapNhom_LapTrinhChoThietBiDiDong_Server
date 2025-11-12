package iuh.fit.movieapp.controller;

import iuh.fit.movieapp.dto.response.ApiResponse;
import iuh.fit.movieapp.dto.response.ErrorCode;
import iuh.fit.movieapp.dto.response.SuccessCode;
import iuh.fit.movieapp.model.Movie;
import iuh.fit.movieapp.model.Review;
import iuh.fit.movieapp.model.User;
import iuh.fit.movieapp.repository.UserRepository;
import iuh.fit.movieapp.service.MovieService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/movies")
@RequiredArgsConstructor
public class MovieController {

    private final MovieService movieService;
    private final UserRepository userRepository;

    @GetMapping
    public ApiResponse<List<Movie>> getAllMovies() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, movieService.findAll());
    }

    @GetMapping("/active")
    public ApiResponse<List<Movie>> getActiveMovies() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, movieService.findActiveMovies());
    }

    @GetMapping("/currently-showing")
    public ApiResponse<List<Movie>> getCurrentlyShowingMovies() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, movieService.findCurrentlyShowingMovies());
    }

    @GetMapping("/upcoming")
    public ApiResponse<List<Movie>> getUpcomingMovies() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, movieService.findUpcomingMovies());
    }

    @GetMapping("/genre/{genre}")
    public ApiResponse<List<Movie>> getMoviesByGenre(@PathVariable String genre) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, movieService.findByGenre(genre));
    }

    @GetMapping("/{id}")
    public ApiResponse<Movie> getMovie(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, movieService.findById(id));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    public ApiResponse<Movie> createMovie(@RequestBody Movie movie) {
        Movie createdMovie = movieService.createMovie(movie);
        return new ApiResponse<>(SuccessCode.MOVIE_CREATED, createdMovie);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    public ApiResponse<Movie> updateMovie(@PathVariable int id, @RequestBody Movie movie) {
        movie.setId(id);
        Movie updatedMovie = movieService.updateMovie(movie);
        return new ApiResponse<>(SuccessCode.MOVIE_UPDATED, updatedMovie);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<Void> deleteMovie(@PathVariable int id) {
        movieService.deleteMovie(id);
        return new ApiResponse<>(SuccessCode.MOVIE_DELETED, null);
    }

    // Alias endpoints for frontend compatibility
    @GetMapping("/{id}/showtimes")
    public ApiResponse<?> getMovieShowtimes(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, movieService.getShowtimesByMovieId(id));
    }

    @GetMapping("/{id}/reviews")
    public ApiResponse<?> getMovieReviews(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, movieService.getReviewsByMovieId(id));
    }

    @GetMapping("/search")
    public ApiResponse<?> searchMovies(@RequestParam String q) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, movieService.searchMovies(q));
    }

    @PostMapping("/{id}/reviews")
    public ApiResponse<?> addReview(@PathVariable int id, @RequestBody Review review) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth.getName() == null) {
            return new ApiResponse<>(ErrorCode.UNAUTHORIZED);
        }
        String username = auth.getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        review.setMovie(movieService.findById(id));
        review.setUser(user);
        return new ApiResponse<>(SuccessCode.REVIEW_CREATED, movieService.addReview(review));
    }
}
