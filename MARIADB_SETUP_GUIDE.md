# 🗄️ MariaDB Setup Guide

## 📋 Tổng quan

Hướng dẫn setup MariaDB cho Movie Ticket Booking System.

## 🚀 Quick Start

### **Bước 1: Setup MariaDB Database**
```bash
# Chạy script setup database
setup_mariadb_database.bat
```

### **Bước 2: Run Application**
```bash
# Chạy ứng dụng với MariaDB
run_app_mariadb.bat
```

## 🔧 Cấu hình

### **1. Application Properties**
```properties
# LOCAL MARIADB CONFIGURATION
spring.datasource.url=jdbc:mariadb://localhost:3306/movie_ticket_db?useUnicode=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=false&allowMultiQueries=true
spring.datasource.username=sa
spring.datasource.password=sapassword
spring.datasource.driver-class-name=org.mariadb.jdbc.Driver
```

### **2. Maven Dependencies**
```xml
<dependency>
    <groupId>org.mariadb.jdbc</groupId>
    <artifactId>mariadb-java-client</artifactId>
    <version>3.3.3</version>
</dependency>
```

### **3. JPA Configuration**
```properties
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MariaDBDialect
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.connection.characterEncoding=UTF-8
spring.jpa.properties.hibernate.connection.useUnicode=true
```

## 🗄️ Database Schema

### **Tables Created:**
- `users` - User accounts
- `cinemas` - Cinema locations
- `cinema_halls` - Cinema halls
- `movies` - Movie information
- `showtimes` - Movie showtimes
- `seats` - Seat information
- `bookings` - Booking records
- `booking_items` - Booking details
- `reviews` - Movie reviews
- `favourites` - User favourites
- `promotions` - Promotion codes
- `user_promotions` - User promotion usage

### **Sample Data:**
- **4 Users** - Admin, Staff, 2 Customers
- **4 Cinemas** - CGV, Lotte, Galaxy, BHD
- **8 Cinema Halls** - Various configurations
- **5 Movies** - Popular movies with details
- **8 Showtimes** - Movie schedules
- **60 Seats** - Sample seat layout

## 🔍 Key Differences from MySQL

### **1. Data Types:**
- `NVARCHAR` → `VARCHAR`
- `NVARCHAR(MAX)` → `TEXT`
- `BIT` → `BOOLEAN`
- `IDENTITY(1,1)` → `AUTO_INCREMENT`
- `DATETIME2` → `DATETIME`

### **2. Syntax:**
- `CHECK` constraints supported
- `ENUM` types supported
- `JSON` data type supported
- `UNIQUE KEY` syntax

### **3. Collation:**
- `utf8mb4_unicode_ci` for UTF-8 support
- Better Unicode handling than MySQL

## 🛠️ Troubleshooting

### **Common Issues:**

#### **1. MariaDB Service Not Running**
```bash
# Start MariaDB service
net start mariadb

# Check service status
sc query mariadb
```

#### **2. Connection Failed**
```bash
# Test connection
mysql -u sa -psapassword -e "SELECT 1;"

# Check user privileges
mysql -u root -p -e "SHOW GRANTS FOR 'sa'@'localhost';"
```

#### **3. Database Not Found**
```bash
# Create database manually
mysql -u root -p -e "CREATE DATABASE movie_ticket_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

#### **4. Tables Not Created**
```bash
# Run SQL script manually
mysql -u sa -psapassword < movie_ticket_db_mariadb.sql
```

## 📋 Checklist

- [ ] ✅ **MariaDB Service** - Running locally
- [ ] ✅ **Database** - `movie_ticket_db` created
- [ ] ✅ **User 'sa'** - Created with privileges
- [ ] ✅ **Tables** - All tables created
- [ ] ✅ **Sample Data** - Inserted successfully
- [ ] ✅ **Connection** - Test successful
- [ ] ✅ **Application** - Configured correctly
- [ ] ✅ **JPA** - Ready to create tables

## 🎯 Kết quả mong đợi

Sau khi setup:
- ✅ **MariaDB Database** - `movie_ticket_db` with all tables
- ✅ **Sample Data** - Users, cinemas, movies, showtimes
- ✅ **JPA** - Creates tables automatically
- ✅ **Application** - Starts successfully
- ✅ **API** - All endpoints working
- ✅ **HeidiSQL** - Can connect and manage database

## 📞 Support

Nếu gặp lỗi:
1. **Check MariaDB service**: `net start mariadb`
2. **Check database**: `mysql -u sa -psapassword -e "SHOW DATABASES;"`
3. **Check tables**: `mysql -u sa -psapassword -e "USE movie_ticket_db; SHOW TABLES;"`
4. **Check connection**: `mysql -u sa -psapassword -e "SELECT 1;"`
5. **Check application logs**: Look for database connection errors
