# Railway Database Setup Guide

## 🎯 Mục tiêu
Deploy database MSSQL lên Railway và kết nối với Spring Boot app.

## 📋 Bước 1: Tạo Database trên Railway

### 1.1. Đăng nhập Railway
```bash
# Cài đặt Railway CLI (nếu chưa có)
npm install -g @railway/cli

# Đăng nhập Railway
railway login
```

### 1.2. Tạo Project mới
```bash
# Tạo project mới
railway init

# Hoặc tạo từ GitHub repository
railway init --template
```

### 1.3. Thêm SQL Server Database
1. Vào [Railway Dashboard](https://railway.app)
2. Chọn project của bạn
3. Click **"New"** → **"Database"** → **"Add SQL Server"**
4. Railway sẽ tự động tạo database và cung cấp connection string

## 📋 Bước 2: Lấy Connection Information

### 2.1. Từ Railway Dashboard
1. Vào project → Database service
2. Click tab **"Variables"**
3. Copy các thông tin:
   - `DATABASE_URL`
   - `DB_HOST`
   - `DB_PORT` (1433)
   - `DB_NAME`
   - `DB_USER`
   - `DB_PASSWORD`

### 2.2. Từ Railway CLI
```bash
# Xem tất cả variables
railway variables

# Xem database connection
railway connect
```

## 📋 Bước 3: Chạy SQL Script

### 3.1. Sử dụng Railway CLI
```bash
# Connect vào database
railway connect

# Chạy script SQL
railway run sqlcmd -i movie_ticket_db_mssql.sql
```

### 3.2. Sử dụng Azure Data Studio
1. Download [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio)
2. Connect với thông tin từ Railway
3. Mở file `movie_ticket_db_mssql.sql`
4. Execute script

### 3.3. Sử dụng SQL Server Management Studio (SSMS)
1. Download [SSMS](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
2. Connect với thông tin từ Railway
3. Mở file `movie_ticket_db_mssql.sql`
4. Execute script

## 📋 Bước 4: Cấu hình Spring Boot

### 4.1. Environment Variables
Railway sẽ tự động set các biến môi trường:
```bash
# Railway tự động set
DATABASE_URL=sqlserver://host:port;database=name;user=user;password=pass
DB_HOST=your-host.railway.app
DB_PORT=1433
DB_NAME=your-database-name
DB_USER=your-username
DB_PASSWORD=your-password
```

### 4.2. Cập nhật application.properties
```properties
# Railway sẽ override với environment variables
spring.datasource.url=${DATABASE_URL}
spring.datasource.username=${DB_USER}
spring.datasource.password=${DB_PASSWORD}
spring.datasource.driver-class-name=com.microsoft.sqlserver.jdbc.SQLServerDriver

# JPA Configuration
spring.jpa.hibernate.ddl-auto=validate
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.SQLServerDialect
spring.jpa.properties.hibernate.connection.characterEncoding=UTF-8
spring.jpa.properties.hibernate.connection.useUnicode=true
```

## 📋 Bước 5: Deploy Application

### 5.1. Deploy từ GitHub
1. Push code lên GitHub
2. Railway sẽ tự động deploy khi có thay đổi

### 5.2. Deploy từ CLI
```bash
# Deploy application
railway up

# Xem logs
railway logs

# Restart nếu cần
railway restart
```

## 📋 Bước 6: Test Database

### 6.1. Test API Endpoints
```bash
# Test movies API
curl https://your-app.railway.app/api/movies

# Test cinemas API
curl https://your-app.railway.app/api/cinemas

# Test specific movie
curl https://your-app.railway.app/api/movies/1
```

### 6.2. Kiểm tra Database
```bash
# Connect vào database
railway connect

# Kiểm tra tables
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';

# Kiểm tra dữ liệu
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM movies;
SELECT COUNT(*) FROM cinemas;
```

## 🔧 Troubleshooting

### Lỗi Connection
```bash
# Kiểm tra database status
railway status

# Xem logs
railway logs

# Restart database
railway restart
```

### Lỗi SQL Script
```bash
# Kiểm tra syntax
sqlcmd -S localhost -U sa -P password -i movie_ticket_db_mssql.sql

# Chạy từng phần script
# 1. Tạo database
# 2. Tạo tables
# 3. Insert data
```

## 📝 Lưu ý quan trọng

1. **Database Collation**: Railway SQL Server sử dụng collation mặc định
2. **Connection Pooling**: Railway tự động quản lý connections
3. **Backup**: Railway tự động backup database
4. **Scaling**: Railway tự động scale database theo nhu cầu

## 🎉 Kết quả mong đợi

Sau khi hoàn thành:
- ✅ Database MSSQL chạy trên Railway
- ✅ Spring Boot app kết nối thành công
- ✅ API trả về dữ liệu tiếng Việt đúng
- ✅ Có thể truy cập từ bất kỳ đâu
