-- =============================================
-- Test MySQL Connection Script
-- Kiểm tra kết nối MySQL và authentication
-- =============================================

-- 1. Kiểm tra MySQL version
SELECT VERSION();

-- 2. Kiểm tra authentication plugins
SELECT plugin_name, plugin_status 
FROM information_schema.plugins 
WHERE plugin_type = 'AUTHENTICATION';

-- 3. Kiểm tra user authentication
SELECT user, host, plugin, authentication_string 
FROM mysql.user 
WHERE user = 'root';

-- 4. Kiểm tra database
SHOW DATABASES;

-- 5. Kiểm tra character set
SHOW VARIABLES LIKE 'character_set%';

-- 6. Kiểm tra collation
SHOW VARIABLES LIKE 'collation%';

-- 7. Test tạo database
CREATE DATABASE IF NOT EXISTS movie_ticket_db_test;
USE movie_ticket_db_test;

-- 8. Test tạo bảng đơn giản
CREATE TABLE test_table (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Test insert dữ liệu tiếng Việt
INSERT INTO test_table (name) VALUES ('Test tiếng Việt: Nguyễn Văn A');

-- 10. Test select
SELECT * FROM test_table;

-- 11. Cleanup
DROP TABLE test_table;
DROP DATABASE movie_ticket_db_test;

SELECT 'MySQL connection test completed successfully!' as result;
