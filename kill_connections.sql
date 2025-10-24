-- =============================================
-- Kill All Connections to Database
-- =============================================

USE master;
GO

-- Xem tất cả connections đến database
SELECT 
    session_id,
    login_name,
    host_name,
    program_name,
    status,
    last_request_start_time
FROM sys.dm_exec_sessions 
WHERE database_id = DB_ID('movie_ticket_db');
GO

-- Kill tất cả connections đến database
DECLARE @sql NVARCHAR(MAX) = '';
SELECT @sql = @sql + 'KILL ' + CAST(session_id AS NVARCHAR(10)) + ';'
FROM sys.dm_exec_sessions 
WHERE database_id = DB_ID('movie_ticket_db') 
AND session_id != @@SPID;

IF @sql != ''
BEGIN
    EXEC sp_executesql @sql;
    PRINT 'Đã kill tất cả connections đến movie_ticket_db';
END
ELSE
BEGIN
    PRINT 'Không có connections nào đến movie_ticket_db';
END
GO

-- Bây giờ có thể drop database
DROP DATABASE movie_ticket_db;
GO

-- Tạo lại database
CREATE DATABASE movie_ticket_db
COLLATE SQL_Latin1_General_CP1_CI_AS;
GO

PRINT 'Database movie_ticket_db đã được tạo lại thành công!';
