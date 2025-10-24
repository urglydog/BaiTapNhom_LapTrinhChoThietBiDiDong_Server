package iuh.fit.xstore.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;

@AllArgsConstructor
@Getter
public enum ErrorCode {
    // === USER ===
    USER_NOT_FOUND(404, "User not found"),
    USER_EXISTED(409, "User already exists"),
    USERNAME_NOT_FOUND(404, "Username not found"),
    USERNAME_EXISTED(409, "Username already exists"),
    EMAIL_EXISTED(409, "Email already exists"),
    PASSWORD_EMPTY(400, "Password cannot be empty"),
    INVALID_PASSWORD(401, "Invalid password"),
    INCORRECT_USERNAME_OR_PASSWORD(401, "Incorrect username or password"),

    // === MOVIE ===
    MOVIE_NOT_FOUND(404, "Movie not found"),
    MOVIE_EXISTED(409, "Movie already exists"),

    // === CINEMA ===
    CINEMA_NOT_FOUND(404, "Cinema not found"),
    CINEMA_EXISTED(409, "Cinema already exists"),

    // === CINEMA HALL ===
    CINEMA_HALL_NOT_FOUND(404, "Cinema hall not found"),
    CINEMA_HALL_EXISTED(409, "Cinema hall already exists"),

    // === SHOWTIME ===
    SHOWTIME_NOT_FOUND(404, "Showtime not found"),
    SHOWTIME_EXISTED(409, "Showtime already exists"),

    // === SEAT ===
    SEAT_NOT_FOUND(404, "Seat not found"),
    SEAT_EXISTED(409, "Seat already exists"),
    SEAT_ALREADY_BOOKED(409, "Seat already booked"),

    // === BOOKING ===
    BOOKING_NOT_FOUND(404, "Booking not found"),
    BOOKING_EXISTED(409, "Booking already exists"),
    BOOKING_CANCELLED(409, "Booking already cancelled"),

    // === FAVOURITE ===
    FAVOURITE_EXISTED(409, "Favorite already exists"),
    FAVOURITE_NOT_FOUND(404, "Favorite not found"),

    // === REVIEW ===
    REVIEW_NOT_FOUND(404, "Review not found"),
    REVIEW_ALREADY_EXISTS(409, "Review already exists"),

    // === PROMOTION ===
    PROMOTION_NOT_FOUND(404, "Promotion not found"),
    PROMOTION_EXPIRED(409, "Promotion has expired"),
    PROMOTION_USAGE_LIMIT_EXCEEDED(409, "Promotion usage limit exceeded"),

    // === GENERAL ===
    TOKEN_EXPIRED(403, "Token has expired"),
    UNAUTHORIZED(401, "Unauthorized access"),
    FORBIDDEN(403, "Access forbidden"),
    UNKNOWN_ERROR(500, "Something went wrong");

    private final int code;
    private final String message;
}
