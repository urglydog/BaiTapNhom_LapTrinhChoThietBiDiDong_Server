-- =============================================
-- Check Database Connections
-- =============================================

USE master;
GO

-- Xem tất cả connections đến movie_ticket_db
SELECT 
    s.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    s.status,
    s.last_request_start_time,
    s.last_request_end_time,
    c.client_net_address,
    c.client_tcp_port
FROM sys.dm_exec_sessions s
LEFT JOIN sys.dm_exec_connections c ON s.session_id = c.session_id
WHERE s.database_id = DB_ID('movie_ticket_db')
ORDER BY s.last_request_start_time DESC;
GO

-- Xem database status
SELECT 
    name,
    state_desc,
    collation_name,
    create_date
FROM sys.databases 
WHERE name = 'movie_ticket_db';
GO
