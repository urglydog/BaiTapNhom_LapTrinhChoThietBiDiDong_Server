-- Set UTF-8 encoding
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

INSERT IGNORE INTO users (username, email, password, full_name, phone, date_of_birth, gender, role)
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
INSERT IGNORE INTO cinemas (name, address, city, phone, email, description, image_url)
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
INSERT IGNORE INTO cinema_halls (cinema_id, hall_name, total_seats)
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
INSERT IGNORE INTO movies (title, description, duration, release_date, end_date, genre, director, cast, rating, language,
                    subtitle, age_rating, poster_url, trailer_url)
VALUES ('Avatar: The Way of Water',
        'Jake Sully va gia dinh cua anh ay kham pha nhung vung bien cua Pandora va gap go nhung sinh vat bien ky la.',
        192, '2022-12-16', '2023-03-16', 'Sci-Fi, Action', 'James Cameron',
        'Sam Worthington, Zoe Saldana, Sigourney Weaver', 8.5, 'English', 'Vietnamese', 'PG-13',
        'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528821/avatar-way-of-water_exbrsq.jpg', 'https://www.youtube.com/watch?v=d9MyW72ELq0'),
       ('Black Panther: Wakanda Forever',
        'Sau cai chet cua Vua T''Challa, Wakanda phai doi mat voi nhung thach thuc moi.', 161, '2022-11-11',
        '2023-02-11', 'Action, Adventure', 'Ryan Coogler', 'Letitia Wright, Angela Bassett, Lupita Nyong''o', 7.8,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528822/black-panther-wakanda-forever_mr8llu.webp', 'https://www.youtube.com/watch?v=_Z3QKkl1WyM'),
       ('Top Gun: Maverick', 'Pete "Maverick" Mitchell tro lai voi nhiem vu nguy hiem nhat trong su nghiep cua minh.',
        131, '2022-05-27', '2023-01-27', 'Action, Drama', 'Joseph Kosinski',
        'Tom Cruise, Miles Teller, Jennifer Connelly', 8.9, 'English', 'Vietnamese', 'PG-13',
        'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528821/top-gun-maverick_g2fcar.jpg', 'https://www.youtube.com/watch?v=qSqVVswa420'),
       ('Spider-Man: No Way Home', 'Peter Parker can su giup do cua Doctor Strange de che giau danh tinh cua minh.',
        148, '2021-12-17', '2022-06-17', 'Action, Adventure', 'Jon Watts', 'Tom Holland, Zendaya, Benedict Cumberbatch',
        8.7, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528820/spider-man-no-way-home_no0olj.jpg', 'https://www.youtube.com/watch?v=JfVOs4VSpmA'),
       ('The Batman',
        'Khi mot ke giet nguoi hang loat bat dau tan sat gioi thuong luu cua Gotham, Batman phai dieu tra.', 176,
        '2022-03-04', '2022-09-04', 'Action, Crime', 'Matt Reeves', 'Robert Pattinson, Zoe Kravitz, Paul Dano', 8.2,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528821/the-batman_nvf7fa.jpg', 'https://www.youtube.com/watch?v=mqqft2x_Aa4'),
       ('Avengers: Endgame',
        'Phan ket thuc cua loat phim Avengers, cac siêu anh hung phai doan ket de cuu vu tru.', 181,
        '2019-04-26', '2019-08-26', 'Action, Adventure, Sci-Fi', 'Anthony Russo, Joe Russo',
        'Robert Downey Jr., Chris Evans, Mark Ruffalo, Chris Hemsworth', 8.4,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528822/avengers-endgame_nzuqwd.jpg', 'https://www.youtube.com/watch?v=TcMBFSGVi1c'),
       ('Dune',
        'Paul Atreides danh gia mot hanh tinh nguy hiem de bao ve gia dinh va nhan dan cua minh.', 155,
        '2021-10-22', '2022-04-22', 'Sci-Fi, Adventure', 'Denis Villeneuve',
        'Timothee Chalamet, Rebecca Ferguson, Oscar Isaac', 8.0,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528819/dune_duwnky.jpg', 'https://www.youtube.com/watch?v=8g18jFHCLXk'),
       ('No Time to Die',
        'James Bond da nghi huu phai quay lai de chong lai mot ke thu nguy hiem voi vu khi sinh hoc.', 163,
        '2021-10-08', '2022-04-08', 'Action, Thriller', 'Cary Joji Fukunaga',
        'Daniel Craig, Rami Malek, Lea Seydoux', 7.3,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762529509/no-time-to-die_q8vtso.webp', 'https://www.youtube.com/watch?v=BIhNsAtPbPI'),
       ('Fast & Furious 9',
        'Dom va gia dinh phai chong lai ke thu nguy hiem nhat trong lich su cua ho.', 143,
        '2021-06-25', '2021-12-25', 'Action, Crime', 'Justin Lin',
        'Vin Diesel, Michelle Rodriguez, Tyrese Gibson', 5.2,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528821/fast-furious-9_ecp9ys.webp', 'https://www.youtube.com/watch?v=FUK2kdPsBws'),
       ('Shang-Chi and the Legend of the Ten Rings',
        'Shang-Chi phai doi mat voi qua khu cua minh khi bi keo vao to chuc Ten Rings cua nguoi cha.', 132,
        '2021-09-03', '2022-03-03', 'Action, Adventure, Fantasy', 'Destin Daniel Cretton',
        'Simu Liu, Awkwafina, Tony Leung', 7.4,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528820/shang-chi-and-the-legend-of-the-ten-rings_pk1llq.webp', 'https://www.youtube.com/watch?v=8YjFbMbfXaE'),
       ('Doctor Strange in the Multiverse of Madness',
        'Doctor Strange phai di qua nhieu vu tru de bao ve mot thiếu nữ co kha nang di chuyen giua cac vu tru.', 126,
        '2022-05-06', '2022-11-06', 'Action, Adventure, Fantasy', 'Sam Raimi',
        'Benedict Cumberbatch, Elizabeth Olsen, Chiwetel Ejiofor', 6.9,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528819/doctor-strange-multiverse-madness_ebbsos.jpg', 'https://www.youtube.com/watch?v=aWzlQ2N6qqg'),
       ('Jurassic World Dominion',
        'Owen va Claire phai cuu loai khung long khoi tuyet chung khi chung bi phan tan khap the gioi.', 147,
        '2022-06-10', '2022-12-10', 'Action, Adventure, Sci-Fi', 'Colin Trevorrow',
        'Chris Pratt, Bryce Dallas Howard, Laura Dern', 5.7,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528821/jurassic-world-dominion_m4dsqg.webp', 'https://www.youtube.com/watch?v=fb5ELWi-ekk'),
       ('Minions: The Rise of Gru',
        'Gru, mot cau be 12 tuoi, mo uoc tro thanh siêu ac nhan trong nhom ac nhan xau xa nhat the gioi.', 87,
        '2022-07-01', '2022-12-31', 'Animation, Comedy, Adventure', 'Kyle Balda',
        'Steve Carell, Pierre Coffin, Alan Arkin', 6.5,
        'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528819/minions-rise-of-gru_ifry6o.jpg', 'https://www.youtube.com/watch?v=6DxjJzmYsXo'),
       ('Everything Everywhere All at Once',
        'Mot phu nu Trung Quoc My phai cuu the gioi bang cach ket noi voi cac phien ban khac cua minh trong nhieu vu tru.', 139,
        '2022-03-25', '2022-09-25', 'Action, Comedy, Drama', 'Daniel Kwan, Daniel Scheinert',
        'Michelle Yeoh, Stephanie Hsu, Ke Huy Quan', 8.1,
        'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528820/everything-everywhere-all-at-once_berquk.webp', 'https://www.youtube.com/watch?v=wxN1T1uxQ2g'),
       ('The Matrix Resurrections',
        'Neo phai quay lai Matrix de tim ra su that ve thuc te cua minh.', 148,
        '2021-12-22', '2022-06-22', 'Action, Sci-Fi', 'Lana Wachowski',
        'Keanu Reeves, Carrie-Anne Moss, Yahya Abdul-Mateen II', 5.7,
        'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528821/the-matrix-resurrections_dvtwfs.webp', 'https://www.youtube.com/watch?v=9ix7TUGVYIo'),
       ('Encanto',
        'Mot gia dinh Colombia ky dieu song trong mot ngoi nha ma thuat, nhung mot cô gai tre khong co phep thuat.', 102,
        '2021-11-24', '2022-05-24', 'Animation, Comedy, Family', 'Byron Howard, Jared Bush',
        'Stephanie Beatriz, Maria Cecilia Botero, John Leguizamo', 7.3,
        'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528820/encanto_rfor26.jpg', 'https://www.youtube.com/watch?v=CaimKeDcudo'),
       ('Free Guy',
        'Mot nhan vat trong game khong biet minh la AI, quyet dinh tro thanh anh hung va cuu the gioi cua minh.', 115,
        '2021-08-13', '2022-02-13', 'Action, Comedy, Sci-Fi', 'Shawn Levy',
        'Ryan Reynolds, Jodie Comer, Taika Waititi', 7.1,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528820/free-guy_yzsdmt.jpg', 'https://www.youtube.com/watch?v=X2m-08cOAbc'),
       ('Cruella',
        'Cau chuyen ve nguon goc cua Cruella de Vil, mot thiet ke thoi trang tai nang nhung ac doc.', 134,
        '2021-05-28', '2021-11-28', 'Comedy, Crime', 'Craig Gillespie',
        'Emma Stone, Emma Thompson, Joel Fry', 7.3,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528822/cruella_yoz4oa.webp', 'https://www.youtube.com/watch?v=gmRKv7n2If8'),
       ('Luca',
        'Cau be nguoi ca Luca trai nghiem mot mua he ky dieu o Riviera, Italy cung nguoi ban moi cua minh.', 95,
        '2021-06-18', '2021-12-18', 'Animation, Comedy, Family', 'Enrico Casarosa',
        'Jacob Tremblay, Jack Dylan Grazer, Emma Berman', 7.5,
        'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528820/luca_gljmav.webp', 'https://www.youtube.com/watch?v=mYfJxlgR2jw');

-- =============================================
-- Insert Showtimes
-- =============================================
INSERT IGNORE INTO showtimes (movie_id, cinema_hall_id, show_date, start_time, end_time, price)
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
INSERT IGNORE INTO seats (cinema_hall_id, seat_number, seat_row, seat_type)
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
INSERT IGNORE INTO reviews (user_id, movie_id, rating, comment, is_approved)
VALUES (3, 1, 5, 'Phim hay tuyet voi! Hieu ung dep mat.', 1),
       (4, 1, 4, 'Tot nhung hoi dai.', 1),
       (3, 2, 5, 'Black Panther tuyet voi!', 1),
       (4, 3, 5, 'Top Gun Maverick hay qua!', 1),
       (3, 4, 4, 'Spider-Man No Way Home thu vi.', 1);

-- =============================================
-- Insert Favourites
-- =============================================
INSERT IGNORE INTO favourites (user_id, movie_id)
VALUES (3, 1),
       (3, 2),
       (4, 3),
       (4, 4);

-- =============================================
-- Insert Promotions
-- =============================================
INSERT IGNORE INTO promotions (name, description, discount_type, discount_value, min_amount, max_discount, start_date, end_date, usage_limit)
VALUES ('Chao mung khach hang moi', 'Giam 10% cho don hang dau tien', 'PERCENTAGE', 10.00, 100000, 50000, '2023-01-01 00:00:00',
        '2023-12-31 23:59:59', 1000),
       ('Khach hang VIP', 'Giam 20% cho khach hang VIP', 'PERCENTAGE', 20.00, 200000, 100000, '2023-01-01 00:00:00', '2023-12-31 23:59:59', 500),
       ('Cuoi tuan vui ve', 'Giam 15% cho suat chieu cuoi tuan', 'PERCENTAGE', 15.00, 150000, 75000, '2023-01-01 00:00:00',
        '2023-12-31 23:59:59', 200);
