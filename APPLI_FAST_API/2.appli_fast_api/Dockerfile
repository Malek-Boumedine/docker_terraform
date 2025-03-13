FROM python:3.11-slim

WORKDIR /appli_fast_api

# Installation des dépendances de base
RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    g++ \
    gnupg \
    python3-dev \
    libpq-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Configuration et installation de SQL Server ODBC
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y \
        msodbcsql18 \
        unixodbc-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip

COPY requirements.txt /appli_fast_api/

# Installation des dépendances Python
RUN pip3 install -r requirements.txt
RUN pip3 install gunicorn pyodbc

COPY . /appli_fast_api

EXPOSE 8080

# Configuration de l'entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN apt-get update && apt-get install -y dos2unix && rm -rf /var/lib/apt/lists/*
RUN dos2unix /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]