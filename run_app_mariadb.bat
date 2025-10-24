@echo off
echo =============================================
echo Run Spring Boot Application with MariaDB
echo =============================================

echo 1. Testing MariaDB connection first...
mysql -u sa -psapassword -e "USE movie_ticket_db; SELECT 1;"

if %errorlevel% neq 0 (
    echo ERROR: MariaDB connection failed!
    echo Please run setup_mariadb_database.bat first
    pause
    exit /b 1
)

echo 2. MariaDB connection successful!
echo 3. Starting Spring Boot application...

mvn spring-boot:run

echo =============================================
echo Application finished!
echo =============================================
pause
