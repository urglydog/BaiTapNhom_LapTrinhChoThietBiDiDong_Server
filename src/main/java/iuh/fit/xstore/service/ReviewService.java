package iuh.fit.xstore.service;

import iuh.fit.xstore.dto.response.AppException;
import iuh.fit.xstore.dto.response.ErrorCode;
import iuh.fit.xstore.model.Movie;
import iuh.fit.xstore.model.Review;
import iuh.fit.xstore.model.User;
import iuh.fit.xstore.repository.ReviewRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ReviewService {
    private final ReviewRepository reviewRepo;

    public List<Review> findAll() {
        return reviewRepo.findAll();
    }

    public List<Review> findByMovie(Movie movie) {
        return reviewRepo.findByMovieAndIsApprovedTrue(movie);
    }

    public List<Review> findByUser(User user) {
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

    public Long getReviewCount(Movie movie) {
        return reviewRepo.countApprovedReviewsByMovie(movie);
    }
}
