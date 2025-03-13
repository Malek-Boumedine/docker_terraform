# azure

variable "AZURE_SERVER" { type = string }
variable "AZURE_USERNAME" { type = string }
variable "AZURE_PASSWORD" { type = string }

variable "azure_subscription_id" { type = string }
variable "azure_tenant_id" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string } 

variable "AZURE_SQL_SERVER_NAME" { type = string }
variable "AZURE_SQL_ADMIN_LOGIN" { type = string }
variable "AZURE_SQL_ADMIN_PASSWORD" { type = string }


# Django env vars

variable "DJANGO_SECRET_KEY" { type = string }
variable "DEBUG" { type = string}
variable "BANK_NAME" { type = string }
variable "BANK_STATE" { type = string }
variable "EMAIL" { type = string }
variable "PASSWORD" { type = string }
variable "ACCESS_TOKEN" { type = string }
variable "API_ADDRESS" { type = string }
variable "POSTGRES_DB" { type = string }
variable "POSTGRES_USER" { type = string }
variable "POSTGRES_PASSWORD" { type = string }
variable "POSTGRES_HOST" { type = string }
variable "POSTGRES_PORT" { type = number }

# FastAPI env vars

variable "SECRET_KEY" { type = string }
variable "ALGORITHM" { type = string }
variable "ACCESS_TOKEN_EXPIRE_MINUTES" { type = number }
variable "DATABASE_USERNAME" { type = string }
variable "DATABASE_PASSWORD" { type = string }
variable "DATABASE_NAME" { type = string }
variable "HOST_NAME" { type = string }
variable "PORT" { type = number }
variable "DATABASE_URL" { type = string }
