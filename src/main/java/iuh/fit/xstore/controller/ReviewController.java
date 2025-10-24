package iuh.fit.xstore.controller;

import iuh.fit.xstore.dto.response.ApiResponse;
import iuh.fit.xstore.dto.response.SuccessCode;
import iuh.fit.xstore.model.Review;
import iuh.fit.xstore.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reviews")
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;

    @GetMapping
    public ApiResponse<List<Review>> getAllReviews() {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, reviewService.findAll());
    }

    @GetMapping("/movie/{movieId}")
    public ApiResponse<List<Review>> getReviewsByMovie(@PathVariable int movieId) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, reviewService.findByMovie(null)); // Cần truyền Movie object
    }

    @GetMapping("/user/{userId}")
    public ApiResponse<List<Review>> getReviewsByUser(@PathVariable int userId) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, reviewService.findByUser(null)); // Cần truyền User object
    }

    @GetMapping("/{id}")
    public ApiResponse<Review> getReview(@PathVariable int id) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, reviewService.findById(id));
    }

    @PostMapping
    public ApiResponse<Review> createReview(@RequestBody Review review) {
        Review createdReview = reviewService.createReview(review);
        return new ApiResponse<>(SuccessCode.REVIEW_CREATED, createdReview);
    }

    @PutMapping("/{id}")
    public ApiResponse<Review> updateReview(@PathVariable int id, @RequestBody Review review) {
        review.setId(id);
        Review updatedReview = reviewService.updateReview(review);
        return new ApiResponse<>(SuccessCode.REVIEW_UPDATED, updatedReview);
    }

    @PutMapping("/{id}/approve")
    @PreAuthorize("hasRole('ADMIN') or hasRole('STAFF')")
    public ApiResponse<Void> approveReview(@PathVariable int id) {
        reviewService.approveReview(id);
        return new ApiResponse<>(SuccessCode.REVIEW_APPROVED, null);
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Void> deleteReview(@PathVariable int id) {
        reviewService.deleteReview(id);
        return new ApiResponse<>(SuccessCode.REVIEW_DELETED, null);
    }

    @GetMapping("/movie/{movieId}/rating")
    public ApiResponse<Double> getAverageRating(@PathVariable int movieId) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, reviewService.getAverageRating(null)); // Cần truyền Movie
                                                                                                   // object
    }

    @GetMapping("/movie/{movieId}/count")
    public ApiResponse<Long> getReviewCount(@PathVariable int movieId) {
        return new ApiResponse<>(SuccessCode.FETCH_SUCCESS, reviewService.getReviewCount(null)); // Cần truyền Movie
                                                                                                 // object
    }
}
