package iuh.fit.xstore.repository;

import iuh.fit.xstore.model.Cinema;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CinemaRepository extends JpaRepository<Cinema, Integer> {
    List<Cinema> findByIsActiveTrue();

    List<Cinema> findByCity(String city);
}
