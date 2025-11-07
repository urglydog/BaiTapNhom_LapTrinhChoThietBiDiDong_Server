@echo off
echo =============================================
echo Insert UTF-8 Data to Railway Database
echo =============================================

echo 1. Setting UTF-8 encoding...
chcp 65001

echo 2. Connecting to Railway MySQL with UTF-8...
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm --default-character-set=utf8mb4 -e "SET NAMES utf8mb4; USE railway;"

echo 3. Inserting UTF-8 data...
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm --default-character-set=utf8mb4 < data_utf8.sql

echo 4. Verifying UTF-8 data insertion...
echo Users with Vietnamese names:
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm --default-character-set=utf8mb4 -e "USE railway; SELECT id, username, full_name FROM users;"

echo Cinemas with Vietnamese names:
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm --default-character-set=utf8mb4 -e "USE railway; SELECT id, name, address FROM cinemas;"

echo Movies with Vietnamese descriptions:
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm --default-character-set=utf8mb4 -e "USE railway; SELECT id, title, description FROM movies LIMIT 2;"

echo =============================================
echo UTF-8 data inserted successfully!
echo =============================================
echo.
echo Vietnamese text should now display correctly.
echo Test API endpoints to verify UTF-8 encoding.
echo =============================================
pause
