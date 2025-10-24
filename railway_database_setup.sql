-- =============================================
-- Railway Database Setup Script
-- Tối ưu cho Railway SQL Server
-- =============================================

-- Railway đã tạo database, chỉ cần tạo tables và data
-- Không cần CREATE DATABASE

-- =============================================
-- Bảng Users
-- =============================================
CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    date_of_birth DATE,
    gender NVARCHAR(10) CHECK (gender IN ('MALE', 'FEMALE', 'OTHER')),
    avatar_url NVARCHAR(255),
    is_active BIT DEFAULT 1,
    role NVARCHAR(10) NOT NULL CHECK (role IN ('ADMIN', 'STAFF', 'CUSTOMER'))
);

-- =============================================
-- Bảng Cinemas
-- =============================================
CREATE TABLE cinemas (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    address NVARCHAR(MAX) NOT NULL,
    city NVARCHAR(50) NOT NULL,
    phone NVARCHAR(20),
    email NVARCHAR(100),
    description NVARCHAR(MAX),
    image_url NVARCHAR(255),
    is_active BIT DEFAULT 1
);

-- =============================================
-- Bảng Cinema Halls
-- =============================================
CREATE TABLE cinema_halls (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cinema_id INT NOT NULL,
    hall_name NVARCHAR(50) NOT NULL,
    total_seats INT NOT NULL,
    seat_layout NVARCHAR(MAX), -- JSON data
    is_active BIT DEFAULT 1,
    FOREIGN KEY (cinema_id) REFERENCES cinemas(id)
);

-- =============================================
-- Bảng Movies
-- =============================================
CREATE TABLE movies (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(200) NOT NULL,
    description NVARCHAR(MAX),
    duration INT NOT NULL, -- Thời lượng phim (phút)
    release_date DATE NOT NULL,
    end_date DATE,
    genre NVARCHAR(100),
    director NVARCHAR(100),
    cast NVARCHAR(MAX),
    rating DECIMAL(2,1) DEFAULT 0.0,
    poster_url NVARCHAR(255),
    trailer_url NVARCHAR(255),
    language NVARCHAR(50),
    subtitle NVARCHAR(50),
    age_rating NVARCHAR(10), -- PG, PG-13, R, etc.
    is_active BIT DEFAULT 1
);

-- =============================================
-- Bảng Showtimes
-- =============================================
CREATE TABLE showtimes (
    id INT IDENTITY(1,1) PRIMARY KEY,
    movie_id INT NOT NULL,
    cinema_hall_id INT NOT NULL,
    show_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    is_active BIT DEFAULT 1,
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    FOREIGN KEY (cinema_hall_id) REFERENCES cinema_halls(id)
);

-- =============================================
-- Bảng Seats
-- =============================================
CREATE TABLE seats (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cinema_hall_id INT NOT NULL,
    seat_number NVARCHAR(10) NOT NULL,
    seat_row NVARCHAR(5) NOT NULL,
    seat_type NVARCHAR(10) DEFAULT 'NORMAL' CHECK (seat_type IN ('NORMAL', 'VIP', 'COUPLE')),
    is_active BIT DEFAULT 1,
    FOREIGN KEY (cinema_hall_id) REFERENCES cinema_halls(id),
    UNIQUE (cinema_hall_id, seat_number)
);

-- =============================================
-- Bảng Bookings
-- =============================================
CREATE TABLE bookings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    showtime_id INT NOT NULL,
    booking_code NVARCHAR(20) NOT NULL UNIQUE,
    total_amount DECIMAL(10,2) NOT NULL,
    booking_status NVARCHAR(20) DEFAULT 'PENDING' CHECK (booking_status IN ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED')),
    payment_status NVARCHAR(20) DEFAULT 'PENDING' CHECK (payment_status IN ('PENDING', 'PAID', 'FAILED', 'REFUNDED')),
    payment_method NVARCHAR(50),
    booking_date DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (showtime_id) REFERENCES showtimes(id)
);

-- =============================================
-- Bảng Booking Items
-- =============================================
CREATE TABLE booking_items (
    id INT IDENTITY(1,1) PRIMARY KEY,
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
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    movie_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment NVARCHAR(MAX),
    is_approved BIT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

-- =============================================
-- Bảng Favourites
-- =============================================
CREATE TABLE favourites (
    id INT IDENTITY(1,1) PRIMARY KEY,
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
    id INT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(20) NOT NULL UNIQUE,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    discount_percentage DECIMAL(5,2),
    discount_amount DECIMAL(10,2),
    min_order_amount DECIMAL(10,2),
    max_discount_amount DECIMAL(10,2),
    usage_limit INT,
    used_count INT DEFAULT 0,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BIT DEFAULT 1
);

-- =============================================
-- Bảng User Promotions
-- =============================================
CREATE TABLE user_promotions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    promotion_id INT NOT NULL,
    used_at DATETIME2,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (promotion_id) REFERENCES promotions(id),
    UNIQUE (user_id, promotion_id)
);

-- =============================================
-- INSERT DỮ LIỆU MẪU
-- =============================================

-- Insert Users
INSERT INTO users (username, email, password, full_name, phone, date_of_birth, gender, role) VALUES
(N'admin', N'admin@movieticket.com', N'$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', N'Admin System', N'0123456789', '1990-01-01', N'MALE', N'ADMIN'),
(N'staff1', N'staff1@movieticket.com', N'$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', N'Nguyễn Văn A', N'0987654321', '1995-05-15', N'MALE', N'STAFF'),
(N'customer1', N'customer1@gmail.com', N'$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', N'Trần Thị B', N'0912345678', '1998-08-20', N'FEMALE', N'CUSTOMER'),
(N'customer2', N'customer2@gmail.com', N'$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', N'Lê Văn C', N'0923456789', '1992-12-10', N'MALE', N'CUSTOMER');

-- Insert Cinemas
INSERT INTO cinemas (name, address, city, phone, email, description) VALUES
(N'CGV Vincom Center', N'72 Lê Thánh Tôn, Quận 1, TP.HCM', N'Ho Chi Minh City', N'1900 6017', N'cgv@cgv.vn', N'Rạp chiếu phim hiện đại với công nghệ IMAX'),
(N'Lotte Cinema Diamond Plaza', N'34 Lê Duẩn, Quận 1, TP.HCM', N'Ho Chi Minh City', N'1900 1533', N'lotte@lotte.vn', N'Rạp chiếu phim cao cấp với ghế VIP'),
(N'Galaxy Cinema Nguyễn Du', N'116 Nguyễn Du, Quận 1, TP.HCM', N'Ho Chi Minh City', N'1900 2224', N'galaxy@galaxy.vn', N'Rạp chiếu phim với nhiều phòng chiếu'),
(N'BHD Star Cineplex', N'59A Lý Tự Trọng, Quận 1, TP.HCM', N'Ho Chi Minh City', N'1900 6363', N'bhd@bhd.vn', N'Rạp chiếu phim với công nghệ 4DX');

-- Insert Cinema Halls
INSERT INTO cinema_halls (cinema_id, hall_name, total_seats) VALUES
(1, N'Phòng 1 - IMAX', 200),
(1, N'Phòng 2 - Standard', 150),
(1, N'Phòng 3 - VIP', 100),
(2, N'Phòng 1 - Standard', 180),
(2, N'Phòng 2 - VIP', 80),
(3, N'Phòng 1 - Standard', 160),
(3, N'Phòng 2 - Standard', 140),
(4, N'Phòng 1 - 4DX', 120);

-- Insert Movies
INSERT INTO movies (title, description, duration, release_date, end_date, genre, director, cast, rating, language, subtitle, age_rating) VALUES
(N'Avatar: The Way of Water', N'Jake Sully và gia đình của anh ấy khám phá những vùng biển của Pandora và gặp gỡ những sinh vật biển kỳ lạ.', 192, '2022-12-16', '2023-03-16', N'Sci-Fi, Action', N'James Cameron', N'Sam Worthington, Zoe Saldana, Sigourney Weaver', 8.5, N'English', N'Vietnamese', N'PG-13'),
(N'Black Panther: Wakanda Forever', N'Sau cái chết của Vua T''Challa, Wakanda phải đối mặt với những thách thức mới.', 161, '2022-11-11', '2023-02-11', N'Action, Adventure', N'Ryan Coogler', N'Letitia Wright, Angela Bassett, Lupita Nyong''o', 7.8, N'English', N'Vietnamese', N'PG-13'),
(N'Top Gun: Maverick', N'Pete "Maverick" Mitchell trở lại với nhiệm vụ nguy hiểm nhất trong sự nghiệp của mình.', 131, '2022-05-27', '2023-01-27', N'Action, Drama', N'Joseph Kosinski', N'Tom Cruise, Miles Teller, Jennifer Connelly', 8.9, N'English', N'Vietnamese', N'PG-13'),
(N'Spider-Man: No Way Home', N'Peter Parker cần sự giúp đỡ của Doctor Strange để che giấu danh tính của mình.', 148, '2021-12-17', '2022-06-17', N'Action, Adventure', N'Jon Watts', N'Tom Holland, Zendaya, Benedict Cumberbatch', 8.7, N'English', N'Vietnamese', N'PG-13'),
(N'The Batman', N'Khi một kẻ giết người hàng loạt bắt đầu tàn sát giới thượng lưu của Gotham, Batman phải điều tra.', 176, '2022-03-04', '2022-09-04', N'Action, Crime', N'Matt Reeves', N'Robert Pattinson, Zoë Kravitz, Paul Dano', 8.2, N'English', N'Vietnamese', N'PG-13');

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
(1, N'A1', N'A', N'NORMAL'), (1, N'A2', N'A', N'NORMAL'), (1, N'A3', N'A', N'NORMAL'), (1, N'A4', N'A', N'NORMAL'), (1, N'A5', N'A', N'NORMAL'),
(1, N'A6', N'A', N'NORMAL'), (1, N'A7', N'A', N'NORMAL'), (1, N'A8', N'A', N'NORMAL'), (1, N'A9', N'A', N'NORMAL'), (1, N'A10', N'A', N'NORMAL'),
(1, N'A11', N'A', N'NORMAL'), (1, N'A12', N'A', N'NORMAL'), (1, N'A13', N'A', N'NORMAL'), (1, N'A14', N'A', N'NORMAL'), (1, N'A15', N'A', N'NORMAL'),
(1, N'A16', N'A', N'NORMAL'), (1, N'A17', N'A', N'NORMAL'), (1, N'A18', N'A', N'NORMAL'), (1, N'A19', N'A', N'NORMAL'), (1, N'A20', N'A', N'NORMAL'),

(1, N'B1', N'B', N'NORMAL'), (1, N'B2', N'B', N'NORMAL'), (1, N'B3', N'B', N'NORMAL'), (1, N'B4', N'B', N'NORMAL'), (1, N'B5', N'B', N'NORMAL'),
(1, N'B6', N'B', N'NORMAL'), (1, N'B7', N'B', N'NORMAL'), (1, N'B8', N'B', N'NORMAL'), (1, N'B9', N'B', N'NORMAL'), (1, N'B10', N'B', N'NORMAL'),
(1, N'B11', N'B', N'NORMAL'), (1, N'B12', N'B', N'NORMAL'), (1, N'B13', N'B', N'NORMAL'), (1, N'B14', N'B', N'NORMAL'), (1, N'B15', N'B', N'NORMAL'),
(1, N'B16', N'B', N'NORMAL'), (1, N'B17', N'B', N'NORMAL'), (1, N'B18', N'B', N'NORMAL'), (1, N'B19', N'B', N'NORMAL'), (1, N'B20', N'B', N'NORMAL'),

(1, N'C1', N'C', N'VIP'), (1, N'C2', N'C', N'VIP'), (1, N'C3', N'C', N'VIP'), (1, N'C4', N'C', N'VIP'), (1, N'C5', N'C', N'VIP'),
(1, N'C6', N'C', N'VIP'), (1, N'C7', N'C', N'VIP'), (1, N'C8', N'C', N'VIP'), (1, N'C9', N'C', N'VIP'), (1, N'C10', N'C', N'VIP'),
(1, N'C11', N'C', N'VIP'), (1, N'C12', N'C', N'VIP'), (1, N'C13', N'C', N'VIP'), (1, N'C14', N'C', N'VIP'), (1, N'C15', N'C', N'VIP'),
(1, N'C16', N'C', N'VIP'), (1, N'C17', N'C', N'VIP'), (1, N'C18', N'C', N'VIP'), (1, N'C19', N'C', N'VIP'), (1, N'C20', N'C', N'VIP');

-- =============================================
-- Tạo Indexes
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

PRINT 'Database setup completed successfully!';
