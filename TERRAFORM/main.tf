terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "=4.1.0"
        }
                
    }
}

#######################################################################
# chargement des variables d'environnement (variables locales)

locals {
    env_var_fastapi = {
        SECRET_KEY=var.SECRET_KEY
        ALGORITHM=var.ALGORITHM
        ACCESS_TOKEN_EXPIRE_MINUTES=var.ACCESS_TOKEN_EXPIRE_MINUTES
        DATABASE_USERNAME=var.DATABASE_USERNAME
        DATABASE_PASSWORD=var.DATABASE_PASSWORD
        DATABASE_NAME=var.DATABASE_NAME
        HOST_NAME=var.HOST_NAME
        PORT=var.PORT
        DATABASE_URL=var.DATABASE_URL
    }

    env_var_django = {
        DJANGO_SECRET_KEY=var.DJANGO_SECRET_KEY
        DEBUG=var.DEBUG

        BANK_NAME=var.BANK_NAME
        BANK_STATE=var.BANK_STATE
        EMAIL=var.EMAIL
        PASSWORD=var.PASSWORD

        ACCESS_TOKEN=var.ACCESS_TOKEN

        API_ADDRESS=var.API_ADDRESS
        POSTGRES_DB=var.POSTGRES_DB
        POSTGRES_USER=var.POSTGRES_USER
        POSTGRES_PASSWORD=var.POSTGRES_PASSWORD
        POSTGRES_HOST=var.POSTGRES_HOST
        POSTGRES_PORT=var.POSTGRES_PORT
    }
}


#######################################################################
# providers azure

provider "azurerm" {
    features {}

    subscription_id = var.azure_subscription_id
    tenant_id       = var.azure_tenant_id
}

#######################################################################
# création du serveur mssql

resource "azurerm_mssql_server" "sql-server" {
    name = var.AZURE_SQL_SERVER_NAME
    resource_group_name = var.resource_group_name
    location = var.location
    version = "12.0"
    administrator_login = var.AZURE_SQL_ADMIN_LOGIN
    administrator_login_password = var.AZURE_SQL_ADMIN_PASSWORD
}

#######################################################################
# regle de pare feu

resource "azurerm_mssql_firewall_rule" "all_ips" {
  name             = "allow_all_ips"
  server_id        = azurerm_mssql_server.sql-server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

#######################################################################
# création des bases de données mssql

resource "azurerm_mssql_database" "fastapi-db" {
    name = "db_fastapi_app"
    server_id = azurerm_mssql_server.sql-server.id   
    sku_name = "GP_S_Gen5_1"
    min_capacity = 0.5
    auto_pause_delay_in_minutes = 60
    max_size_gb = 32
    zone_redundant = false
    storage_account_type = "Geo"
    collation = "SQL_Latin1_General_CP1_CI_AS"
}

resource "azurerm_mssql_database" "django-db" {
    name = "db_django_app"
    server_id = azurerm_mssql_server.sql-server.id
    sku_name = "GP_S_Gen5_1"
    min_capacity = 0.5
    auto_pause_delay_in_minutes = 60
    max_size_gb = 32
    zone_redundant = false
    storage_account_type = "Geo"
    collation = "SQL_Latin1_General_CP1_CI_AS"
}

#######################################################################
# création des containers des applications

resource "azurerm_container_group" "FastAPI_django" {
    resource_group_name = var.resource_group_name
    name = "malek-terraform-deploy"
    location = "France Central"
    ip_address_type = "Public"
    os_type = "Linux"
    dns_name_label = "malekfastapidjango"

    image_registry_credential {
        server   = var.AZURE_SERVER
        username = var.AZURE_USERNAME
        password = var.AZURE_PASSWORD
    }

    container {
        name = "fast-api-malek-terraform"
        image = "mboumedineregistry.azurecr.io/fastapi-app:latest"
        cpu = 1
        memory = 2
        ports {
            port = 8000
            protocol = "TCP"
        }
        environment_variables = local.env_var_fastapi
    }

    container {
        name = "django-malek-terraform"
        image = "mboumedineregistry.azurecr.io/django-app:latest"
        cpu = 1
        memory = 2
        ports {
            port = 8080
            protocol = "TCP"
        }
        environment_variables = local.env_var_django
    }
}

