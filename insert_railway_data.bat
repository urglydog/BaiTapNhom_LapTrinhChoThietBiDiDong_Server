@echo off
echo =============================================
echo Insert Sample Data to Railway Database
echo =============================================

echo 1. Setting UTF-8 encoding...
chcp 65001

echo 2. Connecting to Railway MySQL with UTF-8...
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm --default-character-set=utf8mb4 -e "USE railway; SELECT COUNT(*) as table_count FROM information_schema.tables WHERE table_schema = 'railway';"

echo 3. Inserting sample data with UTF-8...
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm --default-character-set=utf8mb4 < insert_railway_data.sql

echo 4. Verifying data insertion with UTF-8...
echo Users:
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm --default-character-set=utf8mb4 -e "USE railway; SELECT id, username, email, role FROM users;"

echo Cinemas:
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm --default-character-set=utf8mb4 -e "USE railway; SELECT id, name, city FROM cinemas;"

echo Movies:
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm --default-character-set=utf8mb4 -e "USE railway; SELECT id, title, genre, rating FROM movies;"

echo Showtimes:
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm --default-character-set=utf8mb4 -e "USE railway; SELECT id, movie_id, cinema_hall_id, show_date, start_time, price FROM showtimes;"

echo =============================================
echo Sample data inserted successfully!
echo =============================================
echo.
echo You can now test the API endpoints:
echo - GET https://baitapnhom-laptrinhchothietbididong-omtc.onrender.com/api/users
echo - GET https://baitapnhom-laptrinhchothietbididong-omtc.onrender.com/api/movies
echo - GET https://baitapnhom-laptrinhchothietbididong-omtc.onrender.com/api/cinemas
echo - GET https://baitapnhom-laptrinhchothietbididong-omtc.onrender.com/api/showtimes
echo =============================================
pause
