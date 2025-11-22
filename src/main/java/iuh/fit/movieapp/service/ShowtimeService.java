package iuh.fit.movieapp.service;

import iuh.fit.movieapp.dto.response.AppException;
import iuh.fit.movieapp.dto.response.ErrorCode;
import iuh.fit.movieapp.model.CinemaHall;
import iuh.fit.movieapp.model.Movie;
import iuh.fit.movieapp.model.Showtime;
import iuh.fit.movieapp.repository.CinemaHallRepository;
import iuh.fit.movieapp.repository.MovieRepository;
import iuh.fit.movieapp.repository.ShowtimeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ShowtimeService {
    private final ShowtimeRepository showtimeRepo;
    private final MovieRepository movieRepo;
    private final CinemaHallRepository cinemaHallRepo;

    public List<Showtime> findAll() {
        return showtimeRepo.findAll();
    }

    public List<Showtime> findByMovie(Movie movie) {
        return showtimeRepo.findByMovie(movie);
    }

    public List<Showtime> findByMovieId(int movieId) {
        Movie movie = movieRepo.findById(movieId)
                .orElseThrow(() -> new AppException(ErrorCode.MOVIE_NOT_FOUND));
        // Repository đã JOIN FETCH cinemaHall, nên không cần trigger lazy load
        return showtimeRepo.findByMovie(movie);
    }

    public List<Showtime> findByCinemaHall(CinemaHall cinemaHall) {
        return showtimeRepo.findByCinemaHall(cinemaHall);
    }

    public List<Showtime> findByCinemaHallId(int cinemaHallId) {
        CinemaHall cinemaHall = cinemaHallRepo.findById(cinemaHallId)
                .orElseThrow(() -> new AppException(ErrorCode.CINEMA_HALL_NOT_FOUND));
        return showtimeRepo.findByCinemaHall(cinemaHall);
    }

    public List<Showtime> findByMovieAndDate(Movie movie, LocalDate showDate) {
        return showtimeRepo.findActiveShowtimesByMovieAndDate(movie, showDate);
    }

    public List<Showtime> findByMovieIdAndDate(int movieId, LocalDate showDate) {
        Movie movie = movieRepo.findById(movieId)
                .orElseThrow(() -> new AppException(ErrorCode.MOVIE_NOT_FOUND));
        return showtimeRepo.findActiveShowtimesByMovieAndDate(movie, showDate);
    }

    public List<Showtime> findByCinemaHallAndDate(CinemaHall cinemaHall, LocalDate showDate) {
        return showtimeRepo.findActiveShowtimesByCinemaHallAndDate(cinemaHall, showDate);
    }

    public List<Showtime> findByCinemaHallIdAndDate(int cinemaHallId, LocalDate showDate) {
        CinemaHall cinemaHall = cinemaHallRepo.findById(cinemaHallId)
                .orElseThrow(() -> new AppException(ErrorCode.CINEMA_HALL_NOT_FOUND));
        return showtimeRepo.findActiveShowtimesByCinemaHallAndDate(cinemaHall, showDate);
    }

    public Showtime findById(int id) {
        return showtimeRepo.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.SHOWTIME_NOT_FOUND));
    }

    public Showtime createShowtime(Showtime showtime) {
        return showtimeRepo.save(showtime);
    }

    public Showtime updateShowtime(Showtime showtime) {
        Showtime existedShowtime = findById(showtime.getId());
        existedShowtime.setMovie(showtime.getMovie());
        existedShowtime.setCinemaHall(showtime.getCinemaHall());
        existedShowtime.setShowDate(showtime.getShowDate());
        existedShowtime.setStartTime(showtime.getStartTime());
        existedShowtime.setEndTime(showtime.getEndTime());
        return showtimeRepo.save(existedShowtime);
    }

    public void deleteShowtime(int id) {
        Showtime showtime = findById(id);
        showtime.setActive(false);
        showtimeRepo.save(showtime);
    }
}
