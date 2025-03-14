#!/bin/bash


source .env
SERVER_NAME=$SERVER_NAME

# creation de l'utilisateur de l'api
sqlcmd -S tcp:${SERVER_NAME}.database.windows.net,1433 -U ${ADMIN_USER} -P "${ADMIN_PASSWORD}" -d master -Q "IF NOT EXISTS (SELECT name FROM sys.sql_logins WHERE name = '${API_USER}') CREATE LOGIN [${API_USER}] WITH PASSWORD='${API_PASSWORD}';"
sqlcmd -S tcp:${SERVER_NAME}.database.windows.net,1433 -U ${ADMIN_USER} -P "${ADMIN_PASSWORD}" -d master -Q "SELECT name FROM sys.sql_logins WHERE name = '${API_USER}';"
sqlcmd -S tcp:${SERVER_NAME}.database.windows.net,1433 -U ${ADMIN_USER} -P "${ADMIN_PASSWORD}" -d ${DATABASE_NAME} -Q "IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = '${API_USER}') CREATE USER [${API_USER}] FOR LOGIN [${API_USER}] WITH DEFAULT_SCHEMA=[dbo];"
sqlcmd -S tcp:${SERVER_NAME}.database.windows.net,1433 -U ${ADMIN_USER} -P "${ADMIN_PASSWORD}" -d ${DATABASE_NAME} -Q "SELECT name FROM sys.database_principals WHERE name = '${API_USER}';"
sqlcmd -S tcp:${SERVER_NAME}.database.windows.net,1433 -U ${ADMIN_USER} -P "${ADMIN_PASSWORD}" -d ${DATABASE_NAME} -Q "EXEC sp_addrolemember 'db_owner', '${API_USER}';"
sqlcmd -S tcp:${SERVER_NAME}.database.windows.net,1433 -U ${ADMIN_USER} -P "${ADMIN_PASSWORD}" -d ${DATABASE_NAME} -Q "SELECT DP.name AS RoleName, MP.name AS MemberName FROM sys.database_role_members AS DRM INNER JOIN sys.database_principals AS DP ON DRM.role_principal_id = DP.principal_id INNER JOIN sys.database_principals AS MP ON DRM.member_principal_id = MP.principal_id WHERE MP.name = '${API_USER}';"

