# 🔧 Sửa lỗi MySQL Authentication Plugin

## 🚨 Vấn đề
Lỗi `!AuthenticationProvider.BadAuthenticationPlugin!` xảy ra khi MySQL sử dụng `caching_sha2_password` plugin nhưng MySQL Connector không hỗ trợ.

## ✅ Giải pháp

### **Bước 1: Chạy script sửa authentication**
```bash
# Kết nối MySQL với root
mysql -u root -p

# Chạy script sửa authentication
source fix_mysql_auth.sql
```

### **Bước 2: Kiểm tra kết nối**
```bash
# Test kết nối với user mới
mysql -u movieuser -p movie_ticket_db

# Chạy script test
source test_mysql_connection.sql
```

### **Bước 3: Chạy ứng dụng**
```bash
# Chạy Spring Boot app
mvn spring-boot:run
```

## 🔍 Nguyên nhân

### **MySQL 8.0+ Authentication:**
- **Mặc định**: `caching_sha2_password` (không tương thích với một số client)
- **Giải pháp**: Sử dụng `mysql_native_password`

### **Connection String Parameters:**
```properties
# Thêm các parameters này:
defaultAuthenticationPlugin=mysql_native_password
allowPublicKeyRetrieval=true
useSSL=false
```

## 🛠️ Troubleshooting

### **Lỗi 1: Access denied**
```sql
-- Kiểm tra user permissions
SHOW GRANTS FOR 'movieuser'@'localhost';

-- Cấp lại quyền
GRANT ALL PRIVILEGES ON *.* TO 'movieuser'@'localhost';
FLUSH PRIVILEGES;
```

### **Lỗi 2: Plugin not found**
```sql
-- Kiểm tra plugins có sẵn
SELECT plugin_name FROM information_schema.plugins 
WHERE plugin_type = 'AUTHENTICATION';

-- Cài đặt plugin nếu cần
INSTALL PLUGIN mysql_native_password SONAME 'mysql_native_password.so';
```

### **Lỗi 3: Connection timeout**
```properties
# Thêm vào application.properties
spring.datasource.hikari.connection-timeout=30000
spring.datasource.hikari.maximum-pool-size=5
```

## 📋 Checklist

- [ ] ✅ Chạy `fix_mysql_auth.sql`
- [ ] ✅ Test kết nối với `test_mysql_connection.sql`
- [ ] ✅ Cập nhật `application.properties`
- [ ] ✅ Chạy ứng dụng Spring Boot
- [ ] ✅ Test API endpoints

## 🎯 Kết quả mong đợi

Sau khi sửa:
- ✅ **MySQL connection** thành công
- ✅ **Authentication** hoạt động
- ✅ **Tiếng Việt** hiển thị đúng
- ✅ **API** trả về dữ liệu

## 📞 Support

Nếu vẫn gặp lỗi:
1. Kiểm tra MySQL version: `SELECT VERSION();`
2. Kiểm tra plugins: `SHOW PLUGINS;`
3. Kiểm tra user permissions: `SHOW GRANTS;`
4. Test connection string với MySQL Workbench
