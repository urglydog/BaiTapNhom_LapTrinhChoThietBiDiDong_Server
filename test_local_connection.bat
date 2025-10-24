@echo off
echo =============================================
echo Test Local MySQL Connection
echo =============================================

echo 1. Testing MySQL service...
net start mysql

echo 2. Testing connection with 'sa' user...
mysql -u sa -psapassword -e "SELECT 1;"

echo 3. Testing database access...
mysql -u sa -psapassword -e "USE movie_ticket_db; SELECT 1;"

echo 4. Testing table creation...
mysql -u sa -psapassword -e "USE movie_ticket_db; CREATE TABLE IF NOT EXISTS test_connection (id INT PRIMARY KEY, name VARCHAR(50));"

echo 5. Testing data insertion...
mysql -u sa -psapassword -e "USE movie_ticket_db; INSERT INTO test_connection (id, name) VALUES (1, 'Connection Test');"

echo 6. Testing data selection...
mysql -u sa -psapassword -e "USE movie_ticket_db; SELECT * FROM test_connection;"

echo 7. Cleaning up test data...
mysql -u sa -psapassword -e "USE movie_ticket_db; DROP TABLE test_connection;"

echo =============================================
echo Local MySQL connection test completed!
echo =============================================
echo.
echo If all tests passed, you can now run your Spring Boot application!
echo =============================================
pause
