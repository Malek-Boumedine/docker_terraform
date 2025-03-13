#!/bin/bash

RESOURCE_GROUP="mboumedineRG"
SERVER_NAME="malek-postgres-server"

echo "Suppression du serveur PostgreSQL $SERVER_NAME..."
az postgres flexible-server delete \
  --name $SERVER_NAME \
  --resource-group $RESOURCE_GROUP \
  --yes

echo "Serveur PostgreSQL supprimé avec succès !"