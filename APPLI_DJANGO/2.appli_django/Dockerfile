FROM python:3.11-slim

WORKDIR /appli_django

RUN apt-get update && apt-get install -y \
    curl \
    gcc \
    gnupg \
    python3-dev \
    libpq-dev \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Installer SQL Server ODBC
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg \
    && echo "deb [arch=amd64] https://packages.microsoft.com/debian/11/prod bullseye main" > /etc/apt/sources.list.d/mssql-release.list \
    && echo "msodbcsql18 msodbcsql/ACCEPT_EULA_MSODBCSQLEU boolean true" | debconf-set-selections \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y \
    msodbcsql17 \
    unixodbc \
    unixodbc-dev \
    msodbcsql18 \
    dos2unix\
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip

COPY requirements.txt /appli_django/

RUN pip3 install -r requirements.txt
RUN pip3 install gunicorn

# Créer la structure des dossiers statiques
RUN mkdir -p /appli_django/pret_bancaire/static/css \
    && mkdir -p /appli_django/pret_bancaire/static/images \
    && mkdir -p /appli_django/pret_bancaire/staticfiles

# Copier d'abord les fichiers statiques
COPY pret_bancaire/static /appli_django/pret_bancaire/static/

# Copier le reste de l'application
COPY .env /appli_django/
COPY . /appli_django

# S'assurer que les permissions sont correctes
RUN chmod -R 755 /appli_django/pret_bancaire/static \
    && chmod -R 755 /appli_django/pret_bancaire/staticfiles

EXPOSE 8000

# Vérifier les dossiers et leur contenu
RUN ls -la /appli_django/pret_bancaire \
    && ls -la /appli_django/pret_bancaire/static \
    && ls -la /appli_django/pret_bancaire/staticfiles

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN dos2unix /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]