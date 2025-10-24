package iuh.fit.xstore.repository;

import iuh.fit.xstore.model.Favourite;
import iuh.fit.xstore.model.Movie;
import iuh.fit.xstore.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FavouriteRepository extends JpaRepository<Favourite, Integer> {
    List<Favourite> findByUser(User user);

    boolean existsByUserAndMovie(User user, Movie movie);

    Optional<Favourite> findByUserAndMovie(User user, Movie movie);
}
