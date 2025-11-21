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
}

