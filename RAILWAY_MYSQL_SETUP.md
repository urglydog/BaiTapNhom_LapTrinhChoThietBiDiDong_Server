# 🚀 Railway MySQL Setup Guide

## 📋 Bước 1: Tạo Database trên Railway

### **1.1 Đăng nhập Railway**
- Truy cập: https://railway.app
- Đăng nhập bằng GitHub account

### **1.2 Tạo Project mới**
- Click **"New Project"**
- Chọn **"Provision MySQL"**
- Railway sẽ tự động tạo MySQL database

### **1.3 Lấy thông tin kết nối**
- Click vào MySQL service
- Tab **"Connect"** → Copy thông tin:
  - **Host**: `gondola.proxy.rlwy.net`
  - **Port**: `15325` (hoặc port khác)
  - **Database**: `railway`
  - **Username**: `root`
  - **Password**: `mzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm` (hoặc password khác)

## 🔧 Bước 2: Cấu hình Server (application.properties)

### **2.1 Cập nhật Database URL**
```properties
# Railway MySQL Configuration
spring.datasource.url=jdbc:mysql://gondola.proxy.rlwy.net:15325/railway?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=false&allowMultiQueries=true&defaultAuthenticationPlugin=mysql_native_password
spring.datasource.username=root
spring.datasource.password=mzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA/Hibernate Configuration
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.connection.characterEncoding=UTF-8
spring.jpa.properties.hibernate.connection.useUnicode=true
```

### **2.2 Cập nhật pom.xml**
```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.33</version>
</dependency>
```

## 🗄️ Bước 3: Cấu hình HeidiSQL

### **3.1 Tạo kết nối mới**
- Mở HeidiSQL
- Click **"New"** để tạo session mới

### **3.2 Cấu hình kết nối**
- **Network type**: `MySQL (TCP/IP)`
- **Hostname/IP**: `gondola.proxy.rlwy.net`
- **Port**: `15325`
- **Username**: `root`
- **Password**: `mzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm`
- **Database**: `railway`

### **3.3 Test kết nối**
- Click **"Open"** để test kết nối
- Nếu thành công, bạn sẽ thấy database `railway`

## 🚀 Bước 4: Deploy Application

### **4.1 Cập nhật application.properties**
```properties
# Railway Production
spring.datasource.url=${DATABASE_URL}
spring.datasource.username=${DB_USER}
spring.datasource.password=${DB_PASSWORD}
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# JPA Configuration
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
```

### **4.2 Deploy lên Railway**
- Connect GitHub repository
- Railway sẽ tự động build và deploy
- Database sẽ được tạo tự động bởi JPA

## 🔍 Bước 5: Kiểm tra kết quả

### **5.1 Kiểm tra Database**
- Mở HeidiSQL
- Kết nối đến Railway MySQL
- Kiểm tra các bảng được tạo:
  - `users`
  - `movies`
  - `cinemas`
  - `cinema_halls`
  - `showtimes`
  - `bookings`
  - `booking_items`
  - `seats`
  - `reviews`
  - `favourites`

### **5.2 Kiểm tra API**
- Test API endpoints:
  - `GET /api/movies` - Lấy danh sách phim
  - `GET /api/cinemas` - Lấy danh sách rạp
  - `GET /api/users` - Lấy danh sách user

## 📋 Checklist

- [ ] ✅ **Railway Account** - Đăng nhập thành công
- [ ] ✅ **MySQL Service** - Tạo và cấu hình
- [ ] ✅ **Connection Info** - Lấy được thông tin kết nối
- [ ] ✅ **HeidiSQL** - Kết nối thành công
- [ ] ✅ **Application** - Deploy thành công
- [ ] ✅ **Database** - JPA tạo bảng thành công
- [ ] ✅ **API** - Test endpoints thành công

## 🎯 Kết quả mong đợi

Sau khi setup:
- ✅ **Railway MySQL** - Database hoạt động
- ✅ **HeidiSQL** - Kết nối và quản lý database
- ✅ **JPA** - Tự động tạo bảng
- ✅ **API** - Tất cả endpoints hoạt động
- ✅ **Data** - Có thể insert/query data

## 📞 Support

Nếu gặp lỗi:
1. Kiểm tra Railway MySQL service status
2. Kiểm tra connection string trong application.properties
3. Kiểm tra HeidiSQL connection settings
4. Kiểm tra Railway deployment logs
