package iuh.fit.movieapp.service;

import iuh.fit.movieapp.dto.response.AppException;
import iuh.fit.movieapp.dto.response.ErrorCode;
import iuh.fit.movieapp.model.*;
import iuh.fit.movieapp.repository.BookingItemRepository;
import iuh.fit.movieapp.repository.BookingRepository;
import iuh.fit.movieapp.repository.SeatRepository;
import iuh.fit.movieapp.repository.ShowtimeRepository;
import iuh.fit.movieapp.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BookingService {
    private final BookingRepository bookingRepo;
    private final UserRepository userRepo;
    private final ShowtimeRepository showtimeRepo;
    private final SeatRepository seatRepo;
    private final BookingItemRepository bookingItemRepo;
    private final PromotionService promotionService;

    public List<Booking> findAll() {
        return bookingRepo.findAll();
    }

    public List<Booking> findByUser(User user) {
        return bookingRepo.findByUserOrderByBookingDateDesc(user);
    }

    public List<Booking> findByUserId(int userId) {
        User user = userRepo.findById(userId)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));
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
        return createBooking(userId, showtimeId, seatIds, paymentMethod, null);
    }

    @Transactional
    public Booking createBooking(int userId, int showtimeId, List<Integer> seatIds, String paymentMethod,
            String promotionCode) {
        User user = userRepo.findById(userId)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));

        Showtime showtime = showtimeRepo.findById(showtimeId)
                .orElseThrow(() -> new AppException(ErrorCode.SHOWTIME_NOT_FOUND));

        // Tạo booking code unique
        String bookingCode = "BK" + System.currentTimeMillis();
        
        // Tạo QR code
        String qrCode = "QR-" + bookingCode + "-" + 
                      java.util.UUID.randomUUID().toString().substring(0, 9).toUpperCase();

        // Tính tổng tiền dựa trên giá ghế (base_price từ seat)
        BigDecimal totalAmount = BigDecimal.ZERO;
        List<BookingItem> bookingItems = new ArrayList<>();
        
        for (Integer seatId : seatIds) {
            Seat seat = seatRepo.findById(seatId)
                    .orElseThrow(() -> new AppException(ErrorCode.SEAT_NOT_FOUND));

            // Kiểm tra ghế đã được đặt chưa
            List<BookingItem> existingItems = bookingItemRepo.findBySeat(seat);
            boolean isBooked = existingItems.stream()
                    .anyMatch(item -> {
                        Booking b = item.getBooking();
                        return (b.getShowtime().getId() == showtimeId) &&
                                (b.getBookingStatus() == Booking.BookingStatus.PENDING ||
                                        b.getBookingStatus() == Booking.BookingStatus.CONFIRMED);
                    });

            if (isBooked) {
                throw new AppException(ErrorCode.SEAT_ALREADY_BOOKED);
            }

            // Lấy giá từ seat (base_price), nếu không có thì dùng giá mặc định theo loại ghế
            BigDecimal seatPrice;
            if (seat.getBasePrice() != null && seat.getBasePrice().compareTo(BigDecimal.ZERO) > 0) {
                seatPrice = seat.getBasePrice();
            } else {
                // Giá mặc định theo loại ghế
                switch (seat.getSeatType()) {
                    case VIP:
                        seatPrice = new BigDecimal("150000");
                        break;
                    case COUPLE:
                        seatPrice = new BigDecimal("200000");
                        break;
                    case NORMAL:
                    default:
                        seatPrice = new BigDecimal("100000");
                        break;
                }
            }

            BookingItem bookingItem = BookingItem.builder()
                    .booking(null) // Sẽ set sau khi booking được tạo
                    .seat(seat)
                    .price(seatPrice)
                    .build();
            bookingItems.add(bookingItem);
            totalAmount = totalAmount.add(seatPrice);
        }

        // Apply promotion code if provided
        Promotion promotion = null;
        BigDecimal discountAmount = BigDecimal.ZERO;

        if (promotionCode != null && !promotionCode.trim().isEmpty()) {
            promotion = promotionService.validateAndGetPromotion(promotionCode, totalAmount);
            discountAmount = promotionService.calculateDiscount(promotion, totalAmount);
            totalAmount = totalAmount.subtract(discountAmount);

            // Đảm bảo tổng tiền không âm
            if (totalAmount.compareTo(BigDecimal.ZERO) < 0) {
                totalAmount = BigDecimal.ZERO;
            }
        }

        Booking booking = Booking.builder()
                .user(user)
                .showtime(showtime)
                .bookingCode(bookingCode)
                .qrCode(qrCode)
                .totalAmount(totalAmount)
                .promotion(promotion)
                .discountAmount(discountAmount)
                .bookingStatus(Booking.BookingStatus.PENDING)
                .paymentStatus(Booking.PaymentStatus.PENDING)
                .paymentMethod(paymentMethod)
                .bookingDate(LocalDateTime.now())
                .build();

        booking = bookingRepo.save(booking);

        // Set booking cho các booking items và lưu
        for (BookingItem item : bookingItems) {
            item.setBooking(booking);
        }
        bookingItemRepo.saveAll(bookingItems);

        // Tăng số lần sử dụng promotion nếu có
        if (promotion != null) {
            promotionService.incrementUsedCount(promotion);
        }

        return booking;
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
