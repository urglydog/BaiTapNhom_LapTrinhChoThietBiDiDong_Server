package iuh.fit.movieapp.repository;

import iuh.fit.movieapp.model.Cinema;
import iuh.fit.movieapp.model.CinemaHall;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CinemaHallRepository extends JpaRepository<CinemaHall, Integer> {
    List<CinemaHall> findByCinema(Cinema cinema);

    List<CinemaHall> findByCinemaAndActiveTrue(Cinema cinema);
}
