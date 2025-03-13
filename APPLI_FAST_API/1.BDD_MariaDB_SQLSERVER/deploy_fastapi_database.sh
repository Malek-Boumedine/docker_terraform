#!/bin/bash


CPU="1"                                    # Nombre de CPUs
MEMORY="2"                                 # Mémoire (RAM)
PORT="3306"                                # Port exposé
IP_ADDRESS="Public"                       # Type d'IP (Public ou Private)
DNS_LABEL=""                               # Label DNS pour l'adresse publique
OS_TYPE="Linux"                            # Type d'OS (Linux ou Windows)

# Récupération dynamique des identifiants du ACR
ACR_USERNAME=$(az acr credential show --name $ACR_NAME --query "username" -o tsv)
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --query "passwords[0].value" -o tsv)

# Suppression du conteneur existant
az container delete --name $CONTAINER_NAME --resource-group $RESOURCE_GROUP -y

# Récupération des variables d'environnement
source .env

# Déploiement du conteneur
az container create \
  --name $CONTAINER_NAME \
  --resource-group $RESOURCE_GROUP \
  --image $ACR_URL/$ACR_IMAGE \
  --cpu $CPU \
  --memory $MEMORY \
  --registry-login-server $ACR_URL \
  --registry-username $ACR_USERNAME \
  --registry-password $ACR_PASSWORD \
  --ports $PORT \
  --ip-address $IP_ADDRESS \
  --os-type $OS_TYPE \
  --environment-variables \
    MYSQL_DATABASE=$MYSQL_DATABASE \
    MYSQL_USER=$MYSQL_USER \
    MYSQL_PASSWORD=$MYSQL_PASSWORD \
    MYSQL_ROOT_PASSWORD=$MARIADB_ROOT_PASSWORD

# Affichage des informations
echo "Le déploiement a réussi."






#!/bin/bash

# Variables
RESOURCE_GROUP="mboumedineRG"              # Nom du groupe de ressources existant
SERVER_NAME="malek-api-server"           # Nom du serveur PostgreSQL
LOCATION="France Central"                  # Région Azure
# SKU="Standard_D2s_v3"                    # SKU pour le serveur PostgreSQL
SKU="Burstable"                            # SKU pour le serveur PostgreSQL
COMPUTE_SIZE="Standard_B1ms"               # Taille de la machine virtuelle
STORAGE_SIZE=32                            # Taille du stockage en GiB
STORAGE_TYPE="Standard SSD"                # Type de stockage
PERFORMANCE_TIER="P1"                      # Niveau de performance du stockage
START_IP="0.0.0.0"                         # IP de début pour la règle de pare-feu
END_IP="255.255.255.255"                   # IP de fin pour la règle de pare-feu

# Récupération des variables d'environnement
source .env

# Variables provenant du fichier .env
MARIADB_ROOT_PASSWORD=$MARIADB_ROOT_PASSWORD
MYSQL_DATABASE=$MYSQL_DATABASE
MYSQL_USER=$MYSQL_USER
MYSQL_PASSWORD=$MYSQL_PASSWORD
DATABASE_URL=$DATABASE_URL

# Créer un serveur PostgreSQL
az postgres flexible-server create \
  --name $SERVER_NAME \
  --resource-group $RESOURCE_GROUP \
  --location "$LOCATION" \
  --admin-user $ADMIN_USER \
  --admin-password $ADMIN_PASSWORD \
  --sku-name $SKU \
  --compute-size "$COMPUTE_SIZE" \
  --storage-size $STORAGE_SIZE \
  --storage-type "$STORAGE_TYPE" \
  --performance-tier "$PERFORMANCE_TIER"

# Configurer une règle de pare-feu pour autoriser les connexions
az postgres flexible-server firewall-rule create \
  --resource-group $RESOURCE_GROUP \
  --name $SERVER_NAME \
  --rule-name AllowIps \
  --start-ip-address $START_IP \
  --end-ip-address $END_IP

# Créer la base de données
echo "Création de la base de données $DATABASE_NAME sur le serveur $SERVER_NAME..."
az postgres flexible-server db create \
  --resource-group $RESOURCE_GROUP \
  --server-name $SERVER_NAME \
  --database-name $DATABASE_NAME

# Afficher les informations de connexion
echo "Serveur PostgreSQL créé avec succès !"
echo "URL de connexion : postgresql://$ADMIN_USER:$ADMIN_PASSWORD@$SERVER_NAME.postgres.database.azure.com:5432/$DATABASE_NAME"



