package iuh.fit.movieapp.service;

import iuh.fit.movieapp.dto.response.AppException;
import iuh.fit.movieapp.dto.response.ErrorCode;
import iuh.fit.movieapp.model.*;
import iuh.fit.movieapp.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SeatService {
    private final SeatRepository seatRepo;
    private final CinemaHallRepository cinemaHallRepo;
    private final ShowtimeRepository showtimeRepo;
    private final BookingItemRepository bookingItemRepo;

    public List<Seat> findByCinemaHall(int cinemaHallId) {
        CinemaHall cinemaHall = cinemaHallRepo.findById(cinemaHallId)
                .orElseThrow(() -> new AppException(ErrorCode.CINEMA_HALL_NOT_FOUND));
        return seatRepo.findByCinemaHallAndActiveTrue(cinemaHall);
    }

    public List<Seat> findByShowtime(int showtimeId) {
        Showtime showtime = showtimeRepo.findById(showtimeId)
                .orElseThrow(() -> new AppException(ErrorCode.SHOWTIME_NOT_FOUND));
        return seatRepo.findByCinemaHallAndActiveTrue(showtime.getCinemaHall());
    }

    public List<Seat> findAvailableSeatsByShowtime(int showtimeId) {
        Showtime showtime = showtimeRepo.findById(showtimeId)
                .orElseThrow(() -> new AppException(ErrorCode.SHOWTIME_NOT_FOUND));
        
        // Lấy tất cả ghế của phòng chiếu
        List<Seat> allSeats = seatRepo.findByCinemaHallAndActiveTrue(showtime.getCinemaHall());
        
        // Lấy danh sách ghế đã được đặt cho showtime này
        List<BookingItem> bookedItems = bookingItemRepo.findAll().stream()
                .filter(item -> item.getBooking().getShowtime().getId() == showtimeId &&
                               (item.getBooking().getBookingStatus() == Booking.BookingStatus.PENDING ||
                                item.getBooking().getBookingStatus() == Booking.BookingStatus.CONFIRMED))
                .collect(Collectors.toList());
        
        Set<Integer> bookedSeatIds = bookedItems.stream()
                .map(item -> item.getSeat().getId())
                .collect(Collectors.toSet());
        
        // Lọc ra các ghế chưa được đặt
        return allSeats.stream()
                .filter(seat -> !bookedSeatIds.contains(seat.getId()))
                .collect(Collectors.toList());
    }

    public List<Seat> findBookedSeatsByShowtime(int showtimeId) {
        Showtime showtime = showtimeRepo.findById(showtimeId)
                .orElseThrow(() -> new AppException(ErrorCode.SHOWTIME_NOT_FOUND));
        
        // Lấy danh sách seat IDs đã được đặt cho showtime này (sử dụng query trực tiếp để tránh proxy issues)
        List<Integer> bookedSeatIds = bookingItemRepo.findBookedSeatIdsByShowtimeId(showtimeId);
        
        // Query lại từ seatRepo để tránh Hibernate proxy issues
        if (bookedSeatIds.isEmpty()) {
            return List.of();
        }
        
        return seatRepo.findAllById(bookedSeatIds);
    }

    public Seat findById(int id) {
        return seatRepo.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.SEAT_NOT_FOUND));
    }

    /**
     * Fix duplicate seats by:
     * 1. Updating booking_items to point to the seat with minimum id in each duplicate group
     * 2. Deleting duplicate seats (keeping only the one with minimum id)
     * @return Number of duplicate seats deleted
     */
    @org.springframework.transaction.annotation.Transactional
    public int fixDuplicateSeats() {
        // First, update booking_items to point to the correct seat
        int updatedBookingItems = seatRepo.updateBookingItemsForDuplicateSeats();
        
        // Then, delete duplicate seats
        int deletedSeats = seatRepo.deleteDuplicateSeats();
        
        return deletedSeats;
    }

    /**
     * Get information about duplicate seats
     * @return List of duplicate seat information [cinema_hall_id, seat_number, count]
     */
    public List<Object[]> getDuplicateSeatsInfo() {
        return seatRepo.findDuplicateSeats();
    }
}

