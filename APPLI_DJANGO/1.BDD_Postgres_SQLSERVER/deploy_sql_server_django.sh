#!/bin/bash

# charger les variables
source .env

# Variables fixes
RESOURCE_GROUP="mboumedineRG"
SERVER_NAME="malek-sql-server"             # meme serveur que pour l'api

# Variables pour Django DB
DATABASE_NAME=$POSTGRES_DB

# Créer la base de données Django
az sql db create \
    --resource-group $RESOURCE_GROUP \
    --server $SERVER_NAME \
    --name $DATABASE_NAME \
    --edition GeneralPurpose \
    --family Gen5 \
    --min-capacity 0.5 \
    --capacity 1 \
    --compute-model Serverless \
    --auto-pause-delay 60 \
    --max-size 32GB \
    --zone-redundant false \
    --backup-storage-redundancy Geo \
    --collation SQL_Latin1_General_CP1_CI_AS

# creation de l'admin
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U malek -P "Azerty123456@" -d master -Q "CREATE LOGIN [admin_bank_user] WITH PASSWORD='Azerty123456@';"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U malek -P "Azerty123456@" -d master -Q "SELECT name FROM sys.sql_logins WHERE name = 'admin_bank_user';"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U malek -P "Azerty123456@" -d db_django_app -Q "CREATE USER [admin_bank_user] FOR LOGIN [admin_bank_user] WITH DEFAULT_SCHEMA=[dbo];"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U malek -P "Azerty123456@" -d db_django_app -Q "SELECT name FROM sys.database_principals WHERE name = 'admin_bank_user';"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U malek -P "Azerty123456@" -d db_django_app -Q "EXEC sp_addrolemember 'db_owner', 'admin_bank_user';"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U malek -P "Azerty123456@" -d db_django_app -Q "SELECT DP.name AS RoleName, MP.name AS MemberName FROM sys.database_role_members AS DRM INNER JOIN sys.database_principals AS DP ON DRM.role_principal_id = DP.principal_id INNER JOIN sys.database_principals AS MP ON DRM.member_principal_id = MP.principal_id WHERE MP.name = 'admin_bank_user';"


echo "Base de données Django créée avec succès !"
