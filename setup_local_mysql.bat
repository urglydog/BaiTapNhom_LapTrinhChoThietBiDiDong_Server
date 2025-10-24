@echo off
echo =============================================
echo Setup Local MySQL Database
echo =============================================

echo 1. Starting MySQL service...
net start mysql

echo 2. Creating database...
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS movie_ticket_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

echo 3. Creating user...
mysql -u root -p -e "CREATE USER IF NOT EXISTS 'movieuser'@'localhost' IDENTIFIED WITH mysql_native_password BY 'moviepassword';"
mysql -u root -p -e "CREATE USER IF NOT EXISTS 'movieuser'@'%' IDENTIFIED WITH mysql_native_password BY 'moviepassword';"

echo 4. Granting privileges...
mysql -u root -p -e "GRANT ALL PRIVILEGES ON movie_ticket_db.* TO 'movieuser'@'localhost';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON movie_ticket_db.* TO 'movieuser'@'%';"
mysql -u root -p -e "FLUSH PRIVILEGES;"

echo 5. Testing connection...
mysql -u movieuser -pmoviepassword -e "USE movie_ticket_db; SELECT 1;"

echo 6. Creating test table...
mysql -u movieuser -pmoviepassword -e "USE movie_ticket_db; CREATE TABLE IF NOT EXISTS test (id INT PRIMARY KEY, name VARCHAR(50));"

echo 7. Testing data insertion...
mysql -u movieuser -pmoviepassword -e "USE movie_ticket_db; INSERT INTO test (id, name) VALUES (1, 'Test Local');"

echo 8. Testing data selection...
mysql -u movieuser -pmoviepassword -e "USE movie_ticket_db; SELECT * FROM test;"

echo 9. Cleaning up test data...
mysql -u movieuser -pmoviepassword -e "USE movie_ticket_db; DROP TABLE test;"

echo =============================================
echo Local MySQL setup completed!
echo =============================================
echo.
echo Database: movie_ticket_db
echo Username: movieuser
echo Password: moviepassword
echo Host: localhost
echo Port: 3306
echo.
echo You can now run your Spring Boot application!
echo =============================================
pause
