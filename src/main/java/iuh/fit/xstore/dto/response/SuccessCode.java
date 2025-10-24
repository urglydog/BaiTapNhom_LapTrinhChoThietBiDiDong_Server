package iuh.fit.xstore.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum SuccessCode {
    // === AUTHENTICATION ===
    LOGIN_SUCCESSFULLY(200, "Login successfully"),
    REGISTER_SUCCESSFULLY(200, "Register successfully"),
    RESET_PASSWORD_SUCCESSFULLY(200, "Reset password successfully"),

    // === USER ===
    USER_CREATED(201, "User created successfully"),
    USER_UPDATED(200, "User updated successfully"),
    USER_DELETED(200, "User deleted successfully"),

    // === MOVIE ===
    MOVIE_CREATED(201, "Movie created successfully"),
    MOVIE_UPDATED(200, "Movie updated successfully"),
    MOVIE_DELETED(200, "Movie deleted successfully"),

    // === CINEMA ===
    CINEMA_CREATED(201, "Cinema created successfully"),
    CINEMA_UPDATED(200, "Cinema updated successfully"),
    CINEMA_DELETED(200, "Cinema deleted successfully"),

    // === CINEMA HALL ===
    CINEMA_HALL_CREATED(201, "Cinema hall created successfully"),
    CINEMA_HALL_UPDATED(200, "Cinema hall updated successfully"),
    CINEMA_HALL_DELETED(200, "Cinema hall deleted successfully"),

    // === SHOWTIME ===
    SHOWTIME_CREATED(201, "Showtime created successfully"),
    SHOWTIME_UPDATED(200, "Showtime updated successfully"),
    SHOWTIME_DELETED(200, "Showtime deleted successfully"),

    // === SEAT ===
    SEAT_CREATED(201, "Seat created successfully"),
    SEAT_UPDATED(200, "Seat updated successfully"),
    SEAT_DELETED(200, "Seat deleted successfully"),

    // === BOOKING ===
    BOOKING_CREATED(201, "Booking created successfully"),
    BOOKING_UPDATED(200, "Booking updated successfully"),
    BOOKING_CANCELLED(200, "Booking cancelled successfully"),

    // === FAVOURITE ===
    FAVOURITE_CREATED(201, "Favourite created successfully"),
    FAVOURITE_DELETED(200, "Favourite deleted successfully"),

    // === REVIEW ===
    REVIEW_CREATED(201, "Review created successfully"),
    REVIEW_UPDATED(200, "Review updated successfully"),
    REVIEW_DELETED(200, "Review deleted successfully"),
    REVIEW_APPROVED(200, "Review approved successfully"),

    // === PROMOTION ===
    PROMOTION_CREATED(201, "Promotion created successfully"),
    PROMOTION_UPDATED(200, "Promotion updated successfully"),
    PROMOTION_DELETED(200, "Promotion deleted successfully"),

    // === GENERAL ===
    FETCH_SUCCESS(200, "Data fetched successfully");

    private final int code;
    private final String message;
}
