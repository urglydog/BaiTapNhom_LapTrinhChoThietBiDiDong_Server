package iuh.fit.movieapp.controller;

import iuh.fit.movieapp.dto.response.ApiResponse;
import iuh.fit.movieapp.dto.response.SuccessCode;
import iuh.fit.movieapp.model.Seat;
import iuh.fit.movieapp.service.SeatService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/seats")
@RequiredArgsConstructor
public class SeatController {

    private final SeatService seatService;

    @GetMapping("/cinema-hall/{cinemaHallId}")
    public ApiResponse<List<Seat>> getSeatsByCinemaHall(@PathVariable int cinemaHallId) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, seatService.findByCinemaHall(cinemaHallId));
    }

    @GetMapping("/{id}")
    public ApiResponse<Seat> getSeat(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, seatService.findById(id));
    }

    /**
     * Kiểm tra số lượng ghế duplicate (không cần quyền admin)
     */
    @GetMapping("/duplicates/check")
    public ApiResponse<Map<String, Object>> checkDuplicateSeats() {
        List<Object[]> duplicates = seatService.getDuplicateSeatsInfo();
        Map<String, Object> result = new HashMap<>();
        result.put("hasDuplicates", !duplicates.isEmpty());
        result.put("duplicateCount", duplicates.size());
        result.put("duplicates", duplicates.stream().map(arr -> {
            Map<String, Object> dup = new HashMap<>();
            dup.put("cinemaHallId", arr[0]);
            dup.put("seatNumber", arr[1]);
            dup.put("count", arr[2]);
            return dup;
        }).toList());
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, result);
    }

    /**
     * Cleanup duplicate seats - Chỉ admin mới được phép
     * Endpoint này sẽ:
     * 1. Cập nhật booking_items để trỏ về ghế đúng
     * 2. Xóa các ghế duplicate
     */
    @PostMapping("/duplicates/cleanup")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<Map<String, Object>> cleanupDuplicateSeats() {
        // Kiểm tra duplicate trước khi cleanup
        List<Object[]> duplicatesBefore = seatService.getDuplicateSeatsInfo();
        int duplicateCountBefore = duplicatesBefore.size();
        
        // Thực hiện cleanup
        int deletedSeats = seatService.fixDuplicateSeats();
        
        // Kiểm tra lại sau cleanup
        List<Object[]> duplicatesAfter = seatService.getDuplicateSeatsInfo();
        int duplicateCountAfter = duplicatesAfter.size();
        
        Map<String, Object> result = new HashMap<>();
        result.put("deletedSeats", deletedSeats);
        result.put("duplicateCountBefore", duplicateCountBefore);
        result.put("duplicateCountAfter", duplicateCountAfter);
        result.put("success", duplicateCountAfter == 0);
        result.put("message", duplicateCountAfter == 0 
            ? "Cleanup thành công! Không còn ghế duplicate." 
            : "Cleanup hoàn tất. Vẫn còn " + duplicateCountAfter + " nhóm duplicate.");
        
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, result);
    }
}

