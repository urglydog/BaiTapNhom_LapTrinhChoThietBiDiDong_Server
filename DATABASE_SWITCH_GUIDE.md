# 🔄 Database Switch Guide

## 📋 Tổng quan

Hướng dẫn chuyển đổi giữa Local MySQL và Railway MySQL để test JPA.

## 🏠 Local MySQL Setup

### **Bước 1: Setup Local MySQL**
```bash
# Chạy script setup
setup_local_mysql.bat
```

### **Bước 2: Cấu hình application.properties**
```properties
# LOCAL MYSQL CONFIGURATION (Uncomment to use)
spring.datasource.url=jdbc:mysql://localhost:3306/movie_ticket_db?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=false&allowMultiQueries=true&defaultAuthenticationPlugin=mysql_native_password
spring.datasource.username=movieuser
spring.datasource.password=moviepassword
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# RAILWAY MYSQL CONFIGURATION (Comment out when using local)
#spring.datasource.url=jdbc:mysql://gondola.proxy.rlwy.net:15325/railway?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=false&allowMultiQueries=true&defaultAuthenticationPlugin=mysql_native_password
#spring.datasource.username=root
#spring.datasource.password=mzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm
#spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

### **Bước 3: Test Local Connection**
```bash
# Test kết nối local
mysql -u movieuser -pmoviepassword -e "USE movie_ticket_db; SELECT 1;"
```

## ☁️ Railway MySQL Setup

### **Bước 1: Test Railway Connection**
```bash
# Chạy script test
test_railway_mysql.bat
```

### **Bước 2: Cấu hình application.properties**
```properties
# LOCAL MYSQL CONFIGURATION (Comment out when using Railway)
#spring.datasource.url=jdbc:mysql://localhost:3306/movie_ticket_db?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=false&allowMultiQueries=true&defaultAuthenticationPlugin=mysql_native_password
#spring.datasource.username=movieuser
#spring.datasource.password=moviepassword
#spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver

# RAILWAY MYSQL CONFIGURATION (Uncomment to use)
spring.datasource.url=jdbc:mysql://gondola.proxy.rlwy.net:15325/railway?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=false&allowMultiQueries=true&defaultAuthenticationPlugin=mysql_native_password
spring.datasource.username=root
spring.datasource.password=mzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

### **Bước 3: Test Railway Connection**
```bash
# Test kết nối Railway
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm -e "SELECT 1;"
```

## 🔄 Quick Switch Commands

### **Switch to Local MySQL:**
```bash
# 1. Comment Railway config
# 2. Uncomment Local config
# 3. Run application
mvn spring-boot:run
```

### **Switch to Railway MySQL:**
```bash
# 1. Comment Local config
# 2. Uncomment Railway config
# 3. Run application
mvn spring-boot:run
```

## 🗄️ HeidiSQL Configuration

### **Local MySQL Connection:**
- **Network type**: `MySQL (TCP/IP)`
- **Hostname/IP**: `localhost`
- **Port**: `3306`
- **Username**: `movieuser`
- **Password**: `moviepassword`
- **Database**: `movie_ticket_db`

### **Railway MySQL Connection:**
- **Network type**: `MySQL (TCP/IP)`
- **Hostname/IP**: `gondola.proxy.rlwy.net`
- **Port**: `15325`
- **Username**: `root`
- **Password**: `mzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm`
- **Database**: `railway`

## 🚀 JPA Testing

### **Local Testing:**
1. **Setup Local MySQL** - `setup_local_mysql.bat`
2. **Configure Local** - Uncomment local config
3. **Run Application** - `mvn spring-boot:run`
4. **Check HeidiSQL** - Connect to local MySQL
5. **Verify Tables** - JPA tạo bảng tự động

### **Railway Testing:**
1. **Test Railway** - `test_railway_mysql.bat`
2. **Configure Railway** - Uncomment Railway config
3. **Run Application** - `mvn spring-boot:run`
4. **Check HeidiSQL** - Connect to Railway MySQL
5. **Verify Tables** - JPA tạo bảng tự động

## 📋 Checklist

### **Local MySQL:**
- [ ] ✅ **MySQL Service** - Running locally
- [ ] ✅ **Database** - `movie_ticket_db` created
- [ ] ✅ **User** - `movieuser` created with privileges
- [ ] ✅ **Connection** - Test successful
- [ ] ✅ **Application** - Configured for local
- [ ] ✅ **JPA** - Creates tables automatically

### **Railway MySQL:**
- [ ] ✅ **Railway Account** - Logged in
- [ ] ✅ **MySQL Service** - Provisioned on Railway
- [ ] ✅ **Connection** - Test successful
- [ ] ✅ **Application** - Configured for Railway
- [ ] ✅ **JPA** - Creates tables automatically

## 🎯 Kết quả mong đợi

### **Local MySQL:**
- ✅ **Database** - `movie_ticket_db` on localhost:3306
- ✅ **User** - `movieuser` with full privileges
- ✅ **JPA** - Tự động tạo bảng
- ✅ **HeidiSQL** - Kết nối local MySQL
- ✅ **API** - Hoạt động với local database

### **Railway MySQL:**
- ✅ **Database** - `railway` on Railway cloud
- ✅ **User** - `root` with full privileges
- ✅ **JPA** - Tự động tạo bảng
- ✅ **HeidiSQL** - Kết nối Railway MySQL
- ✅ **API** - Hoạt động với Railway database

## 📞 Support

Nếu gặp lỗi:
1. **Local**: Kiểm tra MySQL service, user privileges
2. **Railway**: Kiểm tra Railway service status, connection string
3. **JPA**: Kiểm tra entity models, hibernate configuration
4. **HeidiSQL**: Kiểm tra connection settings, firewall
