# Railway Deployment Guide

## Deploy Movie Ticket Booking System lên Railway

### 1. Chuẩn bị

#### **Cài đặt Railway CLI:**
```bash
npm install -g @railway/cli
```

#### **Login Railway:**
```bash
railway login
```

### 2. Tạo Project trên Railway

#### **Tạo project mới:**
```bash
railway init
```

#### **Hoặc tạo từ GitHub:**
1. Đẩy code lên GitHub repository
2. Vào [Railway.app](https://railway.app)
3. Click "New Project" → "Deploy from GitHub repo"
4. Chọn repository của bạn

### 3. Cấu hình Database

#### **Thêm MSSQL Database:**
1. Trong Railway dashboard, click "New" → "Database" → "Add SQL Server"
2. Railway sẽ tự động tạo database và cung cấp connection string

#### **Environment Variables:**
Railway sẽ tự động set các biến môi trường:
- `DATABASE_URL` - Full connection string
- `DB_HOST` - Database host
- `DB_PORT` - Database port (1433)
- `DB_NAME` - Database name
- `DB_USER` - Username
- `DB_PASSWORD` - Password

### 4. Cấu hình Application

#### **Environment Variables cần set:**
```bash
# Database (Railway tự động set)
DATABASE_URL=sqlserver://host:port;database=name;user=user;password=pass

# JWT Configuration
JWT_SECRET=movieTicketBookingSecretKey2024ForSecurityAndAuthenticationPurposesOnly
JWT_EXPIRATION=86400000

# Server Port (Railway tự động set)
PORT=8080
```

#### **Cập nhật application.properties:**
```properties
# Railway sẽ override với environment variables
spring.datasource.url=${DATABASE_URL}
spring.datasource.username=${DB_USER}
spring.datasource.password=${DB_PASSWORD}
```

### 5. Deploy

#### **Deploy từ CLI:**
```bash
railway up
```

#### **Deploy từ GitHub:**
1. Push code lên GitHub
2. Railway sẽ tự động deploy khi có thay đổi

### 6. Chạy Database Script

#### **Connect vào Railway database:**
```bash
# Lấy connection string từ Railway dashboard
railway connect
```

#### **Chạy script SQL:**
```bash
# Sử dụng sqlcmd hoặc Azure Data Studio
sqlcmd -S <host> -U <user> -P <password> -d <database> -i movie_ticket_db_mssql.sql
```

### 7. Test API

#### **API Endpoints:**
- `GET https://your-app.railway.app/api/movies` - Lấy tất cả phim
- `GET https://your-app.railway.app/api/movies/1` - Lấy phim theo ID
- `GET https://your-app.railway.app/api/cinemas` - Lấy tất cả rạp chiếu

### 8. Monitoring

#### **Railway Dashboard:**
- Xem logs: `railway logs`
- Xem metrics: Railway dashboard
- Restart app: `railway restart`

### 9. Troubleshooting

#### **Common Issues:**

1. **Database Connection Failed:**
   - Kiểm tra environment variables
   - Đảm bảo database đã được tạo

2. **Build Failed:**
   - Kiểm tra Java version (cần Java 17+)
   - Kiểm tra Maven dependencies

3. **App Crashed:**
   - Xem logs: `railway logs`
   - Kiểm tra memory usage

#### **Useful Commands:**
```bash
# Xem logs
railway logs

# Restart app
railway restart

# Xem environment variables
railway variables

# Connect database
railway connect
```

### 10. Production Tips

#### **Security:**
- Đổi JWT secret trong production
- Sử dụng strong passwords
- Enable SSL/TLS

#### **Performance:**
- Set `spring.jpa.hibernate.ddl-auto=validate` cho production
- Configure connection pooling
- Monitor database performance

#### **Scaling:**
- Railway tự động scale theo traffic
- Có thể upgrade plan để tăng resources
