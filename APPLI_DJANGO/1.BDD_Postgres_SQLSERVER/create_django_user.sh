#!/bin/bash


source .env

# creation de l'utilisateur de l'api
sqlcmd -S tcp:${SERVER_NAME}.database.windows.net,1433 -U ${ADMIN_USER} -P "${ADMIN_PASSWORD}" -d master -Q "IF NOT EXISTS (SELECT name FROM sys.sql_logins WHERE name = '${POSTGRES_USER}') CREATE LOGIN [${POSTGRES_USER}] WITH PASSWORD='${POSTGRES_PASSWORD}';"
sqlcmd -S tcp:${SERVER_NAME}.database.windows.net,1433 -U ${ADMIN_USER} -P "${ADMIN_PASSWORD}" -d master -Q "SELECT name FROM sys.sql_logins WHERE name = '${POSTGRES_USER}';"
sqlcmd -S tcp:${SERVER_NAME}.database.windows.net,1433 -U ${ADMIN_USER} -P "${ADMIN_PASSWORD}" -d ${POSTGRES_DB} -Q "IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = '${POSTGRES_USER}') CREATE USER [${POSTGRES_USER}] FOR LOGIN [${POSTGRES_USER}] WITH DEFAULT_SCHEMA=[dbo];"
sqlcmd -S tcp:${SERVER_NAME}.database.windows.net,1433 -U ${ADMIN_USER} -P "${ADMIN_PASSWORD}" -d ${POSTGRES_DB} -Q "SELECT name FROM sys.database_principals WHERE name = '${POSTGRES_USER}';"
sqlcmd -S tcp:${SERVER_NAME}.database.windows.net,1433 -U ${ADMIN_USER} -P "${ADMIN_PASSWORD}" -d ${POSTGRES_DB} -Q "EXEC sp_addrolemember 'db_owner', '${POSTGRES_USER}';"
sqlcmd -S tcp:${SERVER_NAME}.database.windows.net,1433 -U ${ADMIN_USER} -P "${ADMIN_PASSWORD}" -d ${POSTGRES_DB} -Q "SELECT DP.name AS RoleName, MP.name AS MemberName FROM sys.database_role_members AS DRM INNER JOIN sys.database_principals AS DP ON DRM.role_principal_id = DP.principal_id INNER JOIN sys.database_principals AS MP ON DRM.member_principal_id = MP.principal_id WHERE MP.name = '${API_USER}';"

