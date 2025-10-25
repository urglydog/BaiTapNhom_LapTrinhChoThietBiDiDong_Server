-- Set UTF-8 encoding
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

INSERT INTO users (username, email, password, full_name, phone, date_of_birth, gender, role)
VALUES ('admin', 'admin@movieticket.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi',
        'Admin System', '0123456789', '1990-01-01', 'MALE', 'ADMIN'),
       ('staff1', 'staff1@movieticket.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi',
        'Nguyen Van A', '0987654321', '1995-05-15', 'MALE', 'STAFF'),
       ('customer1', 'customer1@gmail.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi',
        'Tran Thi B', '0912345678', '1998-08-20', 'FEMALE', 'CUSTOMER'),
       ('customer2', 'customer2@gmail.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDi', 'Le Van C',
        '0923456789', '1992-12-10', 'MALE', 'CUSTOMER');

-- =============================================
-- Insert Cinemas
-- =============================================
INSERT INTO cinemas (name, address, city, phone, email, description, image_url)
VALUES ('CGV Vincom Center', '72 Le Thanh Ton, Quan 1, TP.HCM', 'Ho Chi Minh City', '1900 6017', 'cgv@cgv.vn',
        'Rap chieu phim hien dai voi cong nghe IMAX', 'https://images.unsplash.com/photo-1489599808427-5a6b3b3b3b3b?w=800'),
       ('Lotte Cinema Diamond Plaza', '34 Le Duan, Quan 1, TP.HCM', 'Ho Chi Minh City', '1900 1533', 'lotte@lotte.vn',
        'Rap chieu phim cao cap voi ghe VIP', 'https://images.unsplash.com/photo-1489599808427-5a6b3b3b3b3b?w=800'),
       ('Galaxy Cinema Nguyen Du', '116 Nguyen Du, Quan 1, TP.HCM', 'Ho Chi Minh City', '1900 2224', 'galaxy@galaxy.vn',
        'Rap chieu phim voi nhieu phong chieu', 'https://images.unsplash.com/photo-1489599808427-5a6b3b3b3b3b?w=800'),
       ('BHD Star Cineplex', '59A Ly Tu Trong, Quan 1, TP.HCM', 'Ho Chi Minh City', '1900 6363', 'bhd@bhd.vn',
        'Rap chieu phim voi cong nghe 4DX', 'https://images.unsplash.com/photo-1489599808427-5a6b3b3b3b3b?w=800');

-- =============================================
-- Insert Cinema Halls
-- =============================================
INSERT INTO cinema_halls (cinema_id, hall_name, total_seats)
VALUES (1, 'Phong 1 - IMAX', 200),
       (1, 'Phong 2 - Standard', 150),
       (1, 'Phong 3 - VIP', 100),
       (2, 'Phong 1 - Standard', 180),
       (2, 'Phong 2 - VIP', 80),
       (3, 'Phong 1 - Standard', 160),
       (3, 'Phong 2 - Standard', 140),
       (4, 'Phong 1 - 4DX', 120);

-- =============================================
-- Insert Movies
-- =============================================
INSERT INTO movies (title, description, duration, release_date, end_date, genre, director, cast, rating, language,
                    subtitle, age_rating, poster_url, trailer_url)
VALUES ('Avatar: The Way of Water',
        'Jake Sully va gia dinh cua anh ay kham pha nhung vung bien cua Pandora va gap go nhung sinh vat bien ky la.',
        192, '2022-12-16', '2023-03-16', 'Sci-Fi, Action', 'James Cameron',
        'Sam Worthington, Zoe Saldana, Sigourney Weaver', 8.5, 'English', 'Vietnamese', 'PG-13',
        'https://images.unsplash.com/photo-1574375927938-c5f442f1e76e?w=500', 'https://www.youtube.com/watch?v=d9MyW72ELq0'),
       ('Black Panther: Wakanda Forever',
        'Sau cai chet cua Vua T''Challa, Wakanda phai doi mat voi nhung thach thuc moi.', 161, '2022-11-11',
        '2023-02-11', 'Action, Adventure', 'Ryan Coogler', 'Letitia Wright, Angela Bassett, Lupita Nyong''o', 7.8,
        'English', 'Vietnamese', 'PG-13', 'https://images.unsplash.com/photo-1574375927938-c5f442f1e76e?w=500', 'https://www.youtube.com/watch?v=_Z3QKkl1WyM'),
       ('Top Gun: Maverick', 'Pete "Maverick" Mitchell tro lai voi nhiem vu nguy hiem nhat trong su nghiep cua minh.',
        131, '2022-05-27', '2023-01-27', 'Action, Drama', 'Joseph Kosinski',
        'Tom Cruise, Miles Teller, Jennifer Connelly', 8.9, 'English', 'Vietnamese', 'PG-13',
        'https://images.unsplash.com/photo-1574375927938-c5f442f1e76e?w=500', 'https://www.youtube.com/watch?v=qSqVVswa420'),
       ('Spider-Man: No Way Home', 'Peter Parker can su giup do cua Doctor Strange de che giau danh tinh cua minh.',
        148, '2021-12-17', '2022-06-17', 'Action, Adventure', 'Jon Watts', 'Tom Holland, Zendaya, Benedict Cumberbatch',
        8.7, 'English', 'Vietnamese', 'PG-13', 'https://images.unsplash.com/photo-1574375927938-c5f442f1e76e?w=500', 'https://www.youtube.com/watch?v=JfVOs4VSpmA'),
       ('The Batman',
        'Khi mot ke giet nguoi hang loat bat dau tan sat gioi thuong luu cua Gotham, Batman phai dieu tra.', 176,
        '2022-03-04', '2022-09-04', 'Action, Crime', 'Matt Reeves', 'Robert Pattinson, Zoe Kravitz, Paul Dano', 8.2,
        'English', 'Vietnamese', 'PG-13', 'https://images.unsplash.com/photo-1574375927938-c5f442f1e76e?w=500', 'https://www.youtube.com/watch?v=mqqft2x_Aa4');

-- =============================================
-- Insert Showtimes
-- =============================================
INSERT INTO showtimes (movie_id, cinema_hall_id, show_date, start_time, end_time, price)
VALUES (1, 1, '2023-01-15', '09:00:00', '12:12:00', 120000),
       (1, 1, '2023-01-15', '13:00:00', '16:12:00', 120000),
       (1, 1, '2023-01-15', '17:00:00', '20:12:00', 120000),
       (2, 2, '2023-01-15', '10:00:00', '12:41:00', 100000),
       (2, 2, '2023-01-15', '14:00:00', '16:41:00', 100000),
       (3, 3, '2023-01-15', '11:00:00', '13:11:00', 150000),
       (4, 4, '2023-01-15', '15:00:00', '17:28:00', 110000),
       (5, 5, '2023-01-15', '19:00:00', '21:56:00', 130000);

-- =============================================
-- Insert Seats (tạo ghế cho phòng 1)
-- =============================================
INSERT INTO seats (cinema_hall_id, seat_number, seat_row, seat_type)
VALUES
(1, 'A1', 'A', 'NORMAL'),
(1, 'A2', 'A', 'NORMAL'),
(1, 'A3', 'A', 'NORMAL'),
(1, 'A4', 'A', 'NORMAL'),
(1, 'A5', 'A', 'NORMAL'),
(1, 'A6', 'A', 'NORMAL'),
(1, 'A7', 'A', 'NORMAL'),
(1, 'A8', 'A', 'NORMAL'),
(1, 'A9', 'A', 'NORMAL'),
(1, 'A10', 'A', 'NORMAL'),
(1, 'A11', 'A', 'NORMAL'),
(1, 'A12', 'A', 'NORMAL'),
(1, 'A13', 'A', 'NORMAL'),
(1, 'A14', 'A', 'NORMAL'),
(1, 'A15', 'A', 'NORMAL'),
(1, 'A16', 'A', 'NORMAL'),
(1, 'A17', 'A', 'NORMAL'),
(1, 'A18', 'A', 'NORMAL'),
(1, 'A19', 'A', 'NORMAL'),
(1, 'A20', 'A', 'NORMAL'),

(1, 'B1', 'B', 'NORMAL'),
(1, 'B2', 'B', 'NORMAL'),
(1, 'B3', 'B', 'NORMAL'),
(1, 'B4', 'B', 'NORMAL'),
(1, 'B5', 'B', 'NORMAL'),
(1, 'B6', 'B', 'NORMAL'),
(1, 'B7', 'B', 'NORMAL'),
(1, 'B8', 'B', 'NORMAL'),
(1, 'B9', 'B', 'NORMAL'),
(1, 'B10', 'B', 'NORMAL'),
(1, 'B11', 'B', 'NORMAL'),
(1, 'B12', 'B', 'NORMAL'),
(1, 'B13', 'B', 'NORMAL'),
(1, 'B14', 'B', 'NORMAL'),
(1, 'B15', 'B', 'NORMAL'),
(1, 'B16', 'B', 'NORMAL'),
(1, 'B17', 'B', 'NORMAL'),
(1, 'B18', 'B', 'NORMAL'),
(1, 'B19', 'B', 'NORMAL'),
(1, 'B20', 'B', 'NORMAL'),

(1, 'C1', 'C', 'VIP'),
(1, 'C2', 'C', 'VIP'),
(1, 'C3', 'C', 'VIP'),
(1, 'C4', 'C', 'VIP'),
(1, 'C5', 'C', 'VIP'),
(1, 'C6', 'C', 'VIP'),
(1, 'C7', 'C', 'VIP'),
(1, 'C8', 'C', 'VIP'),
(1, 'C9', 'C', 'VIP'),
(1, 'C10', 'C', 'VIP'),
(1, 'C11', 'C', 'VIP'),
(1, 'C12', 'C', 'VIP'),
(1, 'C13', 'C', 'VIP'),
(1, 'C14', 'C', 'VIP'),
(1, 'C15', 'C', 'VIP'),
(1, 'C16', 'C', 'VIP'),
(1, 'C17', 'C', 'VIP'),
(1, 'C18', 'C', 'VIP'),
(1, 'C19', 'C', 'VIP'),
(1, 'C20', 'C', 'VIP');

-- =============================================
-- Insert Reviews
-- =============================================
INSERT INTO reviews (user_id, movie_id, rating, comment, is_approved)
VALUES (3, 1, 5, 'Phim hay tuyet voi! Hieu ung dep mat.', 1),
       (4, 1, 4, 'Tot nhung hoi dai.', 1),
       (3, 2, 5, 'Black Panther tuyet voi!', 1),
       (4, 3, 5, 'Top Gun Maverick hay qua!', 1),
       (3, 4, 4, 'Spider-Man No Way Home thu vi.', 1);

-- =============================================
-- Insert Favourites
-- =============================================
INSERT INTO favourites (user_id, movie_id)
VALUES (3, 1),
       (3, 2),
       (4, 3),
       (4, 4);

-- =============================================
-- Insert Promotions
-- =============================================
INSERT INTO promotions (code, name, description, discount_percentage, min_order_amount, start_date, end_date)
VALUES ('WELCOME10', 'Chao mung khach hang moi', 'Giam 10% cho don hang dau tien', 10.00, 100000, '2023-01-01',
        '2023-12-31'),
       ('VIP20', 'Khach hang VIP', 'Giam 20% cho khach hang VIP', 20.00, 200000, '2023-01-01', '2023-12-31'),
       ('WEEKEND15', 'Cuoi tuan vui ve', 'Giam 15% cho suat chieu cuoi tuan', 15.00, 150000, '2023-01-01',
        '2023-12-31');
