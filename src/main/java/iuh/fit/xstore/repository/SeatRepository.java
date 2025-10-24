package iuh.fit.xstore.repository;

import iuh.fit.xstore.model.CinemaHall;
import iuh.fit.xstore.model.Seat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SeatRepository extends JpaRepository<Seat, Integer> {
    List<Seat> findByCinemaHall(CinemaHall cinemaHall);

    List<Seat> findByCinemaHallAndIsActiveTrue(CinemaHall cinemaHall);

    List<Seat> findByCinemaHallAndSeatType(CinemaHall cinemaHall, Seat.SeatType seatType);
}
