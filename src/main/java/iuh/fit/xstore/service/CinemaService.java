package iuh.fit.xstore.service;

import iuh.fit.xstore.dto.response.AppException;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.model.Cinema;
import iuh.fit.xstore.repository.CinemaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CinemaService {
    private final CinemaRepository cinemaRepo;

    public List<Cinema> findAll() {
        return cinemaRepo.findAll();
    }

    public List<Cinema> findActiveCinemas() {
        return cinemaRepo.findByIsActiveTrue();
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
}
