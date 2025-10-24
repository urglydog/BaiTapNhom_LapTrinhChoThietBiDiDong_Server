package iuh.fit.xstore.controller;

import iuh.fit.xstore.dto.response.ApiResponse;
import iuh.fit.xstore.dto.response.SuccessCode;
import iuh.fit.xstore.model.Booking;
import iuh.fit.xstore.service.BookingService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bookings")
@RequiredArgsConstructor
public class BookingController {

    private final BookingService bookingService;

    @GetMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    public ApiResponse<List<Booking>> getAllBookings() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, bookingService.findAll());
    }

    @GetMapping("/user/{userId}")
    public ApiResponse<List<Booking>> getBookingsByUser(@PathVariable int userId) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, bookingService.findByUser(null)); // Cần truyền User object
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
    public ApiResponse<Booking> createBooking(
            @RequestParam int userId,
            @RequestParam int showtimeId,
            @RequestParam List<Integer> seatIds,
            @RequestParam String paymentMethod) {
        Booking booking = bookingService.createBooking(userId, showtimeId, seatIds, paymentMethod);
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
}
