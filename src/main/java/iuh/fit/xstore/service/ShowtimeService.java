package iuh.fit.xstore.service;

import iuh.fit.xstore.dto.response.AppException;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.model.CinemaHall;
import iuh.fit.xstore.model.Movie;
import iuh.fit.xstore.model.Showtime;
import iuh.fit.xstore.repository.ShowtimeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ShowtimeService {
    private final ShowtimeRepository showtimeRepo;

    public List<Showtime> findAll() {
        return showtimeRepo.findAll();
    }

    public List<Showtime> findByMovie(Movie movie) {
        return showtimeRepo.findByMovie(movie);
    }

    public List<Showtime> findByCinemaHall(CinemaHall cinemaHall) {
        return showtimeRepo.findByCinemaHall(cinemaHall);
    }

    public List<Showtime> findByMovieAndDate(Movie movie, LocalDate showDate) {
        return showtimeRepo.findActiveShowtimesByMovieAndDate(movie, showDate);
    }

    public List<Showtime> findByCinemaHallAndDate(CinemaHall cinemaHall, LocalDate showDate) {
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
        existedShowtime.setPrice(showtime.getPrice());
        return showtimeRepo.save(existedShowtime);
    }

    public void deleteShowtime(int id) {
        Showtime showtime = findById(id);
        showtime.setActive(false);
        showtimeRepo.save(showtime);
    }
}
