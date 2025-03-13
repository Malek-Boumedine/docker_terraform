#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER admin_bank_user;
	CREATE DATABASE loan_requests;
	GRANT ALL PRIVILEGES ON DATABASE loan_requests TO admin_bank_user;
EOSQL
