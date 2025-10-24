-- =============================================
-- Force Drop Database Script
-- Sử dụng khi database đang "in use"
-- =============================================

-- 1. Đóng tất cả connections đến database
USE master;

-- 2. Set database thành SINGLE_USER mode để đóng connections
ALTER DATABASE movie_ticket_db SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

-- 3. Drop database
DROP DATABASE movie_ticket_db;

-- 4. Tạo lại database
CREATE DATABASE movie_ticket_db
COLLATE SQL_Latin1_General_CP1_CI_AS;

PRINT 'Database movie_ticket_db đã được tạo lại thành công!';
