package iuh.fit.movieapp.service;

import iuh.fit.movieapp.dto.response.AppException;
import iuh.fit.movieapp.dto.response.ErrorCode;
import iuh.fit.movieapp.model.Movie;
import iuh.fit.movieapp.model.Review;
import iuh.fit.movieapp.model.User;
import iuh.fit.movieapp.repository.MovieRepository;
import iuh.fit.movieapp.repository.ReviewRepository;
import iuh.fit.movieapp.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ReviewService {
    private final ReviewRepository reviewRepo;
    private final MovieRepository movieRepo;
    private final UserRepository userRepo;

    public List<Review> findAll() {
        return reviewRepo.findAll();
    }

    public List<Review> findByMovie(Movie movie) {
        return reviewRepo.findByMovieAndIsApprovedTrue(movie);
    }

    public List<Review> findByMovieId(int movieId) {
        Movie movie = movieRepo.findById(movieId)
                .orElseThrow(() -> new AppException(ErrorCode.MOVIE_NOT_FOUND));
        return reviewRepo.findByMovieAndIsApprovedTrue(movie);
    }

    public List<Review> findByUser(User user) {
        return reviewRepo.findByUser(user);
    }

    public List<Review> findByUserId(int userId) {
        User user = userRepo.findById(userId)
                .orElseThrow(() -> new AppException(ErrorCode.USER_NOT_FOUND));
        return reviewRepo.findByUser(user);
    }

    public Review findById(int id) {
        return reviewRepo.findById(id)
                .orElseThrow(() -> new AppException(ErrorCode.REVIEW_NOT_FOUND));
    }

    public Review createReview(Review review) {
        // Kiểm tra xem user đã review phim này chưa
        Optional<Review> existingReview = reviewRepo.findByUserAndMovie(review.getUser(), review.getMovie());
        if (existingReview.isPresent()) {
            throw new AppException(ErrorCode.REVIEW_ALREADY_EXISTS);
        }

        return reviewRepo.save(review);
    }

    public Review updateReview(Review review) {
        Review existedReview = findById(review.getId());
        existedReview.setRating(review.getRating());
        existedReview.setComment(review.getComment());
        return reviewRepo.save(existedReview);
    }

    public void approveReview(int id) {
        Review review = findById(id);
        review.setApproved(true);
        reviewRepo.save(review);
    }

    public void deleteReview(int id) {
        Review review = findById(id);
        reviewRepo.delete(review);
    }

    public Double getAverageRating(Movie movie) {
        return reviewRepo.findAverageRatingByMovie(movie);
    }

    public Double getAverageRatingByMovieId(int movieId) {
        Movie movie = movieRepo.findById(movieId)
                .orElseThrow(() -> new AppException(ErrorCode.MOVIE_NOT_FOUND));
        return reviewRepo.findAverageRatingByMovie(movie);
    }

    public Long getReviewCount(Movie movie) {
        return reviewRepo.countApprovedReviewsByMovie(movie);
    }

    public Long getReviewCountByMovieId(int movieId) {
        Movie movie = movieRepo.findById(movieId)
                .orElseThrow(() -> new AppException(ErrorCode.MOVIE_NOT_FOUND));
        return reviewRepo.countApprovedReviewsByMovie(movie);
    }
}
