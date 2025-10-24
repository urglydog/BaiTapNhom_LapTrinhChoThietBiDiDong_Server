@echo off
echo =============================================
echo Fix MariaDB Authentication for Local
echo =============================================

echo 1. Starting MariaDB service...
net start mariadb

echo 2. Creating database...
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS movie_ticket_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

echo 3. Creating user 'sa' with mysql_native_password...
mysql -u root -p -e "CREATE USER IF NOT EXISTS 'sa'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('sapassword');"
mysql -u root -p -e "CREATE USER IF NOT EXISTS 'sa'@'%' IDENTIFIED VIA mysql_native_password USING PASSWORD('sapassword');"

echo 4. Granting privileges...
mysql -u root -p -e "GRANT ALL PRIVILEGES ON movie_ticket_db.* TO 'sa'@'localhost';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON movie_ticket_db.* TO 'sa'@'%';"
mysql -u root -p -e "FLUSH PRIVILEGES;"

echo 5. Testing connection...
mysql -u sa -psapassword -e "USE movie_ticket_db; SELECT 1;"

echo 6. Creating test table...
mysql -u sa -psapassword -e "USE movie_ticket_db; CREATE TABLE IF NOT EXISTS test (id INT PRIMARY KEY, name VARCHAR(50));"

echo 7. Testing data insertion...
mysql -u sa -psapassword -e "USE movie_ticket_db; INSERT INTO test (id, name) VALUES (1, 'Test MariaDB Local');"

echo 8. Testing data selection...
mysql -u sa -psapassword -e "USE movie_ticket_db; SELECT * FROM test;"

echo 9. Cleaning up test data...
mysql -u sa -psapassword -e "USE movie_ticket_db; DROP TABLE test;"

echo =============================================
echo MariaDB authentication fixed!
echo =============================================
echo.
echo Database: movie_ticket_db
echo Username: sa
echo Password: sapassword
echo Host: localhost
echo Port: 3306
echo.
echo You can now run your Spring Boot application!
echo =============================================
pause
