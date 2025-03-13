#!/bin/bash

DATABASE="sqlserver"
#DATABASE="mysql"

if [ "$DATABASE" = "mysql" ]; then
    python3 populate_db.py
else
    python3 populate_db_sqlserver.py
fi

uvicorn main:app --reload --host 0.0.0.0 --port 8080