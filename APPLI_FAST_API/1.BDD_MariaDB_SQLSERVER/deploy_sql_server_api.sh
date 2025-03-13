#!/bin/bash

# Variables fixes
RESOURCE_GROUP="mboumedineRG"              # Nom du groupe de ressources existant
SERVER_NAME="malek-sql-server"             # Nom du serveur SQL
LOCATION="France Central"                  # Région Azure
START_IP="0.0.0.0"                        # IP de début pour la règle de pare-feu
END_IP="255.255.255.255"                  # IP de fin pour la règle de pare-feu

# Récupération des variables d'environnement
source .env

# Variables provenant du fichier .env
ADMIN_USER=$ADMIN_USER                     # Utilisateur pour le serveur SQL
ADMIN_PASSWORD=$ADMIN_PASSWORD              # Mot de passe pour le serveur SQL
DATABASE_NAME=$DATABASE_NAME               # Nom de la base de données

API_USER=$API_USER
API_PASSWORD=$API_PASSWORD

# # # creation du serveur, à commenter s'il existe deja
# echo "Création du serveur SQL..."
# az sql server create \
#     --name $SERVER_NAME \
#     --resource-group $RESOURCE_GROUP \
#     --location "$LOCATION" \
#     --admin-user $ADMIN_USER \
#     --admin-password $ADMIN_PASSWORD

# # Configurer une règle de pare-feu
# echo "Configuration du pare-feu..."
# az sql server firewall-rule create \
#     --resource-group $RESOURCE_GROUP \
#     --server $SERVER_NAME \
#     --name AllowAllIPs \
#     --start-ip-address $START_IP \
#     --end-ip-address $END_IP

# Créer la base de données
echo "Création de la base de données..."
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
    
# # creation de l'utilisateur de l'api
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U malek -P "Azerty123456@" -d master -Q "CREATE LOGIN [apiuser] WITH PASSWORD=N'Azerty123456@'"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U malek -P "Azerty123456@" -d master -Q "SELECT name FROM sys.sql_logins WHERE name = 'apiuser';"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U malek -P "Azerty123456@" -d db_fastapi_app -Q "CREATE USER [apiuser] FOR LOGIN [apiuser] WITH DEFAULT_SCHEMA=[dbo];"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U malek -P "Azerty123456@" -d db_fastapi_app -Q "SELECT name FROM sys.database_principals WHERE name = 'apiuser';" 
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U malek -P "Azerty123456@" -d db_fastapi_app -Q "EXEC sp_addrolemember 'db_owner', 'apiuser';"
sqlcmd -S tcp:malek-sql-server.database.windows.net,1433 -U malek -P "Azerty123456@" -d db_fastapi_app -Q "SELECT DP.name AS RoleName, MP.name AS MemberName FROM sys.database_role_members AS DRM INNER JOIN sys.database_principals AS DP ON DRM.role_principal_id = DP.principal_id INNER JOIN sys.database_principals AS MP ON DRM.member_principal_id = MP.principal_id WHERE MP.name = 'apiuser';"


# Afficher les informations de connexion
echo "Base de données SQL Server créée avec succès !"
echo "Serveur: $SERVER_NAME.database.windows.net"
echo "Base de données: $DATABASE_NAME"
echo "Utilisateur: $ADMIN_USER"