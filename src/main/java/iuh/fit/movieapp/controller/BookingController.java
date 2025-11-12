package iuh.fit.movieapp.controller;

import iuh.fit.movieapp.dto.request.BookingRequest;
import iuh.fit.movieapp.dto.response.ApiResponse;
import iuh.fit.movieapp.dto.response.ErrorCode;
import iuh.fit.movieapp.dto.response.SuccessCode;
import iuh.fit.movieapp.model.Booking;
import iuh.fit.movieapp.model.User;
import iuh.fit.movieapp.repository.UserRepository;
import iuh.fit.movieapp.service.BookingService;
import iuh.fit.movieapp.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bookings")
@RequiredArgsConstructor
public class BookingController {

    private final BookingService bookingService;
    private final UserRepository userRepository;
    private final JwtUtil jwtUtil;

    @GetMapping
    public ApiResponse<List<Booking>> getBookings() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth.getName() == null) {
            return new ApiResponse<>(ErrorCode.UNAUTHORIZED);
        }
        String username = auth.getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, bookingService.findByUser(user));
    }

    @GetMapping("/all")
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    public ApiResponse<List<Booking>> getAllBookings() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, bookingService.findAll());
    }

    @GetMapping("/user/{userId}")
    public ApiResponse<List<Booking>> getBookingsByUser(@PathVariable int userId) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, bookingService.findByUserId(userId));
    }

    @GetMapping("/booking-code/{bookingCode}")
    public ApiResponse<Booking> getBookingByCode(@PathVariable String bookingCode) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, bookingService.findByBookingCode(bookingCode));
    }

    @GetMapping("/{id}")
    public ApiResponse<Booking> getBooking(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, bookingService.findById(id));
    }

    @PostMapping
    public ApiResponse<Booking> createBooking(@RequestBody BookingRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth.getName() == null) {
            return new ApiResponse<>(ErrorCode.UNAUTHORIZED);
        }
        String username = auth.getName();
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        Booking booking = bookingService.createBooking(
                user.getId(),
                request.getShowtimeId(),
                request.getSeatIds(),
                request.getPaymentMethod(),
                request.getPromotionCode()
        );
        return new ApiResponse<>(SuccessCode.BOOKING_CREATED, booking);
    }

    @PutMapping("/{id}/status")
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    public ApiResponse<Booking> updateBookingStatus(
            @PathVariable int id,
            @RequestParam String status) {
        Booking.BookingStatus bookingStatus = Booking.BookingStatus.valueOf(status.toUpperCase());
        Booking updatedBooking = bookingService.updateBookingStatus(id, bookingStatus);
        return new ApiResponse<>(SuccessCode.BOOKING_UPDATED, updatedBooking);
    }

    @PutMapping("/{id}/payment-status")
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    public ApiResponse<Booking> updatePaymentStatus(
            @PathVariable int id,
            @RequestParam String status) {
        Booking.PaymentStatus paymentStatus = Booking.PaymentStatus.valueOf(status.toUpperCase());
        Booking updatedBooking = bookingService.updatePaymentStatus(id, paymentStatus);
        return new ApiResponse<>(SuccessCode.BOOKING_UPDATED, updatedBooking);
    }

    @PutMapping("/{id}/cancel")
    public ApiResponse<Void> cancelBooking(@PathVariable int id) {
        bookingService.cancelBooking(id);
        return new ApiResponse<>(SuccessCode.BOOKING_CANCELLED, null);
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deleteBooking(@PathVariable int id) {
        bookingService.cancelBooking(id);
        return new ApiResponse<>(SuccessCode.BOOKING_CANCELLED, null);
    }
}
