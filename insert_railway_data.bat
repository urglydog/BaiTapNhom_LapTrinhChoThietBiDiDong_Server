@echo off
echo =============================================
echo Insert Sample Data to Railway Database
echo =============================================

echo 1. Connecting to Railway MySQL...
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm -e "USE railway; SELECT COUNT(*) as table_count FROM information_schema.tables WHERE table_schema = 'railway';"

echo 2. Inserting sample data...
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm < insert_railway_data.sql

echo 3. Verifying data insertion...
echo Users:
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm -e "USE railway; SELECT id, username, email, role FROM users;"

echo Cinemas:
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm -e "USE railway; SELECT id, name, city FROM cinemas;"

echo Movies:
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm -e "USE railway; SELECT id, title, genre, rating FROM movies;"

echo Showtimes:
mysql -h gondola.proxy.rlwy.net -P 15325 -u root -pmzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm -e "USE railway; SELECT id, movie_id, cinema_hall_id, show_date, start_time, price FROM showtimes;"

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
