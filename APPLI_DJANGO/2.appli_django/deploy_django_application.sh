#!/bin/bash


# Variables
RESOURCE_GROUP="mboumedineRG"              # Nom du groupe de ressources
CONTAINER_NAME="malek-django-sba"          # Nom du conteneur
ACR_NAME="mboumedineregistry"              # Nom de ton Azure Container Registry
ACR_IMAGE="django-app:latest"              # Nom de l'image dans le ACR
ACR_URL="$ACR_NAME.azurecr.io"             # URL du registre
CPU="1"                                    # Nombre de CPUs
MEMORY="2"                                 # Mémoire (RAM)
PORT="8000"                                # Port exposé
IP_ADDRESS="Public"                        # Type d'IP (Public ou Private)
DNS_LABEL="mlk-django"                     # Label DNS pour l'adresse publique
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
    --ports 8000 \
    --ip-address $IP_ADDRESS \
    --os-type $OS_TYPE \
    --dns-name-label $DNS_LABEL \
    --environment-variables \
        DJANGO_SECRET_KEY=$DJANGO_SECRET_KEY \
        DEBUG=$DEBUG \
        BANK_NAME="$BANK_NAME" \
        BANK_STATE="$BANK_STATE" \
        EMAIL=$EMAIL \
        PASSWORD=$PASSWORD \
        ACCESS_TOKEN=$ACCESS_TOKEN \
        API_ADDRESS=$API_ADDRESS \
        POSTGRES_DB=$POSTGRES_DB \
        POSTGRES_USER=$POSTGRES_USER \
        POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
        POSTGRES_HOST=$POSTGRES_HOST \
        POSTGRES_PORT=$POSTGRES_PORT 

az sql server firewall-rule create \
  --resource-group mboumedineRG \
  --server malek-sql-server \
  --name DockerAccess \
  --start-ip-address 0.0.0.0 \
  --end-ip-address 0.0.0.0


# Affichage des informations
echo "Le déploiement a réussi."


