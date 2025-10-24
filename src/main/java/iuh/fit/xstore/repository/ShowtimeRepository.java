package iuh.fit.xstore.repository;

import iuh.fit.xstore.model.CinemaHall;
import iuh.fit.xstore.model.Movie;
import iuh.fit.xstore.model.Showtime;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface ShowtimeRepository extends JpaRepository<Showtime, Integer> {
    List<Showtime> findByMovie(Movie movie);

    List<Showtime> findByCinemaHall(CinemaHall cinemaHall);

    List<Showtime> findByMovieAndShowDate(Movie movie, LocalDate showDate);

    List<Showtime> findByCinemaHallAndShowDate(CinemaHall cinemaHall, LocalDate showDate);

    @Query("SELECT s FROM Showtime s WHERE s.movie = :movie AND s.showDate = :showDate AND s.isActive = true ORDER BY s.startTime")
    List<Showtime> findActiveShowtimesByMovieAndDate(@Param("movie") Movie movie,
            @Param("showDate") LocalDate showDate);

    @Query("SELECT s FROM Showtime s WHERE s.cinemaHall = :cinemaHall AND s.showDate = :showDate AND s.isActive = true ORDER BY s.startTime")
    List<Showtime> findActiveShowtimesByCinemaHallAndDate(@Param("cinemaHall") CinemaHall cinemaHall,
            @Param("showDate") LocalDate showDate);
}
