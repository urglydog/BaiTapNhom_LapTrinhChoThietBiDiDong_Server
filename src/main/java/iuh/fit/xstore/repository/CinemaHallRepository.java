package iuh.fit.xstore.repository;

import iuh.fit.xstore.model.Cinema;
import iuh.fit.xstore.model.CinemaHall;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CinemaHallRepository extends JpaRepository<CinemaHall, Integer> {
    List<CinemaHall> findByCinema(Cinema cinema);

    List<CinemaHall> findByCinemaAndIsActiveTrue(Cinema cinema);
}
