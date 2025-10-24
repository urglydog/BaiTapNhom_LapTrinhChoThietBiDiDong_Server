@echo off
echo =============================================
echo Run Spring Boot Application with Local MySQL
echo =============================================

echo 1. Testing MySQL connection first...
mysql -u sa -psapassword -e "USE movie_ticket_db; SELECT 1;"

if %errorlevel% neq 0 (
    echo ERROR: MySQL connection failed!
    echo Please run fix_mysql_auth_local.bat first
    pause
    exit /b 1
)

echo 2. MySQL connection successful!
echo 3. Starting Spring Boot application...

mvn spring-boot:run

echo =============================================
echo Application finished!
echo =============================================
pause
