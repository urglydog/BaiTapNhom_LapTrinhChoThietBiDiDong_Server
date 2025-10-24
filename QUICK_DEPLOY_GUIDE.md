# 🚀 Quick Deploy Guide - Railway

## ⚡ Deploy nhanh trong 5 phút

### **Bước 1: Chuẩn bị**
```bash
# Cài đặt Railway CLI
npm install -g @railway/cli

# Login Railway
railway login
```

### **Bước 2: Tạo Project**
```bash
# Tạo project mới
railway init

# Hoặc tạo từ GitHub
railway init --template
```

### **Bước 3: Thêm Database**
1. Vào [Railway Dashboard](https://railway.app)
2. Chọn project của bạn
3. Click **"New"** → **"Database"** → **"Add MySQL"**
4. Đợi database được tạo (2-3 phút)

### **Bước 4: Chạy SQL Script**
```bash
# Chạy script tạo database (MySQL)
railway run mysql -i railway_mysql_setup.sql

# Hoặc sử dụng Railway CLI
railway run --service your-database-service mysql < railway_mysql_setup.sql
```

### **Bước 5: Deploy App**
```bash
# Deploy application
railway up

# Xem logs
railway logs
```

### **Bước 6: Test API**
```bash
# Test movies API
curl https://your-app.railway.app/api/movies

# Test cinemas API  
curl https://your-app.railway.app/api/cinemas
```

## 🔧 Troubleshooting

### Lỗi Database Connection
```bash
# Kiểm tra variables
railway variables

# Restart database
railway restart
```

### Lỗi SQL Script
```bash
# Kiểm tra database status
railway status

# Chạy lại script
railway run sqlcmd -i railway_database_setup.sql
```

### Lỗi Application
```bash
# Xem logs
railway logs

# Restart app
railway restart
```

## 📱 Test API Endpoints

Sau khi deploy thành công, test các API:

### **Movies API**
```bash
# Lấy tất cả phim
GET https://your-app.railway.app/api/movies

# Lấy phim theo ID
GET https://your-app.railway.app/api/movies/1
```

### **Cinemas API**
```bash
# Lấy tất cả rạp chiếu
GET https://your-app.railway.app/api/cinemas

# Lấy rạp chiếu theo ID
GET https://your-app.railway.app/api/cinemas/1
```

### **Showtimes API**
```bash
# Lấy lịch chiếu
GET https://your-app.railway.app/api/showtimes
```

## 🎯 Kết quả mong đợi

✅ **Database**: MSSQL chạy trên Railway  
✅ **Application**: Spring Boot app deployed  
✅ **API**: Trả về dữ liệu tiếng Việt đúng  
✅ **Access**: Có thể truy cập từ bất kỳ đâu  

## 📞 Support

Nếu gặp lỗi:
1. Kiểm tra logs: `railway logs`
2. Kiểm tra status: `railway status`
3. Restart services: `railway restart`
4. Xem Railway dashboard để debug

## 🎉 Chúc mừng!

Bạn đã deploy thành công Movie Ticket Booking System lên Railway! 🚀
