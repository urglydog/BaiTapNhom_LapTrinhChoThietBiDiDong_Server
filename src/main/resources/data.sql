-- Set UTF-8 encoding
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- =============================================
-- Migration: Add code field to promotions table
-- Add promotion_id and discount_amount to bookings table
-- =============================================
-- Migration này được tích hợp vào data.sql để chạy tự động khi Spring Boot khởi động
-- Hibernate với ddl-auto=update sẽ tự động tạo schema, nhưng migration này đảm bảo
-- các cột được tạo trước khi insert dữ liệu (nếu Hibernate chưa kịp tạo)
-- 
-- Lưu ý: Script này sử dụng PREPARE/EXECUTE để kiểm tra cột trước khi thêm,
-- tránh lỗi nếu cột đã tồn tại (từ lần chạy trước hoặc từ Hibernate)

-- Thêm cột code vào bảng promotions (chỉ khi chưa tồn tại)
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'promotions' 
     AND COLUMN_NAME = 'code') = 0,
    'ALTER TABLE promotions ADD COLUMN code VARCHAR(20) UNIQUE AFTER id',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Cập nhật code cho các promotion cũ (nếu có)
UPDATE promotions 
SET code = CONCAT('PROMO', id) 
WHERE code IS NULL OR code = '';

-- Đặt code là NOT NULL (chỉ khi cột đã tồn tại và có thể null)
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'promotions' 
     AND COLUMN_NAME = 'code' 
     AND IS_NULLABLE = 'YES') > 0,
    'ALTER TABLE promotions MODIFY COLUMN code VARCHAR(20) NOT NULL UNIQUE',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Thêm cột promotion_id vào bookings (chỉ khi chưa tồn tại)
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'bookings' 
     AND COLUMN_NAME = 'promotion_id') = 0,
    'ALTER TABLE bookings ADD COLUMN promotion_id INT NULL AFTER payment_method',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Thêm foreign key constraint (chỉ khi chưa tồn tại)
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'bookings' 
     AND CONSTRAINT_NAME = 'fk_booking_promotion') = 0,
    'ALTER TABLE bookings ADD CONSTRAINT fk_booking_promotion FOREIGN KEY (promotion_id) REFERENCES promotions(id) ON DELETE SET NULL',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Thêm cột discount_amount vào bookings (chỉ khi chưa tồn tại)
SET @sql = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
     WHERE TABLE_SCHEMA = DATABASE() 
     AND TABLE_NAME = 'bookings' 
     AND COLUMN_NAME = 'discount_amount') = 0,
    'ALTER TABLE bookings ADD COLUMN discount_amount DECIMAL(10,2) DEFAULT 0.00 AFTER promotion_id',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- =============================================
-- Insert Users
-- =============================================
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
VALUES 
-- Phim cũ (giữ nguyên)
('Avatar: The Way of Water',
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
        'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528820/luca_gljmav.webp', 'https://www.youtube.com/watch?v=mYfJxlgR2jw'),

-- Phim mới - Đang chiếu (releaseDate < 2025-11-19, endDate > 2025-11-19)
('Deadpool & Wolverine', 'Deadpool và Wolverine hợp tác trong cuộc phiêu lưu đầy máu và bạo lực qua đa vũ trụ.', 127, '2025-10-15', '2025-12-15', 'Action, Comedy, Superhero', 'Shawn Levy', 'Ryan Reynolds, Hugh Jackman, Emma Corrin', 8.5, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565788/deadpool-wolverine_nikxbk.webp', 'https://www.youtube.com/watch?v=example1'),
('Gladiator 2', 'Câu chuyện tiếp theo về đấu sĩ La Mã cổ đại, cuộc chiến vì danh dự và tự do.', 158, '2025-10-20', '2025-12-20', 'Action, Drama, Historical', 'Ridley Scott', 'Paul Mescal, Denzel Washington, Pedro Pascal', 8.2, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565798/gladiator-2_ngopue.webp', 'https://www.youtube.com/watch?v=example2'),
('Beetlejuice Beetlejuice', 'Beetlejuice trở lại với những trò đùa quỷ quái và phiêu lưu siêu nhiên mới.', 115, '2025-10-25', '2025-12-25', 'Comedy, Fantasy, Horror', 'Tim Burton', 'Michael Keaton, Winona Ryder, Jenna Ortega', 7.8, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565786/beetlejuice-beetlejuice_ej0k3o.webp', 'https://www.youtube.com/watch?v=example3'),
('Transformers One', 'Nguồn gốc của cuộc chiến giữa Autobots và Decepticons trên Cybertron.', 104, '2025-10-30', '2025-12-30', 'Animation, Action, Sci-Fi', 'Josh Cooley', 'Chris Hemsworth, Scarlett Johansson, Brian Tyree Henry', 7.5, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565716/transformers-one_yqwqy2.webp', 'https://www.youtube.com/watch?v=example4'),
('The Wild Robot', 'Robot bị mắc kẹt trên đảo hoang phải học cách sống sót và kết bạn với động vật.', 102, '2025-11-01', '2025-12-31', 'Animation, Adventure, Family', 'Chris Sanders', 'Lupita Nyong''o, Pedro Pascal, Catherine O''Hara', 8.0, 'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565714/the-wild-robot_k0wbmh.webp', 'https://www.youtube.com/watch?v=example5'),
('Wicked', 'Câu chuyện tiền truyện của The Wizard of Oz, về Elphaba và Glinda.', 142, '2025-11-05', '2025-12-25', 'Musical, Fantasy, Drama', 'Jon M. Chu', 'Ariana Grande, Cynthia Erivo, Jonathan Bailey', 8.3, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565716/wicked_mfg7np.webp', 'https://www.youtube.com/watch?v=example6'),
('Moana 2', 'Moana trở lại với cuộc hành trình mới trên biển cả, khám phá những hòn đảo bí ẩn.', 107, '2025-11-08', '2025-12-28', 'Animation, Adventure, Musical', 'David G. Derrick Jr.', 'Auli''i Cravalho, Dwayne Johnson, Alan Tudyk', 8.1, 'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565703/moana-2_a1ixcy.webp', 'https://www.youtube.com/watch?v=example7'),
('Mufasa: The Lion King', 'Câu chuyện về nguồn gốc của Mufasa, vị vua vĩ đại của Pride Lands.', 98, '2025-11-10', '2025-12-20', 'Animation, Adventure, Drama', 'Barry Jenkins', 'Aaron Pierre, Kelvin Harrison Jr., Seth Rogen', 7.9, 'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565702/mufasa-lion-king_tclwla.webp', 'https://www.youtube.com/watch?v=example8'),
('Smile 2', 'Tiếp nối câu chuyện kinh dị về nụ cười đáng sợ lan truyền như virus.', 118, '2025-11-12', '2025-12-22', 'Horror, Thriller', 'Parker Finn', 'Naomi Scott, Kyle Gallner, Rosemarie DeWitt', 6.8, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565704/smile-2_xzcyx8.webp', 'https://www.youtube.com/watch?v=example9'),
('The Substance', 'Phim kinh dị khoa học viễn tưởng về một chất liệu bí ẩn thay đổi con người.', 131, '2025-11-15', '2025-12-15', 'Horror, Sci-Fi, Thriller', 'Coralie Fargeat', 'Demi Moore, Margaret Qualley, Dennis Quaid', 7.2, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565714/the-substance_zqvstk.webp', 'https://www.youtube.com/watch?v=example10'),

-- Phim mới - Sắp chiếu (releaseDate từ 2025-11-19 đến 2025-12-19)
('Avatar 3', 'Jake Sully và gia đình tiếp tục cuộc chiến bảo vệ Pandora khỏi những mối đe dọa mới.', 195, '2025-11-19', '2026-02-19', 'Sci-Fi, Action, Adventure', 'James Cameron', 'Sam Worthington, Zoe Saldana, Sigourney Weaver', 0.0, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565786/avatar-3_nsx7pw.webp', 'https://www.youtube.com/watch?v=example11'),
('Superman: Legacy', 'Câu chuyện mới về Superman, người hùng bảo vệ Trái Đất khỏi những kẻ thù siêu nhiên.', 145, '2025-11-22', '2026-01-22', 'Action, Adventure, Superhero', 'James Gunn', 'David Corenswet, Rachel Brosnahan, Nicholas Hoult', 0.0, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565705/superman-legacy_oszlal.webp', 'https://www.youtube.com/watch?v=example12'),
('Thunderbolts', 'Nhóm siêu phản anh hùng hợp tác để thực hiện nhiệm vụ bí mật cho chính phủ.', 132, '2025-11-25', '2026-01-25', 'Action, Adventure, Superhero', 'Jake Schreier', 'Florence Pugh, Sebastian Stan, David Harbour', 0.0, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565716/thunderbolts_lexamn.webp', 'https://www.youtube.com/watch?v=example13'),
('Blade', 'Ma cà rồng daywalker trở lại để bảo vệ nhân loại khỏi bóng tối.', 128, '2025-11-28', '2026-01-28', 'Action, Horror, Superhero', 'Yann Demange', 'Mahershala Ali, Delroy Lindo, Aaron Pierre', 0.0, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565786/blade_xf5pyy.webp', 'https://www.youtube.com/watch?v=example14'),
('Inside Out 2', 'Riley lớn lên và những cảm xúc mới xuất hiện trong tâm trí cô.', 96, '2025-12-01', '2026-02-01', 'Animation, Comedy, Family', 'Kelsey Mann', 'Amy Poehler, Maya Hawke, Ayo Edebiri', 0.0, 'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565702/inside-out-2_sygwnd.webp', 'https://www.youtube.com/watch?v=example15'),
('Despicable Me 4', 'Gru và gia đình đối mặt với kẻ thù mới và những thử thách hài hước.', 88, '2025-12-05', '2026-02-05', 'Animation, Comedy, Family', 'Chris Renaud', 'Steve Carell, Kristen Wiig, Miranda Cosgrove', 0.0, 'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565787/despicable-me-4_rdyxjl.webp', 'https://www.youtube.com/watch?v=example16'),
('Sonic the Hedgehog 3', 'Sonic và bạn bè chiến đấu chống lại Shadow và những mối đe dọa mới.', 102, '2025-12-08', '2026-02-08', 'Action, Adventure, Comedy', 'Jeff Fowler', 'Ben Schwartz, Idris Elba, James Marsden', 0.0, 'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565704/sonic-hedgehog-3_nk9arb.webp', 'https://www.youtube.com/watch?v=example17'),
('Nosferatu', 'Bản làm lại kinh điển về ma cà rồng Nosferatu với góc nhìn hiện đại.', 134, '2025-12-10', '2026-02-10', 'Horror, Drama, Thriller', 'Robert Eggers', 'Bill Skarsgård, Lily-Rose Depp, Willem Dafoe', 0.0, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565702/nosferatu_hfeo1g.webp', 'https://www.youtube.com/watch?v=example18'),
('A Complete Unknown', 'Câu chuyện về Bob Dylan và hành trình trở thành huyền thoại âm nhạc.', 142, '2025-12-12', '2026-02-12', 'Biography, Drama, Music', 'James Mangold', 'Timothée Chalamet, Elle Fanning, Boyd Holbrook', 0.0, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565760/a-complete-unknown_x8yoah.webp', 'https://www.youtube.com/watch?v=example19'),
('The Amateur', 'Một nhân viên CIA nghiệp dư phải thực hiện nhiệm vụ nguy hiểm để cứu vợ.', 118, '2025-12-15', '2026-02-15', 'Action, Thriller', 'James Hawes', 'Rami Malek, Rachel Brosnahan, Julianne Nicholson', 0.0, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565705/the-amateur_bu08ff.webp', 'https://www.youtube.com/watch?v=example20'),
('Beverly Hills Cop: Axel F', 'Axel Foley trở lại Beverly Hills để giải quyết vụ án mới đầy nguy hiểm.', 115, '2025-12-18', '2026-02-18', 'Action, Comedy, Crime', 'Mark Molloy', 'Eddie Murphy, Judge Reinhold, Kevin Bacon', 0.0, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565797/everly-hills-cop-axel-f_yztr2g.webp', 'https://www.youtube.com/watch?v=example21'),
('It Ends With Us', 'Câu chuyện tình yêu phức tạp về một phụ nữ phải đối mặt với quá khứ đau thương.', 125, '2025-12-19', '2026-02-19', 'Drama, Romance', 'Justin Baldoni', 'Blake Lively, Justin Baldoni, Jenny Slate', 0.0, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565702/it-ends-with-us_sw9lwc.webp', 'https://www.youtube.com/watch?v=example22'),
('Dune: Part Three', 'Phần cuối của câu chuyện về Paul Atreides và cuộc chiến trên Arrakis.', 165, '2025-12-20', '2026-03-20', 'Sci-Fi, Adventure, Drama', 'Denis Villeneuve', 'Timothée Chalamet, Zendaya, Rebecca Ferguson', 0.0, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565787/dune-part-three_n0fmhi.webp', 'https://www.youtube.com/watch?v=example23'),
('Kingdom of the Planet of the Apes', 'Câu chuyện tiếp theo về thế giới của loài khỉ thống trị Trái Đất.', 145, '2025-12-22', '2026-03-22', 'Sci-Fi, Action, Drama', 'Wes Ball', 'Owen Teague, Freya Allan, Kevin Durand', 0.0, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565703/kingdom-planet-apes_t2u5yj.webp', 'https://www.youtube.com/watch?v=example24'),
('Mission: Impossible 8', 'Ethan Hunt và nhóm IMF đối mặt với nhiệm vụ bất khả thi nhất từ trước đến nay.', 158, '2025-12-25', '2026-03-25', 'Action, Adventure, Thriller', 'Christopher McQuarrie', 'Tom Cruise, Hayley Atwell, Ving Rhames', 0.0, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565704/mission-impossible-8_hpohxv.webp', 'https://www.youtube.com/watch?v=example25'),
('Red One', 'Câu chuyện về ông già Noel và đặc vụ phải cứu Giáng sinh khỏi mối đe dọa.', 112, '2025-12-28', '2026-02-28', 'Action, Adventure, Comedy', 'Jake Kasdan', 'Dwayne Johnson, Chris Evans, J.K. Simmons', 0.0, 'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565704/red-one_s2vkxg.webp', 'https://www.youtube.com/watch?v=example26'),
('The Strangers: Chapter 1', 'Một cặp đôi bị tấn công bởi những kẻ lạ mặt đáng sợ trong nhà nghỉ.', 91, '2025-12-30', '2026-02-28', 'Horror, Thriller', 'Renny Harlin', 'Madelaine Petsch, Froy Gutierrez, Rachel Shenton', 0.0, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565705/the-strangers-chapter-1_cggm6e.webp', 'https://www.youtube.com/watch?v=example27'),
('Lật Mặt 7: Một Điều Ước', 'Phần tiếp theo của series Lật Mặt với câu chuyện mới đầy kịch tính.', 120, '2025-11-20', '2026-01-20', 'Action, Drama, Crime', 'Lý Hải', 'Lý Hải, Hứa Vĩ Văn, Huỳnh Đông', 0.0, 'Vietnamese', 'Vietnamese', 'C18', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565703/lat-mat-7_aootj0.webp', 'https://www.youtube.com/watch?v=example28'),
('Đất Rừng Phương Nam', 'Câu chuyện về cuộc sống và chiến đấu của người dân miền Nam trong thời kỳ kháng chiến.', 135, '2025-12-01', '2026-02-01', 'Drama, Historical, War', 'Nguyễn Quang Dũng', 'Huỳnh Đông, Lê Giang, NSND Trần Nhượng', 0.0, 'Vietnamese', 'Vietnamese', 'C16', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565787/dat-rung-phuong-nam_sn74cp.webp', 'https://www.youtube.com/watch?v=example29'),
('Bố Già 2', 'Phần tiếp theo của Bố Già với những tình huống hài hước và cảm động mới.', 110, '2025-12-10', '2026-02-10', 'Comedy, Drama, Family', 'Vũ Ngọc Đãng', 'Trấn Thành, Lê Giang, Ngọc Giàu', 0.0, 'Vietnamese', 'Vietnamese', 'C13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565788/bo-gia-2_h5prds.jpg', 'https://www.youtube.com/watch?v=example30');

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
INSERT IGNORE INTO promotions (code, name, description, discount_type, discount_value, min_amount, max_discount, start_date, end_date, usage_limit, is_active)
VALUES 
-- Promotions cũ (giữ nguyên)
('WELCOME10', 'Chao mung khach hang moi', 'Giam 10% cho don hang dau tien', 'PERCENTAGE', 10.00, 100000, 50000, '2023-01-01 00:00:00',
        '2023-12-31 23:59:59', 1000, TRUE),
       ('VIP20', 'Khach hang VIP', 'Giam 20% cho khach hang VIP', 'PERCENTAGE', 20.00, 200000, 100000, '2023-01-01 00:00:00', '2023-12-31 23:59:59', 500, TRUE),
       ('WEEKEND15', 'Cuoi tuan vui ve', 'Giam 15% cho suat chieu cuoi tuan', 'PERCENTAGE', 15.00, 150000, 75000, '2023-01-01 00:00:00',
        '2023-12-31 23:59:59', 200, TRUE),

-- Promotions mới (19/11/2025 - 19/12/2025)
-- Khuyến mãi dài hạn (cả tháng)
('NOV2025', 'Khuyến mãi tháng 11', 'Giảm 15% cho tất cả đơn hàng trong tháng 11', 'PERCENTAGE', 15.00, 100000, 50000, '2025-11-01 00:00:00', '2025-11-30 23:59:59', 5000, TRUE),
('DEC2025', 'Khuyến mãi tháng 12', 'Giảm 20% cho tất cả đơn hàng trong tháng 12', 'PERCENTAGE', 20.00, 150000, 80000, '2025-12-01 00:00:00', '2025-12-31 23:59:59', 5000, TRUE),
('NEWUSER25', 'Khách hàng mới', 'Giảm 25% cho khách hàng mới đăng ký', 'PERCENTAGE', 25.00, 200000, 100000, '2025-11-19 00:00:00', '2025-12-19 23:59:59', 1000, TRUE),

-- Khuyến mãi theo tuần
('GOLDWEEK', 'Tuần lễ vàng', 'Giảm 30% cho đơn hàng từ 300.000đ trở lên', 'PERCENTAGE', 30.00, 300000, 150000, '2025-11-19 00:00:00', '2025-11-25 23:59:59', 500, TRUE),
('BLACKFRIDAY', 'Black Friday', 'Giảm 40% cho tất cả đơn hàng trong ngày Black Friday', 'PERCENTAGE', 40.00, 200000, 200000, '2025-11-28 00:00:00', '2025-11-28 23:59:59', 1000, TRUE),
('WEEKEND', 'Cuối tuần vui vẻ', 'Giảm 18% cho suất chiếu cuối tuần', 'PERCENTAGE', 18.00, 150000, 90000, '2025-11-29 00:00:00', '2025-12-01 23:59:59', 800, TRUE),

-- Khuyến mãi theo ngày đặc biệt
('GRANDOPEN', 'Ngày khai trương', 'Giảm 50.000đ cho đơn hàng đầu tiên', 'FIXED_AMOUNT', 50000.00, 100000, 50000, '2025-11-19 00:00:00', '2025-11-19 23:59:59', 200, TRUE),
('TUESDAY', 'Thứ 3 xả stress', 'Giảm 25.000đ mỗi thứ 3 hàng tuần', 'FIXED_AMOUNT', 25000.00, 80000, 25000, '2025-11-25 00:00:00', '2025-12-16 23:59:59', 1000, TRUE),
('BIRTHDAY', 'Ngày sinh nhật', 'Giảm 35% cho khách hàng có sinh nhật trong tháng', 'PERCENTAGE', 35.00, 100000, 100000, '2025-11-19 00:00:00', '2025-12-19 23:59:59', 500, TRUE),

-- Khuyến mãi theo loại phim
('VIETNAM', 'Phim Việt Nam', 'Giảm 20.000đ cho tất cả phim Việt Nam', 'FIXED_AMOUNT', 20000.00, 50000, 20000, '2025-11-19 00:00:00', '2025-12-19 23:59:59', 2000, TRUE),
('IMAX3D', 'Phim 3D/IMAX', 'Giảm 15% cho phim 3D và IMAX', 'PERCENTAGE', 15.00, 200000, 60000, '2025-11-19 00:00:00', '2025-12-19 23:59:59', 1500, TRUE),
('FAMILY', 'Phim gia đình', 'Giảm 30.000đ cho phim gia đình (PG)', 'FIXED_AMOUNT', 30000.00, 100000, 30000, '2025-11-19 00:00:00', '2025-12-19 23:59:59', 1000, TRUE),

-- Khuyến mãi theo thời gian
('MORNING', 'Suất sáng', 'Giảm 30.000đ cho suất chiếu trước 12h trưa', 'FIXED_AMOUNT', 30000.00, 50000, 30000, '2025-11-19 00:00:00', '2025-12-19 23:59:59', 2000, TRUE),
('EVENING', 'Suất tối', 'Giảm 20.000đ cho suất chiếu sau 8h tối', 'FIXED_AMOUNT', 20000.00, 100000, 20000, '2025-11-19 00:00:00', '2025-12-19 23:59:59', 1500, TRUE),

-- Khuyến mãi combo
('COMBO2', 'Combo đôi', 'Giảm 15% khi mua 2 vé trở lên', 'PERCENTAGE', 15.00, 200000, 75000, '2025-11-19 00:00:00', '2025-12-19 23:59:59', 3000, TRUE),
('COMBO4', 'Combo gia đình', 'Giảm 25% khi mua từ 4 vé trở lên', 'PERCENTAGE', 25.00, 400000, 150000, '2025-11-19 00:00:00', '2025-12-19 23:59:59', 1000, TRUE),

-- Khuyến mãi đặc biệt tháng 12
('XMAS2025', 'Giáng sinh sớm', 'Giảm 22% cho đơn hàng từ 22/12 đến 25/12', 'PERCENTAGE', 22.00, 180000, 100000, '2025-12-22 00:00:00', '2025-12-25 23:59:59', 800, TRUE),
('NEWYEAR2026', 'Năm mới 2026', 'Giảm 30.000đ cho đơn hàng từ 30/12 đến 2/1', 'FIXED_AMOUNT', 30000.00, 120000, 30000, '2025-12-30 00:00:00', '2026-01-02 23:59:59', 1200, TRUE),

-- Khuyến mãi VIP
('VIP30', 'Thành viên VIP', 'Giảm 30% cho thành viên VIP', 'PERCENTAGE', 30.00, 250000, 120000, '2025-11-19 00:00:00', '2025-12-19 23:59:59', 500, TRUE),
('POINTS2X', 'Tích điểm thưởng', 'Giảm 10% + tích điểm x2 cho mọi đơn hàng', 'PERCENTAGE', 10.00, 100000, 50000, '2025-11-19 00:00:00', '2025-12-19 23:59:59', 10000, TRUE);
