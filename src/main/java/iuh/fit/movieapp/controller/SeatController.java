package iuh.fit.movieapp.controller;

import iuh.fit.movieapp.dto.response.ApiResponse;
import iuh.fit.movieapp.dto.response.SuccessCode;
import iuh.fit.movieapp.model.Seat;
import iuh.fit.movieapp.service.SeatService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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
}

