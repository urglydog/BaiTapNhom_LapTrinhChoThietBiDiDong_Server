package iuh.fit.movieapp.repository;

import iuh.fit.movieapp.model.CinemaHall;
import iuh.fit.movieapp.model.Seat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface SeatRepository extends JpaRepository<Seat, Integer> {
    List<Seat> findByCinemaHall(CinemaHall cinemaHall);

    List<Seat> findByCinemaHallAndActiveTrue(CinemaHall cinemaHall);

    List<Seat> findByCinemaHallAndSeatType(CinemaHall cinemaHall, Seat.SeatType seatType);

    // Query để tìm số lượng duplicate seats
    @Query(value = "SELECT cinema_hall_id, seat_number, COUNT(*) as count " +
                   "FROM seats " +
                   "GROUP BY cinema_hall_id, seat_number " +
                   "HAVING COUNT(*) > 1", nativeQuery = true)
    List<Object[]> findDuplicateSeats();

    // Cập nhật booking_items để trỏ về ghế có id nhỏ nhất
    @Modifying
    @Transactional
    @Query(value = "UPDATE booking_items bi " +
                   "INNER JOIN seats s ON bi.seat_id = s.id " +
                   "INNER JOIN ( " +
                   "    SELECT cinema_hall_id, seat_number, MIN(id) as min_id " +
                   "    FROM seats " +
                   "    GROUP BY cinema_hall_id, seat_number " +
                   ") min_seats ON s.cinema_hall_id = min_seats.cinema_hall_id " +
                   "           AND s.seat_number = min_seats.seat_number " +
                   "           AND s.id != min_seats.min_id " +
                   "SET bi.seat_id = min_seats.min_id", nativeQuery = true)
    int updateBookingItemsForDuplicateSeats();

    // Xóa các bản ghi ghế trùng (giữ lại ghế có id nhỏ nhất)
    @Modifying
    @Transactional
    @Query(value = "DELETE s FROM seats s " +
                   "INNER JOIN ( " +
                   "    SELECT cinema_hall_id, seat_number, MIN(id) as min_id " +
                   "    FROM seats " +
                   "    GROUP BY cinema_hall_id, seat_number " +
                   "    HAVING COUNT(*) > 1 " +
                   ") min_seats ON s.cinema_hall_id = min_seats.cinema_hall_id " +
                   "           AND s.seat_number = min_seats.seat_number " +
                   "           AND s.id != min_seats.min_id", nativeQuery = true)
    int deleteDuplicateSeats();
}
