-- =============================================
-- Database: Movie Ticket Booking System (MySQL/MariaDB Version)
-- Description: Database for mobile movie ticket booking app
-- Converted by: ChatGPT (MySQL Compatible)
-- =============================================

CREATE DATABASE IF NOT EXISTS movie_ticket_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE movie_ticket_db;

-- =============================================
-- Bảng Users
-- =============================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(10) CHECK (gender IN ('MALE', 'FEMALE', 'OTHER')),
    avatar_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    role VARCHAR(10) NOT NULL CHECK (role IN ('ADMIN', 'STAFF', 'CUSTOMER'))
);

-- =============================================
-- Bảng Cinemas
-- =============================================
CREATE TABLE cinemas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    description TEXT,
    image_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE
);

-- =============================================
-- Bảng Cinema Halls
-- =============================================
CREATE TABLE cinema_halls (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cinema_id INT NOT NULL,
    hall_name VARCHAR(50) NOT NULL,
    total_seats INT NOT NULL,
    seat_layout JSON,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (cinema_id) REFERENCES cinemas(id)
);

-- =============================================
-- Bảng Movies
-- =============================================
CREATE TABLE movies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL UNIQUE,
    description TEXT,
    duration INT NOT NULL,
    release_date DATE NOT NULL,
    end_date DATE,
    genre VARCHAR(100),
    director VARCHAR(100),
    cast TEXT,
    rating DECIMAL(2,1) DEFAULT 0.0,
    poster_url VARCHAR(255),
    trailer_url VARCHAR(255),
    language VARCHAR(50),
    subtitle VARCHAR(50),
    age_rating VARCHAR(10),
    is_active BOOLEAN DEFAULT TRUE
);

-- =============================================
-- Bảng Showtimes
-- =============================================
CREATE TABLE showtimes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    cinema_hall_id INT NOT NULL,
    show_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    FOREIGN KEY (cinema_hall_id) REFERENCES cinema_halls(id)
);

-- =============================================
-- Bảng Seats
-- =============================================
CREATE TABLE seats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cinema_hall_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    seat_row VARCHAR(5) NOT NULL,
    seat_type VARCHAR(10) DEFAULT 'NORMAL' CHECK (seat_type IN ('NORMAL', 'VIP', 'COUPLE')),
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (cinema_hall_id) REFERENCES cinema_halls(id),
    UNIQUE (cinema_hall_id, seat_number)
);

-- =============================================
-- Bảng Bookings
-- =============================================
CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    showtime_id INT NOT NULL,
    booking_code VARCHAR(20) NOT NULL UNIQUE,
    total_amount DECIMAL(10,2) NOT NULL,
    booking_status VARCHAR(20) DEFAULT 'PENDING' CHECK (booking_status IN ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED')),
    payment_status VARCHAR(20) DEFAULT 'PENDING' CHECK (payment_status IN ('PENDING', 'PAID', 'FAILED', 'REFUNDED')),
    payment_method VARCHAR(50),
    booking_date DATETIME DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (showtime_id) REFERENCES showtimes(id)
);

-- =============================================
-- Bảng Booking Items
-- =============================================
CREATE TABLE booking_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    seat_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(id),
    FOREIGN KEY (seat_id) REFERENCES seats(id)
);

-- =============================================
-- Bảng Reviews
-- =============================================
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    is_approved BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

-- =============================================
-- Bảng Favourites
-- =============================================
CREATE TABLE favourites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    UNIQUE (user_id, movie_id)
);

-- =============================================
-- Bảng Promotions
-- =============================================
CREATE TABLE promotions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    discount_percentage DECIMAL(5,2),
    discount_amount DECIMAL(10,2),
    min_order_amount DECIMAL(10,2),
    max_discount_amount DECIMAL(10,2),
    usage_limit INT,
    used_count INT DEFAULT 0,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- =============================================
-- Bảng User Promotions
-- =============================================
CREATE TABLE user_promotions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    promotion_id INT NOT NULL,
    used_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (promotion_id) REFERENCES promotions(id),
    UNIQUE (user_id, promotion_id)
);

-- =============================================
-- INDEXES
-- =============================================
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_movies_title ON movies(title);
CREATE INDEX idx_showtimes_movie_date ON showtimes(movie_id, show_date);
CREATE INDEX idx_showtimes_cinema_hall ON showtimes(cinema_hall_id);
CREATE INDEX idx_bookings_user ON bookings(user_id);
CREATE INDEX idx_bookings_showtime ON bookings(showtime_id);
CREATE INDEX idx_booking_items_booking ON booking_items(booking_id);
CREATE INDEX idx_seats_cinema_hall ON seats(cinema_hall_id);
CREATE INDEX idx_reviews_movie ON reviews(movie_id);
CREATE INDEX idx_favourites_user ON favourites(user_id);
