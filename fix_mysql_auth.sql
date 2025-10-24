-- =============================================
-- Fix MySQL Authentication Plugin
-- Sửa lỗi authentication plugin
-- =============================================

-- 1. Kiểm tra MySQL version
SELECT VERSION();

-- 2. Kiểm tra authentication plugins hiện tại
SELECT plugin_name, plugin_status 
FROM information_schema.plugins 
WHERE plugin_type = 'AUTHENTICATION';

-- 3. Thay đổi authentication plugin cho root user
-- Sử dụng mysql_native_password thay vì caching_sha2_password
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';

-- 4. Tạo user mới với mysql_native_password
CREATE USER 'movieuser'@'localhost' IDENTIFIED WITH mysql_native_password BY 'moviepassword';

-- 5. Cấp quyền cho user mới
GRANT ALL PRIVILEGES ON movie_ticket_db.* TO 'movieuser'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'movieuser'@'localhost';

-- 6. Flush privileges
FLUSH PRIVILEGES;

-- 7. Kiểm tra user mới
SELECT user, host, plugin, authentication_string 
FROM mysql.user 
WHERE user IN ('root', 'movieuser');

-- 8. Test kết nối với user mới
-- Sử dụng: mysql -u movieuser -p movie_ticket_db

SELECT 'MySQL authentication fixed successfully!' as result;
