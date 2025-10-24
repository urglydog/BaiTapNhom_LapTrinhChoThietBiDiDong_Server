package iuh.fit.movieapp.repository;

import iuh.fit.movieapp.model.CinemaHall;
import iuh.fit.movieapp.model.Seat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SeatRepository extends JpaRepository<Seat, Integer> {
    List<Seat> findByCinemaHall(CinemaHall cinemaHall);

    List<Seat> findByCinemaHallAndActiveTrue(CinemaHall cinemaHall);

    List<Seat> findByCinemaHallAndSeatType(CinemaHall cinemaHall, Seat.SeatType seatType);
}
