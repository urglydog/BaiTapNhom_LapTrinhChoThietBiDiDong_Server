@echo off
echo =============================================
echo Test Railway MySQL Connection
echo =============================================

echo 1. Testing MySQL connection to Railway...
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm -e "SELECT 1;"

echo 2. Testing database creation...
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm -e "CREATE DATABASE IF NOT EXISTS movie_ticket_db;"

echo 3. Testing table creation...
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm -e "USE movie_ticket_db; CREATE TABLE IF NOT EXISTS test_table (id INT PRIMARY KEY, name VARCHAR(50));"

echo 4. Testing data insertion...
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm -e "USE movie_ticket_db; INSERT INTO test_table (id, name) VALUES (1, 'Test Railway');"

echo 5. Testing data selection...
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm -e "USE movie_ticket_db; SELECT * FROM test_table;"

echo 6. Cleaning up test data...
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm -e "USE movie_ticket_db; DROP TABLE test_table;"

echo =============================================
echo Railway MySQL test completed!
echo =============================================
echo.
echo Railway MySQL Configuration:
echo Host: gondola.proxy.rlwy.net
echo Port: 15325
echo Username: root
echo Password: mzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm
echo Database: railway
echo.
echo You can now switch to Railway configuration!
echo =============================================
pause