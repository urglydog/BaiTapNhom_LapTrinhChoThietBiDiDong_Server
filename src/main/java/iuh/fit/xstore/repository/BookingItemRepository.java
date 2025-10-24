package iuh.fit.xstore.repository;

import iuh.fit.xstore.model.Booking;
import iuh.fit.xstore.model.BookingItem;
import iuh.fit.xstore.model.Seat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookingItemRepository extends JpaRepository<BookingItem, Integer> {
    List<BookingItem> findByBooking(Booking booking);

    List<BookingItem> findBySeat(Seat seat);
}
