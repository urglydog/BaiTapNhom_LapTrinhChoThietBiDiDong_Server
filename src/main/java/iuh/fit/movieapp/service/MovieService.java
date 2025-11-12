package iuh.fit.movieapp.service;

import iuh.fit.movieapp.dto.response.AppException;
import iuh.fit.movieapp.dto.response.ErrorCode;
import iuh.fit.movieapp.model.Movie;
import iuh.fit.movieapp.model.Review;
import iuh.fit.movieapp.model.Showtime;
import iuh.fit.movieapp.repository.MovieRepository;
import iuh.fit.movieapp.service.ReviewService;
import iuh.fit.movieapp.service.ShowtimeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MovieService {
    private final MovieRepository movieRepo;
    private final ShowtimeService showtimeService;
    private final ReviewService reviewService;

    public List<Movie> findAll() {
        return movieRepo.findAll();
    }

    public List<Movie> findActiveMovies() {
        return movieRepo.findByActiveTrue();
    }

    public List<Movie> findCurrentlyShowingMovies() {
        return movieRepo.findCurrentlyShowingMovies(LocalDate.now());
    }

    public List<Movie> findUpcomingMovies() {
        return movieRepo.findUpcomingMovies(LocalDate.now());
    }

    public List<Movie> findByGenre(String genre) {
        return movieRepo.findByGenre(genre);
    }

    public Movie findById(int id) {
        return movieRepo.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.MOVIE_NOT_FOUND));
    }

    public Movie createMovie(Movie movie) {
        return movieRepo.save(movie);
    }

    public Movie updateMovie(Movie movie) {
        Movie existedMovie = findById(movie.getId());
        existedMovie.setTitle(movie.getTitle());
        existedMovie.setDescription(movie.getDescription());
        existedMovie.setDuration(movie.getDuration());
        existedMovie.setReleaseDate(movie.getReleaseDate());
        existedMovie.setEndDate(movie.getEndDate());
        existedMovie.setGenre(movie.getGenre());
        existedMovie.setDirector(movie.getDirector());
        existedMovie.setCast(movie.getCast());
        existedMovie.setPosterUrl(movie.getPosterUrl());
        existedMovie.setTrailerUrl(movie.getTrailerUrl());
        existedMovie.setLanguage(movie.getLanguage());
        existedMovie.setSubtitle(movie.getSubtitle());
        existedMovie.setAgeRating(movie.getAgeRating());
        return movieRepo.save(existedMovie);
    }

    public void deleteMovie(int id) {
        Movie movie = findById(id);
        movie.setActive(false);
        movieRepo.save(movie);
    }

    public List<Showtime> getShowtimesByMovieId(int movieId) {
        return showtimeService.findByMovieId(movieId);
    }

    public List<Review> getReviewsByMovieId(int movieId) {
        return reviewService.findByMovieId(movieId);
    }

    public List<Movie> searchMovies(String query) {
        String lowerQuery = query.toLowerCase();
        return movieRepo.findAll().stream()
                .filter(movie -> 
                    (movie.getTitle() != null && movie.getTitle().toLowerCase().contains(lowerQuery)) ||
                    (movie.getGenre() != null && movie.getGenre().toLowerCase().contains(lowerQuery)) ||
                    (movie.getDirector() != null && movie.getDirector().toLowerCase().contains(lowerQuery)) ||
                    (movie.getCast() != null && movie.getCast().toLowerCase().contains(lowerQuery)) ||
                    (movie.getDescription() != null && movie.getDescription().toLowerCase().contains(lowerQuery))
                )
                .collect(Collectors.toList());
    }

    public Review addReview(Review review) {
        return reviewService.createReview(review);
    }
}
