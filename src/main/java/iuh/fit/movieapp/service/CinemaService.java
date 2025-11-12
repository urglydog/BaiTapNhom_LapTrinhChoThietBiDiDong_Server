package iuh.fit.movieapp.service;

import iuh.fit.movieapp.dto.response.AppException;
import iuh.fit.movieapp.dto.response.ErrorCode;
import iuh.fit.movieapp.model.Cinema;
import iuh.fit.movieapp.model.CinemaHall;
import iuh.fit.movieapp.model.Showtime;
import iuh.fit.movieapp.repository.CinemaHallRepository;
import iuh.fit.movieapp.repository.CinemaRepository;
import iuh.fit.movieapp.service.ShowtimeService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CinemaService {
    private final CinemaRepository cinemaRepo;
    private final CinemaHallRepository cinemaHallRepo;
    private final ShowtimeService showtimeService;

    public List<Cinema> findAll() {
        return cinemaRepo.findAll();
    }

    public List<Cinema> findActiveCinemas() {
        return cinemaRepo.findByActiveTrue();
    }

    public List<Cinema> findByCity(String city) {
        return cinemaRepo.findByCity(city);
    }

    public Cinema findById(int id) {
        return cinemaRepo.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.CINEMA_NOT_FOUND));
    }

    public Cinema createCinema(Cinema cinema) {
        return cinemaRepo.save(cinema);
    }

    public Cinema updateCinema(Cinema cinema) {
        Cinema existedCinema = findById(cinema.getId());
        existedCinema.setName(cinema.getName());
        existedCinema.setAddress(cinema.getAddress());
        existedCinema.setCity(cinema.getCity());
        existedCinema.setPhone(cinema.getPhone());
        existedCinema.setEmail(cinema.getEmail());
        existedCinema.setDescription(cinema.getDescription());
        existedCinema.setImageUrl(cinema.getImageUrl());
        return cinemaRepo.save(existedCinema);
    }

    public void deleteCinema(int id) {
        Cinema cinema = findById(id);
        cinema.setActive(false);
        cinemaRepo.save(cinema);
    }

    public List<Showtime> getShowtimesByCinemaId(int cinemaId) {
        Cinema cinema = findById(cinemaId);
        List<CinemaHall> cinemaHalls = cinemaHallRepo.findByCinemaAndActiveTrue(cinema);
        List<Showtime> allShowtimes = new ArrayList<>();
        for (CinemaHall hall : cinemaHalls) {
            allShowtimes.addAll(showtimeService.findByCinemaHall(hall));
        }
        return allShowtimes;
    }

    public List<Showtime> getShowtimesByCinemaIdAndDate(int cinemaId, String dateStr) {
        LocalDate date = LocalDate.parse(dateStr);
        Cinema cinema = findById(cinemaId);
        List<CinemaHall> cinemaHalls = cinemaHallRepo.findByCinemaAndActiveTrue(cinema);
        List<Showtime> allShowtimes = new ArrayList<>();
        for (CinemaHall hall : cinemaHalls) {
            allShowtimes.addAll(showtimeService.findByCinemaHallAndDate(hall, date));
        }
        return allShowtimes;
    }
}
