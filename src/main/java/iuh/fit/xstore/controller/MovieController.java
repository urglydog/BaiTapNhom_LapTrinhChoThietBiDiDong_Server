package iuh.fit.xstore.controller;

import iuh.fit.xstore.dto.response.ApiResponse;
import iuh.fit.xstore.dto.response.SuccessCode;
import iuh.fit.xstore.model.Movie;
import iuh.fit.xstore.service.MovieService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/movies")
@RequiredArgsConstructor
public class MovieController {

    private final MovieService movieService;

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
}
