-- =============================================
-- Database: Movie Ticket Booking System
-- Description: Database for mobile movie ticket booking app
-- Author: XStore Team
-- =============================================

-- Tạo database
CREATE DATABASE IF NOT EXISTS movie_ticket_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE movie_ticket_db;

-- =============================================
-- Bảng User Roles
-- =============================================
CREATE TABLE roles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- Bảng Users
-- =============================================
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender ENUM('MALE', 'FEMALE', 'OTHER'),
    avatar_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    role_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(id)
);

-- =============================================
-- Bảng Cinemas
-- =============================================
CREATE TABLE cinemas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    description TEXT,
    image_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- Bảng Cinema Halls
-- =============================================
CREATE TABLE cinema_halls (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cinema_id INT NOT NULL,
    hall_name VARCHAR(50) NOT NULL,
    total_seats INT NOT NULL,
    seat_layout JSON, -- Lưu layout ghế ngồi
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cinema_id) REFERENCES cinemas(id)
);

-- =============================================
-- Bảng Movies
-- =============================================
CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    duration INT NOT NULL, -- Thời lượng phim (phút)
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
    age_rating VARCHAR(10), -- PG, PG-13, R, etc.
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- Bảng Showtimes
-- =============================================
CREATE TABLE showtimes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    movie_id INT NOT NULL,
    cinema_hall_id INT NOT NULL,
    show_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    FOREIGN KEY (cinema_hall_id) REFERENCES cinema_halls(id)
);

-- =============================================
-- Bảng Seats
-- =============================================
CREATE TABLE seats (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cinema_hall_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    seat_row VARCHAR(5) NOT NULL,
    seat_type ENUM('NORMAL', 'VIP', 'COUPLE') DEFAULT 'NORMAL',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (cinema_hall_id) REFERENCES cinema_halls(id),
    UNIQUE KEY unique_seat (cinema_hall_id, seat_number)
);

-- =============================================
-- Bảng Bookings
-- =============================================
CREATE TABLE bookings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    showtime_id INT NOT NULL,
    booking_code VARCHAR(20) NOT NULL UNIQUE,
    total_amount DECIMAL(10,2) NOT NULL,
    booking_status ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING',
    payment_status ENUM('PENDING', 'PAID', 'FAILED', 'REFUNDED') DEFAULT 'PENDING',
    payment_method VARCHAR(50),
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (showtime_id) REFERENCES showtimes(id)
);

-- =============================================
-- Bảng Booking Items (Chi tiết vé đã đặt)
-- =============================================
CREATE TABLE booking_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    seat_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id),
    FOREIGN KEY (seat_id) REFERENCES seats(id)
);

-- =============================================
-- Bảng Promotions
-- =============================================
CREATE TABLE promotions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    discount_type ENUM('PERCENTAGE', 'FIXED_AMOUNT') NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    min_amount DECIMAL(10,2) DEFAULT 0,
    max_discount DECIMAL(10,2),
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    usage_limit INT,
    used_count INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- Bảng User Promotions (Mã giảm giá của user)
-- =============================================
CREATE TABLE user_promotions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    promotion_id INT NOT NULL,
    used_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (promotion_id) REFERENCES promotions(id)
);

-- =============================================
-- Bảng Reviews
-- =============================================
CREATE TABLE reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    is_approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

-- =============================================
-- Bảng Favourites
-- =============================================
CREATE TABLE favourites (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    UNIQUE KEY unique_favourite (user_id, movie_id)
);

-- =============================================
-- INSERT DỮ LIỆU MẪU
-- =============================================

-- Insert Roles
INSERT INTO roles (name, description) VALUES
('ADMIN', 'Quản trị viên hệ thống'),
('STAFF', 'Nhân viên rạp chiếu phim'),
('CUSTOMER', 'Khách hàng');

-- Insert Users
INSERT INTO users (username, email, password, full_name, phone, date_of_birth, gender, role_id) VALUES
('admin', 'admin@movieticket.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'Admin System', '0123456789', '1990-01-01', 'MALE', 1),
('staff1', 'staff1@movieticket.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'Nguyễn Văn A', '0987654321', '1995-05-15', 'MALE', 2),
('customer1', 'customer1@gmail.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'Trần Thị B', '0912345678', '1998-08-20', 'FEMALE', 3),
('customer2', 'customer2@gmail.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'Lê Văn C', '0923456789', '1992-12-10', 'MALE', 3);

-- Insert Cinemas
INSERT INTO cinemas (name, address, city, phone, email, description) VALUES
('CGV Vincom Center', '72 Lê Thánh Tôn, Quận 1, TP.HCM', 'Ho Chi Minh City', '1900 6017', 'cgv@cgv.vn', 'Rạp chiếu phim hiện đại với công nghệ IMAX'),
('Lotte Cinema Diamond Plaza', '34 Lê Duẩn, Quận 1, TP.HCM', 'Ho Chi Minh City', '1900 1533', 'lotte@lotte.vn', 'Rạp chiếu phim cao cấp với ghế VIP'),
('Galaxy Cinema Nguyễn Du', '116 Nguyễn Du, Quận 1, TP.HCM', 'Ho Chi Minh City', '1900 2224', 'galaxy@galaxy.vn', 'Rạp chiếu phim với nhiều phòng chiếu'),
('BHD Star Cineplex', '59A Lý Tự Trọng, Quận 1, TP.HCM', 'Ho Chi Minh City', '1900 6363', 'bhd@bhd.vn', 'Rạp chiếu phim với công nghệ 4DX');

-- Insert Cinema Halls
INSERT INTO cinema_halls (cinema_id, hall_name, total_seats) VALUES
(1, 'Phòng 1 - IMAX', 200),
(1, 'Phòng 2 - Standard', 150),
(1, 'Phòng 3 - VIP', 100),
(2, 'Phòng 1 - Standard', 180),
(2, 'Phòng 2 - VIP', 80),
(3, 'Phòng 1 - Standard', 160),
(3, 'Phòng 2 - Standard', 140),
(4, 'Phòng 1 - 4DX', 120);

-- Insert Movies
INSERT INTO movies (title, description, duration, release_date, end_date, genre, director, cast, rating, language, subtitle, age_rating) VALUES
('Avatar: The Way of Water', 'Jake Sully và gia đình của anh ấy khám phá những vùng biển của Pandora và gặp gỡ những sinh vật biển kỳ lạ.', 192, '2022-12-16', '2023-03-16', 'Sci-Fi, Action', 'James Cameron', 'Sam Worthington, Zoe Saldana, Sigourney Weaver', 8.5, 'English', 'Vietnamese', 'PG-13'),
('Black Panther: Wakanda Forever', 'Sau cái chết của Vua T\'Challa, Wakanda phải đối mặt với những thách thức mới.', 161, '2022-11-11', '2023-02-11', 'Action, Adventure', 'Ryan Coogler', 'Letitia Wright, Angela Bassett, Lupita Nyong\'o', 7.8, 'English', 'Vietnamese', 'PG-13'),
('Top Gun: Maverick', 'Pete "Maverick" Mitchell trở lại với nhiệm vụ nguy hiểm nhất trong sự nghiệp của mình.', 131, '2022-05-27', '2023-01-27', 'Action, Drama', 'Joseph Kosinski', 'Tom Cruise, Miles Teller, Jennifer Connelly', 8.9, 'English', 'Vietnamese', 'PG-13'),
('Spider-Man: No Way Home', 'Peter Parker cần sự giúp đỡ của Doctor Strange để che giấu danh tính của mình.', 148, '2021-12-17', '2022-06-17', 'Action, Adventure', 'Jon Watts', 'Tom Holland, Zendaya, Benedict Cumberbatch', 8.7, 'English', 'Vietnamese', 'PG-13'),
('The Batman', 'Khi một kẻ giết người hàng loạt bắt đầu tàn sát giới thượng lưu của Gotham, Batman phải điều tra.', 176, '2022-03-04', '2022-09-04', 'Action, Crime', 'Matt Reeves', 'Robert Pattinson, Zoë Kravitz, Paul Dano', 8.2, 'English', 'Vietnamese', 'PG-13');

-- Insert Showtimes
INSERT INTO showtimes (movie_id, cinema_hall_id, show_date, start_time, end_time, price) VALUES
(1, 1, '2023-01-15', '09:00:00', '12:12:00', 120000),
(1, 1, '2023-01-15', '13:00:00', '16:12:00', 120000),
(1, 1, '2023-01-15', '17:00:00', '20:12:00', 120000),
(2, 2, '2023-01-15', '10:00:00', '12:41:00', 100000),
(2, 2, '2023-01-15', '14:00:00', '16:41:00', 100000),
(3, 3, '2023-01-15', '11:00:00', '13:11:00', 150000),
(4, 4, '2023-01-15', '15:00:00', '17:28:00', 110000),
(5, 5, '2023-01-15', '19:00:00', '21:56:00', 130000);

-- Insert Seats (tạo ghế cho phòng 1)
INSERT INTO seats (cinema_hall_id, seat_number, seat_row, seat_type) VALUES
-- Phòng 1 - 10 hàng, 20 ghế/hàng
(1, 'A1', 'A', 'NORMAL'), (1, 'A2', 'A', 'NORMAL'), (1, 'A3', 'A', 'NORMAL'), (1, 'A4', 'A', 'NORMAL'), (1, 'A5', 'A', 'NORMAL'),
(1, 'A6', 'A', 'NORMAL'), (1, 'A7', 'A', 'NORMAL'), (1, 'A8', 'A', 'NORMAL'), (1, 'A9', 'A', 'NORMAL'), (1, 'A10', 'A', 'NORMAL'),
(1, 'A11', 'A', 'NORMAL'), (1, 'A12', 'A', 'NORMAL'), (1, 'A13', 'A', 'NORMAL'), (1, 'A14', 'A', 'NORMAL'), (1, 'A15', 'A', 'NORMAL'),
(1, 'A16', 'A', 'NORMAL'), (1, 'A17', 'A', 'NORMAL'), (1, 'A18', 'A', 'NORMAL'), (1, 'A19', 'A', 'NORMAL'), (1, 'A20', 'A', 'NORMAL'),

(1, 'B1', 'B', 'NORMAL'), (1, 'B2', 'B', 'NORMAL'), (1, 'B3', 'B', 'NORMAL'), (1, 'B4', 'B', 'NORMAL'), (1, 'B5', 'B', 'NORMAL'),
(1, 'B6', 'B', 'NORMAL'), (1, 'B7', 'B', 'NORMAL'), (1, 'B8', 'B', 'NORMAL'), (1, 'B9', 'B', 'NORMAL'), (1, 'B10', 'B', 'NORMAL'),
(1, 'B11', 'B', 'NORMAL'), (1, 'B12', 'B', 'NORMAL'), (1, 'B13', 'B', 'NORMAL'), (1, 'B14', 'B', 'NORMAL'), (1, 'B15', 'B', 'NORMAL'),
(1, 'B16', 'B', 'NORMAL'), (1, 'B17', 'B', 'NORMAL'), (1, 'B18', 'B', 'NORMAL'), (1, 'B19', 'B', 'NORMAL'), (1, 'B20', 'B', 'NORMAL'),

(1, 'C1', 'C', 'VIP'), (1, 'C2', 'C', 'VIP'), (1, 'C3', 'C', 'VIP'), (1, 'C4', 'C', 'VIP'), (1, 'C5', 'C', 'VIP'),
(1, 'C6', 'C', 'VIP'), (1, 'C7', 'C', 'VIP'), (1, 'C8', 'C', 'VIP'), (1, 'C9', 'C', 'VIP'), (1, 'C10', 'C', 'VIP'),
(1, 'C11', 'C', 'VIP'), (1, 'C12', 'C', 'VIP'), (1, 'C13', 'C', 'VIP'), (1, 'C14', 'C', 'VIP'), (1, 'C15', 'C', 'VIP'),
(1, 'C16', 'C', 'VIP'), (1, 'C17', 'C', 'VIP'), (1, 'C18', 'C', 'VIP'), (1, 'C19', 'C', 'VIP'), (1, 'C20', 'C', 'VIP');

-- Insert Promotions
INSERT INTO promotions (name, description, discount_type, discount_value, min_amount, max_discount, start_date, end_date, usage_limit) VALUES
('Giảm giá 20% cho khách hàng mới', 'Áp dụng cho đơn hàng đầu tiên', 'PERCENTAGE', 20.00, 0, 50000, '2023-01-01 00:00:00', '2023-12-31 23:59:59', 1000),
('Giảm 50k cho đơn từ 200k', 'Áp dụng cho đơn hàng từ 200k trở lên', 'FIXED_AMOUNT', 50000, 200000, 50000, '2023-01-01 00:00:00', '2023-12-31 23:59:59', 500),
('Combo 2 vé giảm 10%', 'Mua 2 vé cùng lúc được giảm 10%', 'PERCENTAGE', 10.00, 0, 30000, '2023-01-01 00:00:00', '2023-12-31 23:59:59', 200);

-- Insert User Promotions
INSERT INTO user_promotions (user_id, promotion_id) VALUES
(3, 1), (4, 1), (3, 2), (4, 2);

-- Insert Reviews
INSERT INTO reviews (user_id, movie_id, rating, comment, is_approved) VALUES
(3, 1, 5, 'Phim hay tuyệt vời! Hiệu ứng đẹp mắt.', TRUE),
(4, 1, 4, 'Tốt nhưng hơi dài.', TRUE),
(3, 2, 4, 'Phim hay, diễn viên đóng tốt.', TRUE),
(4, 3, 5, 'Phim hành động hay nhất năm!', TRUE);

-- Insert Favourites
INSERT INTO favourites (user_id, movie_id) VALUES
(3, 1), (3, 2), (4, 1), (4, 3);

-- Insert sample bookings
INSERT INTO bookings (user_id, showtime_id, booking_code, total_amount, booking_status, payment_status, payment_method) VALUES
(3, 1, 'BK001', 240000, 'CONFIRMED', 'PAID', 'MOMO'),
(4, 2, 'BK002', 200000, 'CONFIRMED', 'PAID', 'BANKING');

-- Insert booking items
INSERT INTO booking_items (booking_id, seat_id, price) VALUES
(1, 1, 120000), (1, 2, 120000),
(2, 21, 100000), (2, 22, 100000);

-- =============================================
-- Tạo Indexes để tối ưu performance
-- =============================================
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_showtimes_movie_date ON showtimes(movie_id, show_date);
CREATE INDEX idx_showtimes_cinema_hall ON showtimes(cinema_hall_id);
CREATE INDEX idx_bookings_user ON bookings(user_id);
CREATE INDEX idx_bookings_showtime ON bookings(showtime_id);
CREATE INDEX idx_booking_items_booking ON booking_items(booking_id);
CREATE INDEX idx_seats_cinema_hall ON seats(cinema_hall_id);
CREATE INDEX idx_reviews_movie ON reviews(movie_id);
CREATE INDEX idx_favourites_user ON favourites(user_id);