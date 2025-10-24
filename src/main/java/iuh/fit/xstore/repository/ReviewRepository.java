package iuh.fit.xstore.repository;

import iuh.fit.xstore.model.Movie;
import iuh.fit.xstore.model.Review;
import iuh.fit.xstore.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Integer> {
    List<Review> findByMovie(Movie movie);

    List<Review> findByUser(User user);

    List<Review> findByMovieAndIsApprovedTrue(Movie movie);

    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.movie = :movie AND r.isApproved = true")
    Double findAverageRatingByMovie(@Param("movie") Movie movie);

    @Query("SELECT COUNT(r) FROM Review r WHERE r.movie = :movie AND r.isApproved = true")
    Long countApprovedReviewsByMovie(@Param("movie") Movie movie);

    Optional<Review> findByUserAndMovie(User user, Movie movie);
}
