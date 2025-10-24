package iuh.fit.xstore.repository;

import iuh.fit.xstore.model.Movie;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface MovieRepository extends JpaRepository<Movie, Integer> {
    List<Movie> findByIsActiveTrue();

    List<Movie> findByGenre(String genre);

    List<Movie> findByReleaseDateBetween(LocalDate startDate, LocalDate endDate);

    @Query("SELECT m FROM Movie m WHERE m.isActive = true AND m.releaseDate <= :currentDate AND (m.endDate IS NULL OR m.endDate >= :currentDate)")
    List<Movie> findCurrentlyShowingMovies(@Param("currentDate") LocalDate currentDate);

    @Query("SELECT m FROM Movie m WHERE m.isActive = true AND m.releaseDate > :currentDate")
    List<Movie> findUpcomingMovies(@Param("currentDate") LocalDate currentDate);
}
