package iuh.fit.xstore.service;

import iuh.fit.xstore.dto.response.AppException;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.model.*;
import iuh.fit.xstore.repository.BookingRepository;
import iuh.fit.xstore.repository.ShowtimeRepository;
import iuh.fit.xstore.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class BookingService {
    private final BookingRepository bookingRepo;
    private final UserRepository userRepo;
    private final ShowtimeRepository showtimeRepo;

    public List<Booking> findAll() {
        return bookingRepo.findAll();
    }

    public List<Booking> findByUser(User user) {
        return bookingRepo.findByUserOrderByBookingDateDesc(user);
    }

    public Booking findByBookingCode(String bookingCode) {
        return bookingRepo.findByBookingCode(bookingCode)
                .orElseThrow(() -> new AppException(ErrorCode.BOOKING_NOT_FOUND));
    }

    public Booking findById(int id) {
        return bookingRepo.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.BOOKING_NOT_FOUND));
    }

    @Transactional
    public Booking createBooking(int userId, int showtimeId, List<Integer> seatIds, String paymentMethod) {
        User user = userRepo.findById(userId)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));

        Showtime showtime = showtimeRepo.findById(showtimeId)
                .orElseThrow(() -> new AppException(ErrorCode.SHOWTIME_NOT_FOUND));

        // Tạo booking code unique
        String bookingCode = "BK" + System.currentTimeMillis();

        // Tính tổng tiền (có thể thêm logic tính giá theo loại ghế)
        BigDecimal totalAmount = showtime.getPrice().multiply(BigDecimal.valueOf(seatIds.size()));

        Booking booking = Booking.builder()
                .user(user)
                .showtime(showtime)
                .bookingCode(bookingCode)
                .totalAmount(totalAmount)
                .bookingStatus(Booking.BookingStatus.PENDING)
                .paymentStatus(Booking.PaymentStatus.PENDING)
                .paymentMethod(paymentMethod)
                .bookingDate(LocalDateTime.now())
                .build();

        return bookingRepo.save(booking);
    }

    public Booking updateBookingStatus(int id, Booking.BookingStatus status) {
        Booking booking = findById(id);
        booking.setBookingStatus(status);
        return bookingRepo.save(booking);
    }

    public Booking updatePaymentStatus(int id, Booking.PaymentStatus status) {
        Booking booking = findById(id);
        booking.setPaymentStatus(status);
        if (status == Booking.PaymentStatus.PAID) {
            booking.setBookingStatus(Booking.BookingStatus.CONFIRMED);
        }
        return bookingRepo.save(booking);
    }

    public void cancelBooking(int id) {
        Booking booking = findById(id);
        booking.setBookingStatus(Booking.BookingStatus.CANCELLED);
        bookingRepo.save(booking);
    }
}
