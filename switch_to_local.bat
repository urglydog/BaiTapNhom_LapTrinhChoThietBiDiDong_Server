@echo off
echo =============================================
echo Switch to Local MySQL
echo =============================================

echo 1. Commenting Railway configuration...
powershell -Command "(Get-Content 'src\main\resources\application.properties') -replace '^spring\.datasource\.url=jdbc:mysql://gondola\.proxy\.rlwy\.net', '#spring.datasource.url=jdbc:mysql://gondola.proxy.rlwy.net' | Set-Content 'src\main\resources\application.properties'"
powershell -Command "(Get-Content 'src\main\resources\application.properties') -replace '^spring\.datasource\.username=root', '#spring.datasource.username=root' | Set-Content 'src\main\resources\application.properties'"
powershell -Command "(Get-Content 'src\main\resources\application.properties') -replace '^spring\.datasource\.password=mzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm', '#spring.datasource.password=mzsXeuaJPCVCHiKVsjeQUqzGsPUIsChm' | Set-Content 'src\main\resources\application.properties'"
powershell -Command "(Get-Content 'src\main\resources\application.properties') -replace '^spring\.datasource\.driver-class-name=com\.mysql\.cj\.jdbc\.Driver', '#spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver' | Set-Content 'src\main\resources\application.properties'"

echo 2. Uncommenting Local configuration...
powershell -Command "(Get-Content 'src\main\resources\application.properties') -replace '^#spring\.datasource\.url=jdbc:mysql://localhost:3306', 'spring.datasource.url=jdbc:mysql://localhost:3306' | Set-Content 'src\main\resources\application.properties'"
powershell -Command "(Get-Content 'src\main\resources\application.properties') -replace '^#spring\.datasource\.username=movieuser', 'spring.datasource.username=movieuser' | Set-Content 'src\main\resources\application.properties'"
powershell -Command "(Get-Content 'src\main\resources\application.properties') -replace '^#spring\.datasource\.password=moviepassword', 'spring.datasource.password=moviepassword' | Set-Content 'src\main\resources\application.properties'"
powershell -Command "(Get-Content 'src\main\resources\application.properties') -replace '^#spring\.datasource\.driver-class-name=com\.mysql\.cj\.jdbc\.Driver', 'spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver' | Set-Content 'src\main\resources\application.properties'"

echo 3. Testing local MySQL connection...
mysql -u movieuser -pmoviepassword -e "USE movie_ticket_db; SELECT 1;"

echo 4. Starting application with local MySQL...
mvn spring-boot:run

echo =============================================
echo Switched to Local MySQL!
echo =============================================
pause
