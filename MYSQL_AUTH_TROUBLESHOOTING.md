# 🔧 MySQL Authentication Troubleshooting

## 🚨 Vấn đề hiện tại
```
!AuthenticationProvider.BadAuthenticationPlugin!
```

## ✅ Giải pháp

### **Bước 1: Fix MySQL Authentication**
```bash
# Chạy script fix authentication
fix_mysql_auth_local.bat
```

### **Bước 2: Test Connection**
```bash
# Test kết nối trước khi chạy app
test_local_connection.bat
```

### **Bước 3: Run Application**
```bash
# Chạy ứng dụng sau khi fix
run_app_local.bat
```

## 🔍 Nguyên nhân

### **1. MySQL Authentication Plugin:**
- **MySQL 8.0+** sử dụng `caching_sha2_password` mặc định
- **JDK 21** không tương thích với plugin này
- **Cần chuyển** sang `mysql_native_password`

### **2. User Configuration:**
- **User 'sa'** chưa được tạo với đúng authentication plugin
- **Privileges** chưa được grant đúng
- **Database** chưa được tạo

## 🛠️ Troubleshooting Steps

### **Bước 1: Kiểm tra MySQL Service**
```bash
# Kiểm tra MySQL service
net start mysql

# Kiểm tra MySQL version
mysql --version
```

### **Bước 2: Fix Authentication**
```bash
# Tạo user với mysql_native_password
mysql -u root -p -e "CREATE USER IF NOT EXISTS 'sa'@'localhost' IDENTIFIED WITH mysql_native_password BY 'sapassword';"

# Grant privileges
mysql -u root -p -e "GRANT ALL PRIVILEGES ON movie_ticket_db.* TO 'sa'@'localhost';"
mysql -u root -p -e "FLUSH PRIVILEGES;"
```

### **Bước 3: Test Connection**
```bash
# Test kết nối
mysql -u sa -psapassword -e "USE movie_ticket_db; SELECT 1;"
```

### **Bước 4: Run Application**
```bash
# Chạy ứng dụng
mvn spring-boot:run
```

## 🔧 Advanced Fixes

### **Fix 1: MySQL Configuration**
```sql
-- Tạo user với mysql_native_password
CREATE USER 'sa'@'localhost' IDENTIFIED WITH mysql_native_password BY 'sapassword';
CREATE USER 'sa'@'%' IDENTIFIED WITH mysql_native_password BY 'sapassword';

-- Grant privileges
GRANT ALL PRIVILEGES ON movie_ticket_db.* TO 'sa'@'localhost';
GRANT ALL PRIVILEGES ON movie_ticket_db.* TO 'sa'@'%';
FLUSH PRIVILEGES;
```

### **Fix 2: Application Properties**
```properties
# Đảm bảo connection string đúng
spring.datasource.url=jdbc:mysql://localhost:3306/movie_ticket_db?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=false&allowMultiQueries=true&defaultAuthenticationPlugin=mysql_native_password
spring.datasource.username=sa
spring.datasource.password=sapassword
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
```

### **Fix 3: MySQL Service**
```bash
# Restart MySQL service
net stop mysql
net start mysql

# Test connection
mysql -u sa -psapassword -e "SELECT 1;"
```

## 📋 Checklist

- [ ] ✅ **MySQL Service** - Running locally
- [ ] ✅ **Database** - `movie_ticket_db` created
- [ ] ✅ **User 'sa'** - Created with mysql_native_password
- [ ] ✅ **Privileges** - Granted to user 'sa'
- [ ] ✅ **Connection** - Test successful
- [ ] ✅ **Application** - Configured correctly
- [ ] ✅ **JPA** - Ready to create tables

## 🎯 Kết quả mong đợi

Sau khi fix:
- ✅ **MySQL Authentication** - mysql_native_password working
- ✅ **User 'sa'** - Can connect and access database
- ✅ **JPA** - Creates tables automatically
- ✅ **Application** - Starts successfully
- ✅ **API** - All endpoints working

## 📞 Support

Nếu vẫn gặp lỗi:
1. **Check MySQL version**: `mysql --version`
2. **Check user privileges**: `SHOW GRANTS FOR 'sa'@'localhost';`
3. **Check authentication plugin**: `SELECT user, plugin FROM mysql.user WHERE user='sa';`
4. **Check database**: `SHOW DATABASES;`
5. **Check connection**: `mysql -u sa -psapassword -e "SELECT 1;"`
