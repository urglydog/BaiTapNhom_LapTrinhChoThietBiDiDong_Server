package iuh.fit.xstore.controller;

import iuh.fit.xstore.dto.response.ApiResponse;
import iuh.fit.xstore.dto.response.SuccessCode;
import iuh.fit.xstore.model.Cinema;
import iuh.fit.xstore.service.CinemaService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/cinemas")
@RequiredArgsConstructor
public class CinemaController {

    private final CinemaService cinemaService;

    @GetMapping
    public ApiResponse<List<Cinema>> getAllCinemas() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, cinemaService.findAll());
    }

    @GetMapping("/active")
    public ApiResponse<List<Cinema>> getActiveCinemas() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, cinemaService.findActiveCinemas());
    }

    @GetMapping("/city/{city}")
    public ApiResponse<List<Cinema>> getCinemasByCity(@PathVariable String city) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, cinemaService.findByCity(city));
    }

    @GetMapping("/{id}")
    public ApiResponse<Cinema> getCinema(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, cinemaService.findById(id));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    public ApiResponse<Cinema> createCinema(@RequestBody Cinema cinema) {
        Cinema createdCinema = cinemaService.createCinema(cinema);
        return new ApiResponse<>(SuccessCode.CINEMA_CREATED, createdCinema);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    public ApiResponse<Cinema> updateCinema(@PathVariable int id, @RequestBody Cinema cinema) {
        cinema.setId(id);
        Cinema updatedCinema = cinemaService.updateCinema(cinema);
        return new ApiResponse<>(SuccessCode.CINEMA_UPDATED, updatedCinema);
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ApiResponse<Void> deleteCinema(@PathVariable int id) {
        cinemaService.deleteCinema(id);
        return new ApiResponse<>(SuccessCode.CINEMA_DELETED, null);
    }
}
