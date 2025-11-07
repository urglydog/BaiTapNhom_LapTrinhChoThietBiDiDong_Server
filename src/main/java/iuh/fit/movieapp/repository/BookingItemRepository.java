package iuh.fit.movieapp.repository;

import iuh.fit.movieapp.model.Booking;
import iuh.fit.movieapp.model.BookingItem;
import iuh.fit.movieapp.model.Seat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookingItemRepository extends JpaRepository<BookingItem, Integer> {
    List<BookingItem> findByBooking(Booking booking);

    List<BookingItem> findBySeat(Seat seat);
}
