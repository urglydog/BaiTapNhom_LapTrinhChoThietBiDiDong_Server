package iuh.fit.xstore.service;

import iuh.fit.xstore.dto.response.AppException;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.model.Movie;
import iuh.fit.xstore.repository.MovieRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MovieService {
    private final MovieRepository movieRepo;

    public List<Movie> findAll() {
        return movieRepo.findAll();
    }

    public List<Movie> findActiveMovies() {
        return movieRepo.findByIsActiveTrue();
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
}
