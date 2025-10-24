@echo off
echo =============================================
echo Setup MariaDB Database
echo =============================================

echo 1. Starting MariaDB service...
net start mariadb

echo 2. Creating database and tables...
mysql -u root -p < movie_ticket_db_mariadb.sql

echo 3. Testing database connection...
mysql -u sa -psapassword -e "USE movie_ticket_db; SELECT COUNT(*) as user_count FROM users;"

echo 4. Testing data insertion...
mysql -u sa -psapassword -e "USE movie_ticket_db; INSERT INTO test_table (id, name) VALUES (1, 'MariaDB Test');"

echo 5. Testing data selection...
mysql -u sa -psapassword -e "USE movie_ticket_db; SELECT * FROM test_table;"

echo 6. Cleaning up test data...
mysql -u sa -psapassword -e "USE movie_ticket_db; DROP TABLE IF EXISTS test_table;"

echo =============================================
echo MariaDB database setup completed!
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
