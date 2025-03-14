#!/bin/bash

source ./terraform.tfvars

server_user=$AZURE_SQL_ADMIN_LOGIN
server_password=$AZURE_SQL_ADMIN_PASSWORD

django_user=$POSTGRES_USER
django_password=$POSTGRES_PASSWORD
django_database=$POSTGRES_DB

api_user=$DATABASE_USERNAME
api_password=$DATABASE_PASSWORD
api_database=$DATABASE_NAME

azure_registry_name=$AZURE_USERNAME
azure_resource_group=$resource_group_name
azure_container_name=$AZURE_TERRAFORM_NAME

# creation de l'utilisateur de l'api
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U $server_user -P "$server_password" -d master -Q "CREATE LOGIN [$api_user] WITH PASSWORD=N'$api_password'"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U $server_user -P "$server_password" -d master -Q "SELECT name FROM sys.sql_logins WHERE name = '$api_user';"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U $server_user -P "$server_password" -d $api_database -Q "CREATE USER [$api_user] FOR LOGIN [$api_user] WITH DEFAULT_SCHEMA=[dbo];"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U $server_user -P "$server_password" -d $api_database -Q "SELECT name FROM sys.database_principals WHERE name = '$api_user';" 
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U $server_user -P "$server_password" -d $api_database -Q "EXEC sp_addrolemember 'db_owner', '$api_user';"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U $server_user -P "$server_password" -d $api_database -Q "SELECT DP.name AS RoleName, MP.name AS MemberName FROM sys.database_role_members AS DRM INNER JOIN sys.database_principals AS DP ON DRM.role_principal_id = DP.principal_id INNER JOIN sys.database_principals AS MP ON DRM.member_principal_id = MP.principal_id WHERE MP.name = '$api_user';"

# creation de l'admin django
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U $server_user -P "$server_password" -d master -Q "CREATE LOGIN [$django_user] WITH PASSWORD='$django_password';"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U $server_user -P "$server_password" -d master -Q "SELECT name FROM sys.sql_logins WHERE name = '$django_user';"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U $server_user -P "$server_password" -d $django_database -Q "CREATE USER [$django_user] FOR LOGIN [$django_user] WITH DEFAULT_SCHEMA=[dbo];"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U $server_user -P "$server_password" -d $django_database -Q "SELECT name FROM sys.database_principals WHERE name = '$django_user';"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U $server_user -P "$server_password" -d $django_database -Q "EXEC sp_addrolemember 'db_owner', '$django_user';"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U $server_user -P "$server_password" -d $django_database -Q "SELECT DP.name AS RoleName, MP.name AS MemberName FROM sys.database_role_members AS DRM INNER JOIN sys.database_principals AS DP ON DRM.role_principal_id = DP.principal_id INNER JOIN sys.database_principals AS MP ON DRM.member_principal_id = MP.principal_id WHERE MP.name = '$django_user';"

az acr login --name $azure_registry_name
az container restart --name $azure_container_name --resource-group $azure_resource_group