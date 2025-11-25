package iuh.fit.movieapp.controller;

import iuh.fit.movieapp.dto.response.ApiResponse;
import iuh.fit.movieapp.dto.response.ErrorCode;
import iuh.fit.movieapp.dto.response.SuccessCode;
import iuh.fit.movieapp.model.Booking;
import iuh.fit.movieapp.service.BookingService;
import iuh.fit.movieapp.service.VNPayService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/vnpay")
@RequiredArgsConstructor
public class VNPayController {
    
    private final VNPayService vnPayService;
    private final BookingService bookingService;
    
    /**
     * Test endpoint để kiểm tra VNPay service hoạt động
     * Không cần authentication, chỉ để test
     * GET /api/vnpay/test?amount=100000
     */
    @GetMapping("/test")
    public ApiResponse<Map<String, String>> testVNPay(
            @RequestParam(defaultValue = "100000") long amount,
            HttpServletRequest request) {
        try {
            // Tạo test booking code
            String testBookingCode = "TEST" + System.currentTimeMillis();
            
            // Tạo payment URL
            String paymentUrl = vnPayService.createPaymentUrl(
                    999, // Test booking ID
                    amount,
                    testBookingCode,
                    request
            );
            
            Map<String, String> result = new HashMap<>();
            result.put("paymentUrl", paymentUrl);
            result.put("testBookingCode", testBookingCode);
            result.put("amount", String.valueOf(amount));
            result.put("message", "Test payment URL created successfully. Click paymentUrl to test VNPay.");
            
            return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, result);
        } catch (Exception e) {
            Map<String, String> errorResult = new HashMap<>();
            errorResult.put("error", e.getMessage());
            errorResult.put("stackTrace", java.util.Arrays.toString(e.getStackTrace()));
            return new ApiResponse<>(ErrorCode.UNKNOWN_ERROR);
        }
    }
    
    @PostMapping("/create-payment")
    public ApiResponse<Map<String, String>> createPayment(
            @RequestParam int bookingId,
            HttpServletRequest request) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth == null || auth.getName() == null) {
                return new ApiResponse<>(ErrorCode.UNAUTHORIZED);
            }
            
            Booking booking = bookingService.findById(bookingId);
            
            // Kiểm tra booking có thuộc về user hiện tại không
            if (!booking.getUser().getUsername().equals(auth.getName())) {
                return new ApiResponse<>(ErrorCode.FORBIDDEN);
            }
            
            // Kiểm tra payment method phải là VNPAY
            if (!"VNPAY".equalsIgnoreCase(booking.getPaymentMethod())) {
                return new ApiResponse<>(ErrorCode.BOOKING_NOT_FOUND);
            }
            
            // Kiểm tra booking chưa được thanh toán
            if (booking.getPaymentStatus() == Booking.PaymentStatus.PAID) {
                return new ApiResponse<>(ErrorCode.BOOKING_EXISTED);
            }
            
            long amount = booking.getTotalAmount().longValue();
            String paymentUrl = vnPayService.createPaymentUrl(
                    bookingId, 
                    amount, 
                    booking.getBookingCode(), 
                    request
            );
            
            Map<String, String> result = new HashMap<>();
            result.put("paymentUrl", paymentUrl);
            result.put("bookingId", String.valueOf(bookingId));
            result.put("bookingCode", booking.getBookingCode());
            
            return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, result);
        } catch (Exception e) {
            return new ApiResponse<>(ErrorCode.UNKNOWN_ERROR);
        }
    }
    
    @GetMapping("/return")
    public ResponseEntity<?> paymentReturn(
            @RequestParam Map<String, String> params,
            HttpServletRequest request) {
        try {
            String vnp_ResponseCode = params.get("vnp_ResponseCode");
            String vnp_TxnRef = params.get("vnp_TxnRef");
            
            // Verify payment
            boolean isValid = vnPayService.verifyPayment(params);
            
            if (!isValid) {
                // Return error page
                String errorHtml = "<html><body><h1>Thanh toán thất bại</h1><p>Chữ ký không hợp lệ</p><p>Vui lòng quay lại ứng dụng</p></body></html>";
                return ResponseEntity.ok().header("Content-Type", "text/html; charset=UTF-8").body(errorHtml);
            }
            
            // Find booking by booking code
            Booking booking = bookingService.findByBookingCode(vnp_TxnRef);
            
            if ("00".equals(vnp_ResponseCode)) {
                // Payment success
                bookingService.updatePaymentStatus(booking.getId(), Booking.PaymentStatus.PAID);
                
                // Return success page
                String successHtml = String.format(
                    "<html><body style='text-align:center;padding:50px;'><h1 style='color:green;'>✓ Thanh toán thành công</h1>" +
                    "<p>Mã đặt vé: <strong>%s</strong></p>" +
                    "<p>Vui lòng quay lại ứng dụng để xem chi tiết</p>" +
                    "<script>setTimeout(function(){window.close();},3000);</script>" +
                    "</body></html>",
                    booking.getBookingCode()
                );
                return ResponseEntity.ok().header("Content-Type", "text/html; charset=UTF-8").body(successHtml);
            } else {
                // Payment failed
                bookingService.updatePaymentStatus(booking.getId(), Booking.PaymentStatus.FAILED);
                
                // Return failed page
                String failedHtml = "<html><body style='text-align:center;padding:50px;'><h1 style='color:red;'>✗ Thanh toán thất bại</h1><p>Vui lòng quay lại ứng dụng để thử lại</p><script>setTimeout(function(){window.close();},3000);</script></body></html>";
                return ResponseEntity.ok().header("Content-Type", "text/html; charset=UTF-8").body(failedHtml);
            }
        } catch (Exception e) {
            String errorHtml = "<html><body style='text-align:center;padding:50px;'><h1 style='color:red;'>Lỗi</h1><p>" + 
                              e.getMessage() + "</p><p>Vui lòng quay lại ứng dụng</p></body></html>";
            return ResponseEntity.ok().header("Content-Type", "text/html; charset=UTF-8").body(errorHtml);
        }
    }
    
    @PostMapping("/ipn")
    public ResponseEntity<?> paymentIpn(
            @RequestParam Map<String, String> params,
            HttpServletRequest request) {
        try {
            String vnp_ResponseCode = params.get("vnp_ResponseCode");
            String vnp_TxnRef = params.get("vnp_TxnRef");
            
            // Verify payment
            boolean isValid = vnPayService.verifyPayment(params);
            
            if (!isValid) {
                return ResponseEntity.ok(Map.of("RspCode", "97", "Message", "Checksum failed"));
            }
            
            // Find booking by booking code
            Booking booking = bookingService.findByBookingCode(vnp_TxnRef);
            
            // Check if booking already processed
            if (booking.getPaymentStatus() == Booking.PaymentStatus.PAID) {
                return ResponseEntity.ok(Map.of("RspCode", "02", "Message", "This order has been updated to the payment status"));
            }
            
            if ("00".equals(vnp_ResponseCode)) {
                // Payment success
                bookingService.updatePaymentStatus(booking.getId(), Booking.PaymentStatus.PAID);
                return ResponseEntity.ok(Map.of("RspCode", "00", "Message", "Success"));
            } else {
                // Payment failed
                bookingService.updatePaymentStatus(booking.getId(), Booking.PaymentStatus.FAILED);
                return ResponseEntity.ok(Map.of("RspCode", "00", "Message", "Success"));
            }
        } catch (Exception e) {
            return ResponseEntity.ok(Map.of("RspCode", "99", "Message", "Unknown error"));
        }
    }
}

