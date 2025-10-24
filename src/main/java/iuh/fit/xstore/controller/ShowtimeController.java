package iuh.fit.xstore.controller;

import iuh.fit.xstore.dto.response.ApiResponse;
import iuh.fit.xstore.dto.response.SuccessCode;
import iuh.fit.xstore.model.Showtime;
import iuh.fit.xstore.service.ShowtimeService;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/showtimes")
@RequiredArgsConstructor
public class ShowtimeController {

    private final ShowtimeService showtimeService;

    @GetMapping
    public ApiResponse<List<Showtime>> getAllShowtimes() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, showtimeService.findAll());
    }

    @GetMapping("/movie/{movieId}")
    public ApiResponse<List<Showtime>> getShowtimesByMovie(@PathVariable int movieId) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, showtimeService.findByMovie(null)); // Cần truyền Movie
                                                                                                // object
    }

    @GetMapping("/cinema-hall/{cinemaHallId}")
    public ApiResponse<List<Showtime>> getShowtimesByCinemaHall(@PathVariable int cinemaHallId) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, showtimeService.findByCinemaHall(null)); // Cần truyền
                                                                                                     // CinemaHall
                                                                                                     // object
    }

    @GetMapping("/movie/{movieId}/date/{showDate}")
    public ApiResponse<List<Showtime>> getShowtimesByMovieAndDate(
            @PathVariable int movieId,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate showDate) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, showtimeService.findByMovieAndDate(null, showDate)); // Cần
                                                                                                                 // truyền
                                                                                                                 // Movie
                                                                                                                 // object
    }

    @GetMapping("/cinema-hall/{cinemaHallId}/date/{showDate}")
    public ApiResponse<List<Showtime>> getShowtimesByCinemaHallAndDate(
            @PathVariable int cinemaHallId,
            @PathVariable @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate showDate) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, showtimeService.findByCinemaHallAndDate(null, showDate)); // Cần
                                                                                                                      // truyền
                                                                                                                      // CinemaHall
                                                                                                                      // object
    }

    @GetMapping("/{id}")
    public ApiResponse<Showtime> getShowtime(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, showtimeService.findById(id));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    public ApiResponse<Showtime> createShowtime(@RequestBody Showtime showtime) {
        Showtime createdShowtime = showtimeService.createShowtime(showtime);
        return new ApiResponse<>(SuccessCode.SHOWTIME_CREATED, createdShowtime);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    public ApiResponse<Showtime> updateShowtime(@PathVariable int id, @RequestBody Showtime showtime) {
        showtime.setId(id);
        Showtime updatedShowtime = showtimeService.updateShowtime(showtime);
        return new ApiResponse<>(SuccessCode.SHOWTIME_UPDATED, updatedShowtime);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<Void> deleteShowtime(@PathVariable int id) {
        showtimeService.deleteShowtime(id);
        return new ApiResponse<>(SuccessCode.SHOWTIME_DELETED, null);
    }
}
