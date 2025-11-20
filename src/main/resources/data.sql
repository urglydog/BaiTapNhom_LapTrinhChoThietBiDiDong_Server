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
                    subtitle, age_rating, poster_url, trailer_url, is_active)
VALUES 
-- Phim cũ (giữ nguyên) - set active = FALSE vì đã hết hạn chiếu
('Avatar: The Way of Water',
        'Jake Sully va gia dinh cua anh ay kham pha nhung vung bien cua Pandora va gap go nhung sinh vat bien ky la.',
        192, '2022-12-16', '2023-03-16', 'Sci-Fi, Action', 'James Cameron',
        'Sam Worthington, Zoe Saldana, Sigourney Weaver', 8.5, 'English', 'Vietnamese', 'PG-13',
        'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528821/avatar-way-of-water_exbrsq.jpg', 'https://www.youtube.com/watch?v=d9MyW72ELq0', FALSE),
       ('Black Panther: Wakanda Forever',
        'Sau cai chet cua Vua T''Challa, Wakanda phai doi mat voi nhung thach thuc moi.', 161, '2022-11-11',
        '2023-02-11', 'Action, Adventure', 'Ryan Coogler', 'Letitia Wright, Angela Bassett, Lupita Nyong''o', 7.8,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528822/black-panther-wakanda-forever_mr8llu.webp', 'https://www.youtube.com/watch?v=_Z3QKkl1WyM', FALSE),
       ('Top Gun: Maverick', 'Pete "Maverick" Mitchell tro lai voi nhiem vu nguy hiem nhat trong su nghiep cua minh.',
        131, '2022-05-27', '2023-01-27', 'Action, Drama', 'Joseph Kosinski',
        'Tom Cruise, Miles Teller, Jennifer Connelly', 8.9, 'English', 'Vietnamese', 'PG-13',
        'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528821/top-gun-maverick_g2fcar.jpg', 'https://www.youtube.com/watch?v=qSqVVswa420', FALSE),
       ('Spider-Man: No Way Home', 'Peter Parker can su giup do cua Doctor Strange de che giau danh tinh cua minh.',
        148, '2021-12-17', '2022-06-17', 'Action, Adventure', 'Jon Watts', 'Tom Holland, Zendaya, Benedict Cumberbatch',
        8.7, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528820/spider-man-no-way-home_no0olj.jpg', 'https://www.youtube.com/watch?v=JfVOs4VSpmA', FALSE),
       ('The Batman',
        'Khi mot ke giet nguoi hang loat bat dau tan sat gioi thuong luu cua Gotham, Batman phai dieu tra.', 176,
        '2022-03-04', '2022-09-04', 'Action, Crime', 'Matt Reeves', 'Robert Pattinson, Zoe Kravitz, Paul Dano', 8.2,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528821/the-batman_nvf7fa.jpg', 'https://www.youtube.com/watch?v=mqqft2x_Aa4', FALSE),
       ('Avengers: Endgame',
        'Phan ket thuc cua loat phim Avengers, cac siêu anh hung phai doan ket de cuu vu tru.', 181,
        '2019-04-26', '2019-08-26', 'Action, Adventure, Sci-Fi', 'Anthony Russo, Joe Russo',
        'Robert Downey Jr., Chris Evans, Mark Ruffalo, Chris Hemsworth', 8.4,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528822/avengers-endgame_nzuqwd.jpg', 'https://www.youtube.com/watch?v=TcMBFSGVi1c', FALSE),
       ('Dune',
        'Paul Atreides danh gia mot hanh tinh nguy hiem de bao ve gia dinh va nhan dan cua minh.', 155,
        '2021-10-22', '2022-04-22', 'Sci-Fi, Adventure', 'Denis Villeneuve',
        'Timothee Chalamet, Rebecca Ferguson, Oscar Isaac', 8.0,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528819/dune_duwnky.jpg', 'https://www.youtube.com/watch?v=8g18jFHCLXk', FALSE),
       ('No Time to Die',
        'James Bond da nghi huu phai quay lai de chong lai mot ke thu nguy hiem voi vu khi sinh hoc.', 163,
        '2021-10-08', '2022-04-08', 'Action, Thriller', 'Cary Joji Fukunaga',
        'Daniel Craig, Rami Malek, Lea Seydoux', 7.3,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762529509/no-time-to-die_q8vtso.webp', 'https://www.youtube.com/watch?v=BIhNsAtPbPI', FALSE),
       ('Fast & Furious 9',
        'Dom va gia dinh phai chong lai ke thu nguy hiem nhat trong lich su cua ho.', 143,
        '2021-06-25', '2021-12-25', 'Action, Crime', 'Justin Lin',
        'Vin Diesel, Michelle Rodriguez, Tyrese Gibson', 5.2,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528821/fast-furious-9_ecp9ys.webp', 'https://www.youtube.com/watch?v=FUK2kdPsBws', FALSE),
       ('Shang-Chi and the Legend of the Ten Rings',
        'Shang-Chi phai doi mat voi qua khu cua minh khi bi keo vao to chuc Ten Rings cua nguoi cha.', 132,
        '2021-09-03', '2022-03-03', 'Action, Adventure, Fantasy', 'Destin Daniel Cretton',
        'Simu Liu, Awkwafina, Tony Leung', 7.4,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528820/shang-chi-and-the-legend-of-the-ten-rings_pk1llq.webp', 'https://www.youtube.com/watch?v=8YjFbMbfXaE', FALSE),
       ('Doctor Strange in the Multiverse of Madness',
        'Doctor Strange phai di qua nhieu vu tru de bao ve mot thiếu nữ co kha nang di chuyen giua cac vu tru.', 126,
        '2022-05-06', '2022-11-06', 'Action, Adventure, Fantasy', 'Sam Raimi',
        'Benedict Cumberbatch, Elizabeth Olsen, Chiwetel Ejiofor', 6.9,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528819/doctor-strange-multiverse-madness_ebbsos.jpg', 'https://www.youtube.com/watch?v=aWzlQ2N6qqg', FALSE),
       ('Jurassic World Dominion',
        'Owen va Claire phai cuu loai khung long khoi tuyet chung khi chung bi phan tan khap the gioi.', 147,
        '2022-06-10', '2022-12-10', 'Action, Adventure, Sci-Fi', 'Colin Trevorrow',
        'Chris Pratt, Bryce Dallas Howard, Laura Dern', 5.7,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528821/jurassic-world-dominion_m4dsqg.webp', 'https://www.youtube.com/watch?v=fb5ELWi-ekk', FALSE),
       ('Minions: The Rise of Gru',
        'Gru, mot cau be 12 tuoi, mo uoc tro thanh siêu ac nhan trong nhom ac nhan xau xa nhat the gioi.', 87,
        '2022-07-01', '2022-12-31', 'Animation, Comedy, Adventure', 'Kyle Balda',
        'Steve Carell, Pierre Coffin, Alan Arkin', 6.5,
        'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528819/minions-rise-of-gru_ifry6o.jpg', 'https://www.youtube.com/watch?v=6DxjJzmYsXo', FALSE),
       ('Everything Everywhere All at Once',
        'Mot phu nu Trung Quoc My phai cuu the gioi bang cach ket noi voi cac phien ban khac cua minh trong nhieu vu tru.', 139,
        '2022-03-25', '2022-09-25', 'Action, Comedy, Drama', 'Daniel Kwan, Daniel Scheinert',
        'Michelle Yeoh, Stephanie Hsu, Ke Huy Quan', 8.1,
        'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528820/everything-everywhere-all-at-once_berquk.webp', 'https://www.youtube.com/watch?v=wxN1T1uxQ2g', FALSE),
       ('The Matrix Resurrections',
        'Neo phai quay lai Matrix de tim ra su that ve thuc te cua minh.', 148,
        '2021-12-22', '2022-06-22', 'Action, Sci-Fi', 'Lana Wachowski',
        'Keanu Reeves, Carrie-Anne Moss, Yahya Abdul-Mateen II', 5.7,
        'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528821/the-matrix-resurrections_dvtwfs.webp', 'https://www.youtube.com/watch?v=9ix7TUGVYIo', FALSE),
       ('Encanto',
        'Mot gia dinh Colombia ky dieu song trong mot ngoi nha ma thuat, nhung mot cô gai tre khong co phep thuat.', 102,
        '2021-11-24', '2022-05-24', 'Animation, Comedy, Family', 'Byron Howard, Jared Bush',
        'Stephanie Beatriz, Maria Cecilia Botero, John Leguizamo', 7.3,
        'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528820/encanto_rfor26.jpg', 'https://www.youtube.com/watch?v=CaimKeDcudo', FALSE),
       ('Free Guy',
        'Mot nhan vat trong game khong biet minh la AI, quyet dinh tro thanh anh hung va cuu the gioi cua minh.', 115,
        '2021-08-13', '2022-02-13', 'Action, Comedy, Sci-Fi', 'Shawn Levy',
        'Ryan Reynolds, Jodie Comer, Taika Waititi', 7.1,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528820/free-guy_yzsdmt.jpg', 'https://www.youtube.com/watch?v=X2m-08cOAbc', FALSE),
       ('Cruella',
        'Cau chuyen ve nguon goc cua Cruella de Vil, mot thiet ke thoi trang tai nang nhung ac doc.', 134,
        '2021-05-28', '2021-11-28', 'Comedy, Crime', 'Craig Gillespie',
        'Emma Stone, Emma Thompson, Joel Fry', 7.3,
        'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528822/cruella_yoz4oa.webp', 'https://www.youtube.com/watch?v=gmRKv7n2If8', FALSE),
       ('Luca',
        'Cau be nguoi ca Luca trai nghiem mot mua he ky dieu o Riviera, Italy cung nguoi ban moi cua minh.', 95,
        '2021-06-18', '2021-12-18', 'Animation, Comedy, Family', 'Enrico Casarosa',
        'Jacob Tremblay, Jack Dylan Grazer, Emma Berman', 7.5,
        'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1762528820/luca_gljmav.webp', 'https://www.youtube.com/watch?v=mYfJxlgR2jw', FALSE),

-- Phim mới - Đang chiếu (releaseDate < 2025-11-19, endDate > 2025-11-19) - set active = TRUE
('Deadpool & Wolverine', 'Deadpool và Wolverine hợp tác trong cuộc phiêu lưu đầy máu và bạo lực qua đa vũ trụ.', 127, '2025-10-15', '2025-12-15', 'Action, Comedy, Superhero', 'Shawn Levy', 'Ryan Reynolds, Hugh Jackman, Emma Corrin', 8.5, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565788/deadpool-wolverine_nikxbk.webp', 'https://www.youtube.com/watch?v=example1', TRUE),
('Gladiator 2', 'Câu chuyện tiếp theo về đấu sĩ La Mã cổ đại, cuộc chiến vì danh dự và tự do.', 158, '2025-10-20', '2025-12-20', 'Action, Drama, Historical', 'Ridley Scott', 'Paul Mescal, Denzel Washington, Pedro Pascal', 8.2, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565798/gladiator-2_ngopue.webp', 'https://www.youtube.com/watch?v=example2', TRUE),
('Beetlejuice Beetlejuice', 'Beetlejuice trở lại với những trò đùa quỷ quái và phiêu lưu siêu nhiên mới.', 115, '2025-10-25', '2025-12-25', 'Comedy, Fantasy, Horror', 'Tim Burton', 'Michael Keaton, Winona Ryder, Jenna Ortega', 7.8, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565786/beetlejuice-beetlejuice_ej0k3o.webp', 'https://www.youtube.com/watch?v=example3', TRUE),
('Transformers One', 'Nguồn gốc của cuộc chiến giữa Autobots và Decepticons trên Cybertron.', 104, '2025-10-30', '2025-12-30', 'Animation, Action, Sci-Fi', 'Josh Cooley', 'Chris Hemsworth, Scarlett Johansson, Brian Tyree Henry', 7.5, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565716/transformers-one_yqwqy2.webp', 'https://www.youtube.com/watch?v=example4', TRUE),
('The Wild Robot', 'Robot bị mắc kẹt trên đảo hoang phải học cách sống sót và kết bạn với động vật.', 102, '2025-11-01', '2025-12-31', 'Animation, Adventure, Family', 'Chris Sanders', 'Lupita Nyong''o, Pedro Pascal, Catherine O''Hara', 8.0, 'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565714/the-wild-robot_k0wbmh.webp', 'https://www.youtube.com/watch?v=example5', TRUE),
('Wicked', 'Câu chuyện tiền truyện của The Wizard of Oz, về Elphaba và Glinda.', 142, '2025-11-05', '2025-12-25', 'Musical, Fantasy, Drama', 'Jon M. Chu', 'Ariana Grande, Cynthia Erivo, Jonathan Bailey', 8.3, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565716/wicked_mfg7np.webp', 'https://www.youtube.com/watch?v=example6', TRUE),
('Moana 2', 'Moana trở lại với cuộc hành trình mới trên biển cả, khám phá những hòn đảo bí ẩn.', 107, '2025-11-08', '2025-12-28', 'Animation, Adventure, Musical', 'David G. Derrick Jr.', 'Auli''i Cravalho, Dwayne Johnson, Alan Tudyk', 8.1, 'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565703/moana-2_a1ixcy.webp', 'https://www.youtube.com/watch?v=example7', TRUE),
('Mufasa: The Lion King', 'Câu chuyện về nguồn gốc của Mufasa, vị vua vĩ đại của Pride Lands.', 98, '2025-11-10', '2025-12-20', 'Animation, Adventure, Drama', 'Barry Jenkins', 'Aaron Pierre, Kelvin Harrison Jr., Seth Rogen', 7.9, 'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565702/mufasa-lion-king_tclwla.webp', 'https://www.youtube.com/watch?v=example8', TRUE),
('Smile 2', 'Tiếp nối câu chuyện kinh dị về nụ cười đáng sợ lan truyền như virus.', 118, '2025-11-12', '2025-12-22', 'Horror, Thriller', 'Parker Finn', 'Naomi Scott, Kyle Gallner, Rosemarie DeWitt', 6.8, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565704/smile-2_xzcyx8.webp', 'https://www.youtube.com/watch?v=example9', TRUE),
('The Substance', 'Phim kinh dị khoa học viễn tưởng về một chất liệu bí ẩn thay đổi con người.', 131, '2025-11-15', '2025-12-15', 'Horror, Sci-Fi, Thriller', 'Coralie Fargeat', 'Demi Moore, Margaret Qualley, Dennis Quaid', 7.2, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565714/the-substance_zqvstk.webp', 'https://www.youtube.com/watch?v=example10', TRUE),

-- Phim mới - Sắp chiếu (releaseDate từ 2025-11-19 đến 2025-12-19) - set active = TRUE
('Avatar 3', 'Jake Sully và gia đình tiếp tục cuộc chiến bảo vệ Pandora khỏi những mối đe dọa mới.', 195, '2025-11-19', '2026-02-19', 'Sci-Fi, Action, Adventure', 'James Cameron', 'Sam Worthington, Zoe Saldana, Sigourney Weaver', 0.0, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565786/avatar-3_nsx7pw.webp', 'https://www.youtube.com/watch?v=example11', TRUE),
('Superman: Legacy', 'Câu chuyện mới về Superman, người hùng bảo vệ Trái Đất khỏi những kẻ thù siêu nhiên.', 145, '2025-11-22', '2026-01-22', 'Action, Adventure, Superhero', 'James Gunn', 'David Corenswet, Rachel Brosnahan, Nicholas Hoult', 0.0, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565705/superman-legacy_oszlal.webp', 'https://www.youtube.com/watch?v=example12', TRUE),
('Thunderbolts', 'Nhóm siêu phản anh hùng hợp tác để thực hiện nhiệm vụ bí mật cho chính phủ.', 132, '2025-11-25', '2026-01-25', 'Action, Adventure, Superhero', 'Jake Schreier', 'Florence Pugh, Sebastian Stan, David Harbour', 0.0, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565716/thunderbolts_lexamn.webp', 'https://www.youtube.com/watch?v=example13', TRUE),
('Blade', 'Ma cà rồng daywalker trở lại để bảo vệ nhân loại khỏi bóng tối.', 128, '2025-11-28', '2026-01-28', 'Action, Horror, Superhero', 'Yann Demange', 'Mahershala Ali, Delroy Lindo, Aaron Pierre', 0.0, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565786/blade_xf5pyy.webp', 'https://www.youtube.com/watch?v=example14', TRUE),
('Inside Out 2', 'Riley lớn lên và những cảm xúc mới xuất hiện trong tâm trí cô.', 96, '2025-12-01', '2026-02-01', 'Animation, Comedy, Family', 'Kelsey Mann', 'Amy Poehler, Maya Hawke, Ayo Edebiri', 0.0, 'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565702/inside-out-2_sygwnd.webp', 'https://www.youtube.com/watch?v=example15', TRUE),
('Despicable Me 4', 'Gru và gia đình đối mặt với kẻ thù mới và những thử thách hài hước.', 88, '2025-12-05', '2026-02-05', 'Animation, Comedy, Family', 'Chris Renaud', 'Steve Carell, Kristen Wiig, Miranda Cosgrove', 0.0, 'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565787/despicable-me-4_rdyxjl.webp', 'https://www.youtube.com/watch?v=example16', TRUE),
('Sonic the Hedgehog 3', 'Sonic và bạn bè chiến đấu chống lại Shadow và những mối đe dọa mới.', 102, '2025-12-08', '2026-02-08', 'Action, Adventure, Comedy', 'Jeff Fowler', 'Ben Schwartz, Idris Elba, James Marsden', 0.0, 'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565704/sonic-hedgehog-3_nk9arb.webp', 'https://www.youtube.com/watch?v=example17', TRUE),
('Nosferatu', 'Bản làm lại kinh điển về ma cà rồng Nosferatu với góc nhìn hiện đại.', 134, '2025-12-10', '2026-02-10', 'Horror, Drama, Thriller', 'Robert Eggers', 'Bill Skarsgård, Lily-Rose Depp, Willem Dafoe', 0.0, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565702/nosferatu_hfeo1g.webp', 'https://www.youtube.com/watch?v=example18', TRUE),
('A Complete Unknown', 'Câu chuyện về Bob Dylan và hành trình trở thành huyền thoại âm nhạc.', 142, '2025-12-12', '2026-02-12', 'Biography, Drama, Music', 'James Mangold', 'Timothée Chalamet, Elle Fanning, Boyd Holbrook', 0.0, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565760/a-complete-unknown_x8yoah.webp', 'https://www.youtube.com/watch?v=example19', TRUE),
('The Amateur', 'Một nhân viên CIA nghiệp dư phải thực hiện nhiệm vụ nguy hiểm để cứu vợ.', 118, '2025-12-15', '2026-02-15', 'Action, Thriller', 'James Hawes', 'Rami Malek, Rachel Brosnahan, Julianne Nicholson', 0.0, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565705/the-amateur_bu08ff.webp', 'https://www.youtube.com/watch?v=example20', TRUE),
('Beverly Hills Cop: Axel F', 'Axel Foley trở lại Beverly Hills để giải quyết vụ án mới đầy nguy hiểm.', 115, '2025-12-18', '2026-02-18', 'Action, Comedy, Crime', 'Mark Molloy', 'Eddie Murphy, Judge Reinhold, Kevin Bacon', 0.0, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565797/everly-hills-cop-axel-f_yztr2g.webp', 'https://www.youtube.com/watch?v=example21', TRUE),
('It Ends With Us', 'Câu chuyện tình yêu phức tạp về một phụ nữ phải đối mặt với quá khứ đau thương.', 125, '2025-12-19', '2026-02-19', 'Drama, Romance', 'Justin Baldoni', 'Blake Lively, Justin Baldoni, Jenny Slate', 0.0, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565702/it-ends-with-us_sw9lwc.webp', 'https://www.youtube.com/watch?v=example22', TRUE),
('Dune: Part Three', 'Phần cuối của câu chuyện về Paul Atreides và cuộc chiến trên Arrakis.', 165, '2025-12-20', '2026-03-20', 'Sci-Fi, Adventure, Drama', 'Denis Villeneuve', 'Timothée Chalamet, Zendaya, Rebecca Ferguson', 0.0, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565787/dune-part-three_n0fmhi.webp', 'https://www.youtube.com/watch?v=example23', TRUE),
('Kingdom of the Planet of the Apes', 'Câu chuyện tiếp theo về thế giới của loài khỉ thống trị Trái Đất.', 145, '2025-12-22', '2026-03-22', 'Sci-Fi, Action, Drama', 'Wes Ball', 'Owen Teague, Freya Allan, Kevin Durand', 0.0, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565703/kingdom-planet-apes_t2u5yj.webp', 'https://www.youtube.com/watch?v=example24', TRUE),
('Mission: Impossible 8', 'Ethan Hunt và nhóm IMF đối mặt với nhiệm vụ bất khả thi nhất từ trước đến nay.', 158, '2025-12-25', '2026-03-25', 'Action, Adventure, Thriller', 'Christopher McQuarrie', 'Tom Cruise, Hayley Atwell, Ving Rhames', 0.0, 'English', 'Vietnamese', 'PG-13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565704/mission-impossible-8_hpohxv.webp', 'https://www.youtube.com/watch?v=example25', TRUE),
('Red One', 'Câu chuyện về ông già Noel và đặc vụ phải cứu Giáng sinh khỏi mối đe dọa.', 112, '2025-12-28', '2026-02-28', 'Action, Adventure, Comedy', 'Jake Kasdan', 'Dwayne Johnson, Chris Evans, J.K. Simmons', 0.0, 'English', 'Vietnamese', 'PG', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565704/red-one_s2vkxg.webp', 'https://www.youtube.com/watch?v=example26', TRUE),
('The Strangers: Chapter 1', 'Một cặp đôi bị tấn công bởi những kẻ lạ mặt đáng sợ trong nhà nghỉ.', 91, '2025-12-30', '2026-02-28', 'Horror, Thriller', 'Renny Harlin', 'Madelaine Petsch, Froy Gutierrez, Rachel Shenton', 0.0, 'English', 'Vietnamese', 'R', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565705/the-strangers-chapter-1_cggm6e.webp', 'https://www.youtube.com/watch?v=example27', TRUE),
('Lật Mặt 7: Một Điều Ước', 'Phần tiếp theo của series Lật Mặt với câu chuyện mới đầy kịch tính.', 120, '2025-11-20', '2026-01-20', 'Action, Drama, Crime', 'Lý Hải', 'Lý Hải, Hứa Vĩ Văn, Huỳnh Đông', 0.0, 'Vietnamese', 'Vietnamese', 'C18', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565703/lat-mat-7_aootj0.webp', 'https://www.youtube.com/watch?v=example28', TRUE),
('Đất Rừng Phương Nam', 'Câu chuyện về cuộc sống và chiến đấu của người dân miền Nam trong thời kỳ kháng chiến.', 135, '2025-12-01', '2026-02-01', 'Drama, Historical, War', 'Nguyễn Quang Dũng', 'Huỳnh Đông, Lê Giang, NSND Trần Nhượng', 0.0, 'Vietnamese', 'Vietnamese', 'C16', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565787/dat-rung-phuong-nam_sn74cp.webp', 'https://www.youtube.com/watch?v=example29', TRUE),
('Bố Già 2', 'Phần tiếp theo của Bố Già với những tình huống hài hước và cảm động mới.', 110, '2025-12-10', '2026-02-10', 'Comedy, Drama, Family', 'Vũ Ngọc Đãng', 'Trấn Thành, Lê Giang, Ngọc Giàu', 0.0, 'Vietnamese', 'Vietnamese', 'C13', 'https://res.cloudinary.com/dq2xy9j7j/image/upload/v1763565788/bo-gia-2_h5prds.jpg', 'https://www.youtube.com/watch?v=example30', TRUE);

-- =============================================
-- Update is_active cho các phim hiện có (nếu chưa được set)
-- =============================================
-- Cập nhật phim cũ (end_date < 2025-11-19) thành inactive
UPDATE movies 
SET is_active = FALSE 
WHERE is_active IS NULL
  AND (
    (end_date IS NOT NULL AND end_date < '2025-11-19') 
    OR (end_date IS NULL AND release_date < '2023-01-01')
  );

-- Cập nhật phim đang chiếu (release_date <= 2025-11-19 và end_date >= 2025-11-19) thành active
UPDATE movies 
SET is_active = TRUE 
WHERE is_active IS NULL
  AND release_date <= '2025-11-19' 
  AND (end_date IS NULL OR end_date >= '2025-11-19');

-- Cập nhật phim sắp chiếu (release_date > 2025-11-19) thành active
UPDATE movies 
SET is_active = TRUE 
WHERE is_active IS NULL
  AND release_date > '2025-11-19';

-- Đảm bảo tất cả phim có is_active (nếu vẫn còn null, set mặc định là TRUE)
UPDATE movies 
SET is_active = TRUE 
WHERE is_active IS NULL;

-- =============================================
-- Update is_active cho các showtimes hiện có
-- =============================================
-- Set active = TRUE cho tất cả showtimes (vì showtimes đã được tạo với ngày trong tương lai)
UPDATE showtimes 
SET is_active = TRUE 
WHERE is_active IS NULL;

-- =============================================
-- Insert Showtimes
-- =============================================
-- Showtimes cho phim mới (đang chiếu và sắp chiếu) - Tháng 11-12/2025
-- Phim đang chiếu (movie_id 21-31): Deadpool & Wolverine, Gladiator 2, Beetlejuice, etc.
INSERT IGNORE INTO showtimes (movie_id, cinema_hall_id, show_date, start_time, end_time, price)
VALUES 
-- Deadpool & Wolverine (21) - Đang chiếu từ 15/10
(21, 1, '2025-11-20', '09:00:00', '11:07:00', 150000),
(21, 1, '2025-11-20', '12:00:00', '14:07:00', 150000),
(21, 1, '2025-11-20', '15:00:00', '17:07:00', 150000),
(21, 1, '2025-11-20', '18:00:00', '20:07:00', 180000),
(21, 1, '2025-11-20', '21:00:00', '23:07:00', 180000),
(21, 2, '2025-11-21', '10:00:00', '12:07:00', 150000),
(21, 2, '2025-11-21', '14:00:00', '16:07:00', 150000),
(21, 2, '2025-11-21', '19:00:00', '21:07:00', 180000),
(21, 3, '2025-11-22', '11:00:00', '13:07:00', 180000),
(21, 3, '2025-11-22', '16:00:00', '18:07:00', 180000),
(21, 3, '2025-11-22', '20:00:00', '22:07:00', 200000),

-- Gladiator 2 (22) - Đang chiếu từ 20/10
(22, 4, '2025-11-20', '09:30:00', '12:08:00', 140000),
(22, 4, '2025-11-20', '13:00:00', '15:38:00', 140000),
(22, 4, '2025-11-20', '16:30:00', '19:08:00', 160000),
(22, 4, '2025-11-20', '20:00:00', '22:38:00', 180000),
(22, 5, '2025-11-21', '10:30:00', '13:08:00', 160000),
(22, 5, '2025-11-21', '15:00:00', '17:38:00', 160000),
(22, 5, '2025-11-21', '19:30:00', '22:08:00', 200000),

-- Beetlejuice Beetlejuice (23) - Đang chiếu từ 25/10
(23, 6, '2025-11-20', '09:00:00', '10:55:00', 120000),
(23, 6, '2025-11-20', '12:00:00', '13:55:00', 120000),
(23, 6, '2025-11-20', '15:00:00', '16:55:00', 140000),
(23, 6, '2025-11-20', '18:00:00', '19:55:00', 160000),
(23, 6, '2025-11-20', '21:00:00', '22:55:00', 160000),
(23, 7, '2025-11-21', '10:00:00', '11:55:00', 120000),
(23, 7, '2025-11-21', '14:00:00', '15:55:00', 140000),
(23, 7, '2025-11-21', '19:00:00', '20:55:00', 160000),

-- Transformers One (24) - Đang chiếu từ 30/10
(24, 8, '2025-11-20', '09:00:00', '10:44:00', 130000),
(24, 8, '2025-11-20', '12:00:00', '13:44:00', 130000),
(24, 8, '2025-11-20', '15:00:00', '16:44:00', 150000),
(24, 8, '2025-11-20', '18:00:00', '19:44:00', 170000),
(24, 1, '2025-11-21', '10:00:00', '11:44:00', 130000),
(24, 1, '2025-11-21', '14:00:00', '15:44:00', 150000),
(24, 1, '2025-11-21', '19:00:00', '20:44:00', 170000),

-- The Wild Robot (25) - Đang chiếu từ 1/11
(25, 2, '2025-11-20', '09:00:00', '10:42:00', 110000),
(25, 2, '2025-11-20', '12:00:00', '13:42:00', 110000),
(25, 2, '2025-11-20', '15:00:00', '16:42:00', 130000),
(25, 2, '2025-11-20', '18:00:00', '19:42:00', 150000),
(25, 3, '2025-11-21', '10:00:00', '11:42:00', 110000),
(25, 3, '2025-11-21', '14:00:00', '15:42:00', 130000),
(25, 3, '2025-11-21', '19:00:00', '20:42:00', 150000),

-- Wicked (26) - Đang chiếu từ 5/11
(26, 4, '2025-11-20', '09:00:00', '11:22:00', 140000),
(26, 4, '2025-11-20', '13:00:00', '15:22:00', 140000),
(26, 4, '2025-11-20', '17:00:00', '19:22:00', 160000),
(26, 4, '2025-11-20', '20:00:00', '22:22:00', 180000),
(26, 5, '2025-11-21', '10:00:00', '12:22:00', 140000),
(26, 5, '2025-11-21', '15:00:00', '17:22:00', 160000),
(26, 5, '2025-11-21', '19:00:00', '21:22:00', 180000),

-- Moana 2 (27) - Đang chiếu từ 8/11
(27, 6, '2025-11-20', '09:00:00', '10:47:00', 120000),
(27, 6, '2025-11-20', '12:00:00', '13:47:00', 120000),
(27, 6, '2025-11-20', '15:00:00', '16:47:00', 140000),
(27, 6, '2025-11-20', '18:00:00', '19:47:00', 160000),
(27, 7, '2025-11-21', '10:00:00', '11:47:00', 120000),
(27, 7, '2025-11-21', '14:00:00', '15:47:00', 140000),
(27, 7, '2025-11-21', '19:00:00', '20:47:00', 160000),

-- Mufasa: The Lion King (28) - Đang chiếu từ 10/11
(28, 8, '2025-11-20', '09:00:00', '10:38:00', 110000),
(28, 8, '2025-11-20', '12:00:00', '13:38:00', 110000),
(28, 8, '2025-11-20', '15:00:00', '16:38:00', 130000),
(28, 8, '2025-11-20', '18:00:00', '19:38:00', 150000),
(28, 1, '2025-11-21', '10:00:00', '11:38:00', 110000),
(28, 1, '2025-11-21', '14:00:00', '15:38:00', 130000),
(28, 1, '2025-11-21', '19:00:00', '20:38:00', 150000),

-- Smile 2 (29) - Đang chiếu từ 12/11
(29, 2, '2025-11-20', '09:00:00', '10:58:00', 130000),
(29, 2, '2025-11-20', '13:00:00', '14:58:00', 130000),
(29, 2, '2025-11-20', '17:00:00', '18:58:00', 150000),
(29, 2, '2025-11-20', '21:00:00', '22:58:00', 170000),
(29, 3, '2025-11-21', '10:00:00', '11:58:00', 130000),
(29, 3, '2025-11-21', '15:00:00', '16:58:00', 150000),
(29, 3, '2025-11-21', '20:00:00', '21:58:00', 170000),

-- The Substance (30) - Đang chiếu từ 15/11
(30, 4, '2025-11-20', '09:00:00', '11:11:00', 130000),
(30, 4, '2025-11-20', '13:00:00', '15:11:00', 130000),
(30, 4, '2025-11-20', '17:00:00', '19:11:00', 150000),
(30, 4, '2025-11-20', '21:00:00', '23:11:00', 170000),
(30, 5, '2025-11-21', '10:00:00', '12:11:00', 130000),
(30, 5, '2025-11-21', '15:00:00', '17:11:00', 150000),
(30, 5, '2025-11-21', '20:00:00', '22:11:00', 170000),

-- Phim sắp chiếu (movie_id 32-46) - Từ 19/11 trở đi
-- Avatar 3 (32) - Sắp chiếu từ 19/11
(32, 1, '2025-11-19', '09:00:00', '12:15:00', 180000),
(32, 1, '2025-11-19', '13:00:00', '16:15:00', 180000),
(32, 1, '2025-11-19', '17:00:00', '20:15:00', 200000),
(32, 1, '2025-11-19', '21:00:00', '00:15:00', 220000),
(32, 2, '2025-11-20', '10:00:00', '13:15:00', 180000),
(32, 2, '2025-11-20', '15:00:00', '18:15:00', 200000),
(32, 2, '2025-11-20', '19:00:00', '22:15:00', 220000),
(32, 3, '2025-11-21', '11:00:00', '14:15:00', 200000),
(32, 3, '2025-11-21', '16:00:00', '19:15:00', 220000),
(32, 3, '2025-11-21', '20:00:00', '23:15:00', 240000),

-- Superman: Legacy (33) - Sắp chiếu từ 22/11
(33, 4, '2025-11-22', '09:00:00', '11:25:00', 160000),
(33, 4, '2025-11-22', '13:00:00', '15:25:00', 160000),
(33, 4, '2025-11-22', '17:00:00', '19:25:00', 180000),
(33, 4, '2025-11-22', '20:00:00', '22:25:00', 200000),
(33, 5, '2025-11-23', '10:00:00', '12:25:00', 160000),
(33, 5, '2025-11-23', '15:00:00', '17:25:00', 180000),
(33, 5, '2025-11-23', '19:00:00', '21:25:00', 200000),

-- Thunderbolts (34) - Sắp chiếu từ 25/11
(34, 6, '2025-11-25', '09:00:00', '11:12:00', 150000),
(34, 6, '2025-11-25', '13:00:00', '15:12:00', 150000),
(34, 6, '2025-11-25', '17:00:00', '19:12:00', 170000),
(34, 6, '2025-11-25', '20:00:00', '22:12:00', 190000),
(34, 7, '2025-11-26', '10:00:00', '12:12:00', 150000),
(34, 7, '2025-11-26', '15:00:00', '17:12:00', 170000),
(34, 7, '2025-11-26', '19:00:00', '21:12:00', 190000),

-- Blade (35) - Sắp chiếu từ 28/11
(35, 8, '2025-11-28', '09:00:00', '11:08:00', 150000),
(35, 8, '2025-11-28', '13:00:00', '15:08:00', 150000),
(35, 8, '2025-11-28', '17:00:00', '19:08:00', 170000),
(35, 8, '2025-11-28', '21:00:00', '23:08:00', 190000),
(35, 1, '2025-11-29', '10:00:00', '12:08:00', 150000),
(35, 1, '2025-11-29', '15:00:00', '17:08:00', 170000),
(35, 1, '2025-11-29', '20:00:00', '22:08:00', 190000),

-- Inside Out 2 (36) - Sắp chiếu từ 1/12
(36, 2, '2025-12-01', '09:00:00', '10:36:00', 120000),
(36, 2, '2025-12-01', '12:00:00', '13:36:00', 120000),
(36, 2, '2025-12-01', '15:00:00', '16:36:00', 140000),
(36, 2, '2025-12-01', '18:00:00', '19:36:00', 160000),
(36, 3, '2025-12-02', '10:00:00', '11:36:00', 120000),
(36, 3, '2025-12-02', '14:00:00', '15:36:00', 140000),
(36, 3, '2025-12-02', '19:00:00', '20:36:00', 160000),

-- Despicable Me 4 (37) - Sắp chiếu từ 5/12
(37, 4, '2025-12-05', '09:00:00', '10:28:00', 120000),
(37, 4, '2025-12-05', '12:00:00', '13:28:00', 120000),
(37, 4, '2025-12-05', '15:00:00', '16:28:00', 140000),
(37, 4, '2025-12-05', '18:00:00', '19:28:00', 160000),
(37, 5, '2025-12-06', '10:00:00', '11:28:00', 120000),
(37, 5, '2025-12-06', '14:00:00', '15:28:00', 140000),
(37, 5, '2025-12-06', '19:00:00', '20:28:00', 160000),

-- Sonic the Hedgehog 3 (38) - Sắp chiếu từ 8/12
(38, 6, '2025-12-08', '09:00:00', '10:42:00', 130000),
(38, 6, '2025-12-08', '12:00:00', '13:42:00', 130000),
(38, 6, '2025-12-08', '15:00:00', '16:42:00', 150000),
(38, 6, '2025-12-08', '18:00:00', '19:42:00', 170000),
(38, 7, '2025-12-09', '10:00:00', '11:42:00', 130000),
(38, 7, '2025-12-09', '14:00:00', '15:42:00', 150000),
(38, 7, '2025-12-09', '19:00:00', '20:42:00', 170000),

-- Nosferatu (39) - Sắp chiếu từ 10/12
(39, 8, '2025-12-10', '09:00:00', '11:14:00', 140000),
(39, 8, '2025-12-10', '13:00:00', '15:14:00', 140000),
(39, 8, '2025-12-10', '17:00:00', '19:14:00', 160000),
(39, 8, '2025-12-10', '21:00:00', '23:14:00', 180000),
(39, 1, '2025-12-11', '10:00:00', '12:14:00', 140000),
(39, 1, '2025-12-11', '15:00:00', '17:14:00', 160000),
(39, 1, '2025-12-11', '20:00:00', '22:14:00', 180000),

-- A Complete Unknown (40) - Sắp chiếu từ 12/12
(40, 2, '2025-12-12', '09:00:00', '11:22:00', 140000),
(40, 2, '2025-12-12', '13:00:00', '15:22:00', 140000),
(40, 2, '2025-12-12', '17:00:00', '19:22:00', 160000),
(40, 2, '2025-12-12', '20:00:00', '22:22:00', 180000),
(40, 3, '2025-12-13', '10:00:00', '12:22:00', 140000),
(40, 3, '2025-12-13', '15:00:00', '17:22:00', 160000),
(40, 3, '2025-12-13', '19:00:00', '21:22:00', 180000),

-- The Amateur (41) - Sắp chiếu từ 15/12
(41, 4, '2025-12-15', '09:00:00', '10:58:00', 130000),
(41, 4, '2025-12-15', '13:00:00', '14:58:00', 130000),
(41, 4, '2025-12-15', '17:00:00', '18:58:00', 150000),
(41, 4, '2025-12-15', '21:00:00', '22:58:00', 170000),
(41, 5, '2025-12-16', '10:00:00', '11:58:00', 130000),
(41, 5, '2025-12-16', '15:00:00', '16:58:00', 150000),
(41, 5, '2025-12-16', '20:00:00', '21:58:00', 170000),

-- Beverly Hills Cop: Axel F (42) - Sắp chiếu từ 18/12
(42, 6, '2025-12-18', '09:00:00', '10:55:00', 130000),
(42, 6, '2025-12-18', '13:00:00', '14:55:00', 130000),
(42, 6, '2025-12-18', '17:00:00', '18:55:00', 150000),
(42, 6, '2025-12-18', '20:00:00', '21:55:00', 170000),
(42, 7, '2025-12-19', '10:00:00', '11:55:00', 130000),
(42, 7, '2025-12-19', '15:00:00', '16:55:00', 150000),
(42, 7, '2025-12-19', '19:00:00', '20:55:00', 170000),

-- It Ends With Us (43) - Sắp chiếu từ 19/12
(43, 8, '2025-12-19', '09:00:00', '11:05:00', 130000),
(43, 8, '2025-12-19', '13:00:00', '15:05:00', 130000),
(43, 8, '2025-12-19', '17:00:00', '19:05:00', 150000),
(43, 8, '2025-12-19', '20:00:00', '22:05:00', 170000),
(43, 1, '2025-12-20', '10:00:00', '12:05:00', 130000),
(43, 1, '2025-12-20', '15:00:00', '17:05:00', 150000),
(43, 1, '2025-12-20', '19:00:00', '21:05:00', 170000),

-- Dune: Part Three (44) - Sắp chiếu từ 20/12
(44, 2, '2025-12-20', '09:00:00', '11:45:00', 170000),
(44, 2, '2025-12-20', '13:00:00', '15:45:00', 170000),
(44, 2, '2025-12-20', '17:00:00', '19:45:00', 190000),
(44, 2, '2025-12-20', '20:00:00', '22:45:00', 210000),
(44, 3, '2025-12-21', '10:00:00', '12:45:00', 170000),
(44, 3, '2025-12-21', '15:00:00', '17:45:00', 190000),
(44, 3, '2025-12-21', '19:00:00', '21:45:00', 210000),

-- Kingdom of the Planet of the Apes (45) - Sắp chiếu từ 22/12
(45, 4, '2025-12-22', '09:00:00', '11:25:00', 150000),
(45, 4, '2025-12-22', '13:00:00', '15:25:00', 150000),
(45, 4, '2025-12-22', '17:00:00', '19:25:00', 170000),
(45, 4, '2025-12-22', '20:00:00', '22:25:00', 190000),
(45, 5, '2025-12-23', '10:00:00', '12:25:00', 150000),
(45, 5, '2025-12-23', '15:00:00', '17:25:00', 170000),
(45, 5, '2025-12-23', '19:00:00', '21:25:00', 190000),

-- Mission: Impossible 8 (46) - Sắp chiếu từ 25/12
(46, 6, '2025-12-25', '09:00:00', '11:38:00', 160000),
(46, 6, '2025-12-25', '13:00:00', '15:38:00', 160000),
(46, 6, '2025-12-25', '17:00:00', '19:38:00', 180000),
(46, 6, '2025-12-25', '20:00:00', '22:38:00', 200000),
(46, 7, '2025-12-26', '10:00:00', '12:38:00', 160000),
(46, 7, '2025-12-26', '15:00:00', '17:38:00', 180000),
(46, 7, '2025-12-26', '19:00:00', '21:38:00', 200000),

-- Red One (47) - Sắp chiếu từ 28/12
(47, 8, '2025-12-28', '09:00:00', '10:52:00', 130000),
(47, 8, '2025-12-28', '13:00:00', '14:52:00', 130000),
(47, 8, '2025-12-28', '17:00:00', '18:52:00', 150000),
(47, 8, '2025-12-28', '20:00:00', '21:52:00', 170000),
(47, 1, '2025-12-29', '10:00:00', '11:52:00', 130000),
(47, 1, '2025-12-29', '15:00:00', '16:52:00', 150000),
(47, 1, '2025-12-29', '19:00:00', '20:52:00', 170000),

-- The Strangers: Chapter 1 (48) - Sắp chiếu từ 30/12
(48, 2, '2025-12-30', '09:00:00', '10:31:00', 130000),
(48, 2, '2025-12-30', '13:00:00', '14:31:00', 130000),
(48, 2, '2025-12-30', '17:00:00', '18:31:00', 150000),
(48, 2, '2025-12-30', '21:00:00', '22:31:00', 170000),
(48, 3, '2025-12-31', '10:00:00', '11:31:00', 130000),
(48, 3, '2025-12-31', '15:00:00', '16:31:00', 150000),
(48, 3, '2025-12-31', '20:00:00', '21:31:00', 170000),

-- Lật Mặt 7 (49) - Sắp chiếu từ 20/11
(49, 4, '2025-11-20', '09:00:00', '11:00:00', 120000),
(49, 4, '2025-11-20', '13:00:00', '15:00:00', 120000),
(49, 4, '2025-11-20', '17:00:00', '19:00:00', 140000),
(49, 4, '2025-11-20', '20:00:00', '22:00:00', 160000),
(49, 5, '2025-11-21', '10:00:00', '12:00:00', 120000),
(49, 5, '2025-11-21', '15:00:00', '17:00:00', 140000),
(49, 5, '2025-11-21', '19:00:00', '21:00:00', 160000),

-- Đất Rừng Phương Nam (50) - Sắp chiếu từ 1/12
(50, 6, '2025-12-01', '09:00:00', '11:15:00', 110000),
(50, 6, '2025-12-01', '13:00:00', '15:15:00', 110000),
(50, 6, '2025-12-01', '17:00:00', '19:15:00', 130000),
(50, 6, '2025-12-01', '20:00:00', '22:15:00', 150000),
(50, 7, '2025-12-02', '10:00:00', '12:15:00', 110000),
(50, 7, '2025-12-02', '15:00:00', '17:15:00', 130000),
(50, 7, '2025-12-02', '19:00:00', '21:15:00', 150000),

-- Bố Già 2 (51) - Sắp chiếu từ 10/12
(51, 8, '2025-12-10', '09:00:00', '10:50:00', 110000),
(51, 8, '2025-12-10', '13:00:00', '14:50:00', 110000),
(51, 8, '2025-12-10', '17:00:00', '18:50:00', 130000),
(51, 8, '2025-12-10', '20:00:00', '21:50:00', 150000),
(51, 1, '2025-12-11', '10:00:00', '11:50:00', 110000),
(51, 1, '2025-12-11', '15:00:00', '16:50:00', 130000),
(51, 1, '2025-12-11', '19:00:00', '20:50:00', 150000),

-- Thêm showtimes cho các ngày tiếp theo trong tháng 11-12
-- Các suất chiếu bổ sung cho tháng 11
(21, 3, '2025-11-23', '11:00:00', '13:07:00', 150000),
(21, 3, '2025-11-23', '16:00:00', '18:07:00', 180000),
(21, 3, '2025-11-23', '20:00:00', '22:07:00', 200000),
(22, 6, '2025-11-24', '10:30:00', '13:08:00', 160000),
(22, 6, '2025-11-24', '15:00:00', '17:38:00', 160000),
(22, 6, '2025-11-24', '19:30:00', '22:08:00', 200000),
(23, 7, '2025-11-25', '10:00:00', '11:55:00', 120000),
(23, 7, '2025-11-25', '14:00:00', '15:55:00', 140000),
(23, 7, '2025-11-25', '19:00:00', '20:55:00', 160000),
(24, 8, '2025-11-26', '10:00:00', '11:44:00', 130000),
(24, 8, '2025-11-26', '14:00:00', '15:44:00', 150000),
(24, 8, '2025-11-26', '19:00:00', '20:44:00', 170000),
(25, 1, '2025-11-27', '10:00:00', '11:42:00', 110000),
(25, 1, '2025-11-27', '14:00:00', '15:42:00', 130000),
(25, 1, '2025-11-27', '19:00:00', '20:42:00', 150000),
(26, 2, '2025-11-28', '10:00:00', '12:22:00', 140000),
(26, 2, '2025-11-28', '15:00:00', '17:22:00', 160000),
(26, 2, '2025-11-28', '19:00:00', '21:22:00', 180000),
(27, 3, '2025-11-29', '10:00:00', '11:47:00', 120000),
(27, 3, '2025-11-29', '14:00:00', '15:47:00', 140000),
(27, 3, '2025-11-29', '19:00:00', '20:47:00', 160000),
(28, 4, '2025-11-30', '10:00:00', '11:38:00', 110000),
(28, 4, '2025-11-30', '14:00:00', '15:38:00', 130000),
(28, 4, '2025-11-30', '19:00:00', '20:38:00', 150000),

-- Các suất chiếu bổ sung cho tháng 12
(32, 4, '2025-12-01', '10:00:00', '13:15:00', 180000),
(32, 4, '2025-12-01', '15:00:00', '18:15:00', 200000),
(32, 4, '2025-12-01', '19:00:00', '22:15:00', 220000),
(33, 6, '2025-12-02', '10:00:00', '12:25:00', 160000),
(33, 6, '2025-12-02', '15:00:00', '17:25:00', 180000),
(33, 6, '2025-12-02', '19:00:00', '21:25:00', 200000),
(34, 7, '2025-12-03', '10:00:00', '12:12:00', 150000),
(34, 7, '2025-12-03', '15:00:00', '17:12:00', 170000),
(34, 7, '2025-12-03', '19:00:00', '21:12:00', 190000),
(35, 8, '2025-12-04', '10:00:00', '12:08:00', 150000),
(35, 8, '2025-12-04', '15:00:00', '17:08:00', 170000),
(35, 8, '2025-12-04', '20:00:00', '22:08:00', 190000);

-- =============================================
-- Insert Seats (tạo ghế cho tất cả các phòng chiếu)
-- =============================================
-- Sử dụng recursive CTE để tạo ghế (MySQL 8.0+ / MariaDB 10.2+)
-- Phòng 1 - IMAX (200 ghế): 10 hàng x 20 ghế, hàng C-D là VIP
INSERT IGNORE INTO seats (cinema_hall_id, seat_number, seat_row, seat_type)
WITH RECURSIVE row_numbers AS (
    SELECT 1 as row_num
    UNION ALL
    SELECT row_num + 1 FROM row_numbers WHERE row_num < 10
),
seat_numbers AS (
    SELECT 1 as seat_num
    UNION ALL
    SELECT seat_num + 1 FROM seat_numbers WHERE seat_num < 20
)
SELECT 1, CONCAT(CHAR(ASCII('A') + row_num - 1), seat_num), CHAR(ASCII('A') + row_num - 1),
       CASE WHEN row_num BETWEEN 3 AND 4 THEN 'VIP' ELSE 'NORMAL' END
FROM row_numbers CROSS JOIN seat_numbers;

-- Phòng 2 - Standard (150 ghế): 10 hàng x 15 ghế, hàng C-D là VIP
INSERT IGNORE INTO seats (cinema_hall_id, seat_number, seat_row, seat_type)
WITH RECURSIVE row_numbers AS (
    SELECT 1 as row_num
    UNION ALL
    SELECT row_num + 1 FROM row_numbers WHERE row_num < 10
),
seat_numbers AS (
    SELECT 1 as seat_num
    UNION ALL
    SELECT seat_num + 1 FROM seat_numbers WHERE seat_num < 15
)
SELECT 2, CONCAT(CHAR(ASCII('A') + row_num - 1), seat_num), CHAR(ASCII('A') + row_num - 1),
       CASE WHEN row_num BETWEEN 3 AND 4 THEN 'VIP' ELSE 'NORMAL' END
FROM row_numbers CROSS JOIN seat_numbers;

-- Phòng 3 - VIP (100 ghế): 8 hàng x 12-13 ghế, tất cả VIP
INSERT IGNORE INTO seats (cinema_hall_id, seat_number, seat_row, seat_type)
WITH RECURSIVE row_numbers AS (
    SELECT 1 as row_num
    UNION ALL
    SELECT row_num + 1 FROM row_numbers WHERE row_num < 8
),
seat_numbers AS (
    SELECT 1 as seat_num
    UNION ALL
    SELECT seat_num + 1 FROM seat_numbers WHERE seat_num < 13
)
SELECT 3, CONCAT(CHAR(ASCII('A') + row_num - 1), seat_num), CHAR(ASCII('A') + row_num - 1), 'VIP'
FROM row_numbers CROSS JOIN seat_numbers
WHERE NOT (row_num IN (1, 8) AND seat_num > 12);

-- Phòng 4 - Standard (180 ghế): 12 hàng x 15 ghế, hàng D-F là VIP
INSERT IGNORE INTO seats (cinema_hall_id, seat_number, seat_row, seat_type)
WITH RECURSIVE row_numbers AS (
    SELECT 1 as row_num
    UNION ALL
    SELECT row_num + 1 FROM row_numbers WHERE row_num < 12
),
seat_numbers AS (
    SELECT 1 as seat_num
    UNION ALL
    SELECT seat_num + 1 FROM seat_numbers WHERE seat_num < 15
)
SELECT 4, CONCAT(CHAR(ASCII('A') + row_num - 1), seat_num), CHAR(ASCII('A') + row_num - 1),
       CASE WHEN row_num BETWEEN 4 AND 6 THEN 'VIP' ELSE 'NORMAL' END
FROM row_numbers CROSS JOIN seat_numbers;

-- Phòng 5 - VIP (80 ghế): 8 hàng x 10 ghế, tất cả VIP
INSERT IGNORE INTO seats (cinema_hall_id, seat_number, seat_row, seat_type)
WITH RECURSIVE row_numbers AS (
    SELECT 1 as row_num
    UNION ALL
    SELECT row_num + 1 FROM row_numbers WHERE row_num < 8
),
seat_numbers AS (
    SELECT 1 as seat_num
    UNION ALL
    SELECT seat_num + 1 FROM seat_numbers WHERE seat_num < 10
)
SELECT 5, CONCAT(CHAR(ASCII('A') + row_num - 1), seat_num), CHAR(ASCII('A') + row_num - 1), 'VIP'
FROM row_numbers CROSS JOIN seat_numbers;

-- Phòng 6 - Standard (160 ghế): 10 hàng x 16 ghế, hàng D-E là VIP
INSERT IGNORE INTO seats (cinema_hall_id, seat_number, seat_row, seat_type)
WITH RECURSIVE row_numbers AS (
    SELECT 1 as row_num
    UNION ALL
    SELECT row_num + 1 FROM row_numbers WHERE row_num < 10
),
seat_numbers AS (
    SELECT 1 as seat_num
    UNION ALL
    SELECT seat_num + 1 FROM seat_numbers WHERE seat_num < 16
)
SELECT 6, CONCAT(CHAR(ASCII('A') + row_num - 1), seat_num), CHAR(ASCII('A') + row_num - 1),
       CASE WHEN row_num BETWEEN 4 AND 5 THEN 'VIP' ELSE 'NORMAL' END
FROM row_numbers CROSS JOIN seat_numbers;

-- Phòng 7 - Standard (140 ghế): 10 hàng x 14 ghế, hàng D-E là VIP
INSERT IGNORE INTO seats (cinema_hall_id, seat_number, seat_row, seat_type)
WITH RECURSIVE row_numbers AS (
    SELECT 1 as row_num
    UNION ALL
    SELECT row_num + 1 FROM row_numbers WHERE row_num < 10
),
seat_numbers AS (
    SELECT 1 as seat_num
    UNION ALL
    SELECT seat_num + 1 FROM seat_numbers WHERE seat_num < 14
)
SELECT 7, CONCAT(CHAR(ASCII('A') + row_num - 1), seat_num), CHAR(ASCII('A') + row_num - 1),
       CASE WHEN row_num BETWEEN 4 AND 5 THEN 'VIP' ELSE 'NORMAL' END
FROM row_numbers CROSS JOIN seat_numbers;

-- Phòng 8 - 4DX (120 ghế): 8 hàng x 15 ghế, hàng C-E là VIP
INSERT IGNORE INTO seats (cinema_hall_id, seat_number, seat_row, seat_type)
WITH RECURSIVE row_numbers AS (
    SELECT 1 as row_num
    UNION ALL
    SELECT row_num + 1 FROM row_numbers WHERE row_num < 8
),
seat_numbers AS (
    SELECT 1 as seat_num
    UNION ALL
    SELECT seat_num + 1 FROM seat_numbers WHERE seat_num < 15
)
SELECT 8, CONCAT(CHAR(ASCII('A') + row_num - 1), seat_num), CHAR(ASCII('A') + row_num - 1),
       CASE WHEN row_num BETWEEN 3 AND 5 THEN 'VIP' ELSE 'NORMAL' END
FROM row_numbers CROSS JOIN seat_numbers;

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
