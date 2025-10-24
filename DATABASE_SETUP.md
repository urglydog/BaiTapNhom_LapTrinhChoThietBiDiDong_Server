# Database Setup Guide

## MySQL Database Setup

### 1. Cài đặt MySQL
- Cài đặt MySQL 8.0+ trên máy
- Đảm bảo MySQL service đang chạy

### 2. Tạo Database
```sql
CREATE DATABASE movie_ticket_db;
```

### 3. Cấu hình Application
File `application.properties` đã được cấu hình cho MySQL:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/movie_ticket_db
spring.datasource.username=sa
spring.datasource.password=sapassword
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
```

### 4. Chạy ứng dụng
```bash
mvn spring-boot:run
```

JPA sẽ tự động tạo tất cả bảng dựa trên Entity models.

### 5. Insert dữ liệu mẫu (tùy chọn)
Chạy script SQL để insert dữ liệu mẫu:
```bash
mysql -u sa -p movie_ticket_db < movie_ticket_db.sql
```

### 6. Test API
- `GET http://localhost:8080/api/movies` - Lấy tất cả phim
- `GET http://localhost:8080/api/movies/1` - Lấy phim theo ID
- `GET http://localhost:8080/api/cinemas` - Lấy tất cả rạp chiếu

## Lưu ý
- Script SQL đã được cập nhật để tương thích với MySQL
- Bảng `roles` đã được loại bỏ, role được lưu dưới dạng ENUM trong bảng `users`
- JPA sẽ tự động tạo bảng, không cần chạy script CREATE TABLE
