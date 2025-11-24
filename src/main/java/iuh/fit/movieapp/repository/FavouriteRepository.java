package iuh.fit.movieapp.repository;

import iuh.fit.movieapp.model.Favourite;
import iuh.fit.movieapp.model.Movie;
import iuh.fit.movieapp.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FavouriteRepository extends JpaRepository<Favourite, Integer> {
    @Query("SELECT f FROM Favourite f JOIN FETCH f.movie WHERE f.user = :user")
    List<Favourite> findByUser(@Param("user") User user);

    boolean existsByUserAndMovie(User user, Movie movie);

    Optional<Favourite> findByUserAndMovie(User user, Movie movie);
}
