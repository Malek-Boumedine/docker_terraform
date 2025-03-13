#!/bin/bash

# Variables
RESOURCE_GROUP="mboumedineRG"
CONTAINER_NAME="malek-application-fastapi"

# Suppression du conteneur
echo "Suppression du conteneur $CONTAINER_NAME..."
az container delete --name $CONTAINER_NAME --resource-group $RESOURCE_GROUP -y

echo "Conteneur supprimé avec succès."