package iuh.fit.xstore.repository;

import iuh.fit.xstore.model.Booking;
import iuh.fit.xstore.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Integer> {
    List<Booking> findByUser(User user);

    Optional<Booking> findByBookingCode(String bookingCode);

    @Query("SELECT b FROM Booking b WHERE b.user = :user ORDER BY b.bookingDate DESC")
    List<Booking> findByUserOrderByBookingDateDesc(@Param("user") User user);

    @Query("SELECT b FROM Booking b WHERE b.bookingDate BETWEEN :startDate AND :endDate")
    List<Booking> findByBookingDateBetween(@Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate);
}
