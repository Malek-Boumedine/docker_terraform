# Projet d'Applications Web Django et FastAPI sur Docker et Azure - deploiement via Terraform

Ce projet comprend deux applications web distinctes déployées sur Azure, chacune avec sa propre base de données MSSQL. L'ensemble du déploiement est automatisé à l'aide de Terraform.


# Dépendances principales

![Python](https://img.shields.io/badge/Python-3.11+-blue.svg)
![FastAPI](https://img.shields.io/badge/FastAPI-0.115.8+-blue.svg)
![Django](https://img.shields.io/badge/Django-4.2+-blue.svg)  <!-- Ajuste la version si nécessaire -->
![SQLModel](https://img.shields.io/badge/SQLModel-0.0.22+-blue.svg)
![Pydantic](https://img.shields.io/badge/Pydantic-2.10.6+-blue.svg)
![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-2.0.38+-blue.svg)
![CatBoost](https://img.shields.io/badge/CatBoost-1.2.7+-blue.svg)
![Pandas](https://img.shields.io/badge/Pandas-2.2.3+-blue.svg)
![NumPy](https://img.shields.io/badge/NumPy-1.26.4+-blue.svg)
![Alembic](https://img.shields.io/badge/Alembic-1.14.1+-blue.svg)
![JWT](https://img.shields.io/badge/JWT-3.4.0+-blue.svg)
![Passlib](https://img.shields.io/badge/Passlib-1.7.4+-blue.svg)
![Psycopg2](https://img.shields.io/badge/Psycopg2-2.9.9+-blue.svg)
![Gunicorn](https://img.shields.io/badge/Gunicorn-21.2.0+-blue.svg)
![Uvicorn](https://img.shields.io/badge/Uvicorn-0.34.0+-blue.svg)
![Whitenoise](https://img.shields.io/badge/Whitenoise-6.6.0+-blue.svg)
![Django MSSQL Backend](https://img.shields.io/badge/Django_MSSQL_Backend-2.8.1+-blue.svg)
![Python-Multipart](https://img.shields.io/badge/Python_Multipart-0.0.20+-blue.svg)
![PyODBC](https://img.shields.io/badge/PyODBC-4.0.39+-blue.svg)

![License](https://img.shields.io/badge/License-MIT-green.svg)
![Status](https://img.shields.io/badge/Status-Development-red.svg)

# Accès aux Applications Déployées

Vous pouvez accéder aux applications déployées via les liens suivants :

* FastAPI : http://malekfastapidjango.francecentral.azurecontainer.io:8080
* Django : http://malekfastapidjango.francecentral.azurecontainer.io:8000

Informations d'Identification Administrateur

Pour tester les applications, utilisez les informations d'identification suivantes :

* Nom d'utilisateur : admin
* Mot de passe : admin

## Structure du Projet

Le projet est organisé en trois parties principales :

- **APPLI_DJANGO** : Application Django avec sa base de données MSSQL
- **APPLI_FAST_API** : Application FastAPI avec sa base de données MSSQL
- **TERRAFORM** : Scripts et configurations pour le déploiement sur Azure

## APPLI_DJANGO

L'application Django est une plateforme de gestion de prêts bancaires.

### Base de Données

La configuration de la base de données MSSQL pour Django est gérée par les scripts suivants :

- `deploy_sql_server_django.sh` : Déploie le serveur SQL
- `delete_django_database.sh` : Supprime la base de données

### Application

L'application Django permet aux utilisateurs de :

- Créer un compte et s'authentifier
- Soumettre des demandes de prêt
- Consulter les résultats des demandes
- Accéder à des actualités

#### Fonctionnalités principales :

- Gestion des utilisateurs et authentification
- Traitement des demandes de prêt
- Interface d'administration
- Section actualités

## APPLI_FAST_API

L'application FastAPI fournit une API pour le traitement des demandes de prêt avec un modèle de machine learning.

### Base de Données

La configuration de la base de données MSSQL pour FastAPI est gérée par les scripts suivants :

- `deploy_sql_server_api.sh` : Déploie le serveur SQL
- `delete_fastapi_database.sh` : Supprime la base de données

### Application

L'API FastAPI est conçue pour la gestion et la prédiction de prêts bancaires. Elle permet aux institutions bancaires de soumettre des demandes de prêts et d'obtenir une prédiction sur l'accord ou le refus du prêt en utilisant un modèle de machine learning CatBoost.

#### Fonctionnalités principales :

- Authentification JWT
- Gestion des utilisateurs (banques)
- Prédiction de l'accord de prêts via modèle ML (CatBoost)
- Historique des demandes de prêts
- Système de rôles (admin/user)

#### Points d'API principaux :

- **Authentication** :
    - `POST /auth/activation/{email}` : Activation du compte
    - `POST /auth/login` : Obtention du token JWT
- **Administration** :
    - `GET /admin/users` : Liste des utilisateurs
    - `POST /admin/users` : Création d'utilisateur
- **Prêts** :
    - `POST /loans/request` : Demande de prêt
    - `GET /loans/history` : Historique des demandes

#### Sécurité :

- Authentification via JWT
- Mots de passe hashés avec bcrypt
- Système de rôles (admin/user)
- Durée de validité configurable des tokens

## TERRAFORM

Ce répertoire contient les fichiers de configuration Terraform pour déployer l'infrastructure sur Azure.

### Infrastructure déployée

La configuration Terraform déploie les ressources suivantes sur Azure :

- **Serveur SQL** : Un serveur MSSQL hébergeant les deux bases de données
    - Règle de pare-feu permettant l'accès depuis n'importe quelle adresse IP
- **Bases de données** :
    - `db_fastapi_app` : Base de données pour l'application FastAPI
    - `db_django_app` : Base de données pour l'application Django
    - Configuration : Tier GP_S_Gen5_1 avec mise en pause automatique après 60 minutes d'inactivité
- **Groupe de conteneurs** :
    - Deux conteneurs déployés dans un même groupe :
        - Conteneur FastAPI exposé sur le port 8000
        - Conteneur Django exposé sur le port 8080
    - Images stockées dans Azure Container Registry
    - Configuration : 1 CPU et 2 GB de mémoire par conteneur
    - DNS configuré pour accéder aux applications

### Fichiers principaux :

- `main.tf` : Configuration principale de l'infrastructure
- `variables.tf` : Définition des variables utilisées dans la configuration
- `terraform.tfvars` : Valeurs des variables pour le déploiement (non inclus dans le repo)

### Variables d'environnement :

Les applications utilisent des variables d'environnement pour leur configuration, définies dans les fichiers Terraform.

## Déploiement

### Prérequis

- Azure CLI installé et configuré
- Terraform installé
- Docker installé (pour les tests locaux)
- Accès à un Azure Container Registry

### Étapes de déploiement via Terraform

1. Cloner le repo
    ```bash
    git clone git@github.com:Malek-Boumedine/docker_terraform.git
    ```

2. Extraire le fichier .pkl du model de prédiction : 
    ```bash
    tar -xvf APPLI_FAST_API/2.appli_fast_api/best_cat_boost.tar.xz
    ```

3. **Configuration des variables Terraform** :\
    Créez un fichier `terraform.tfvars` dans le répertoire `TERRAFORM` avec les valeurs appropriées pour toutes les variables définies dans `variables.tf`.

4. **Initialisation de Terraform** :
    ```bash
    cd TERRAFORM
    terraform init
    ```

5. **Planification du déploiement** :
    ```bash
    terraform plan
    ```

6. **Déploiement de l'infrastructure** :
    ```bash
    terraform apply
    ```

7. **lancer le script de création des utilisateurs des applications sur la base de données**
    ```bash
    bash create_users.sh
    ```

### Étapes de déploiement manuel via les scripts

1. **Déploiement des bases de données** :
    - Pour Django :
    ```bash
    cd ../APPLI_DJANGO/1.BDD_Postgres_SQLSERVER
    ./deploy_sql_server_django.sh
    bash create_django_user.sh
    ```
    - Pour FastAPI :
    ```bash
    cd ../../APPLI_FAST_API/1.BDD_MariaDB_SQLSERVER
    ./deploy_sql_server_api.sh
    bash create_api_user.sh
    ```

2.  **Déploiement des applications** :
    - Pour Django :
    ```bash
    cd ../../APPLI_DJANGO/2.appli_django
    ./deploy_django_application.sh
    ```
    - Pour FastAPI :
    ```bash
    cd ../../APPLI_FAST_API/2.appli_fast_api
    ./deploy_fastapi_application.sh
    ```

### Développement local

Pour exécuter les applications en local :

#### Application Django :

```bash
cd APPLI_DJANGO/2.appli_django
docker build -t django-app .
docker run -p 8080:8080 django-app
```
## Application FastAPI

Pour exécuter l'application FastAPI en local, utilisez les commandes suivantes :

```bash
cd APPLI_FAST_API/2.appli_fast_api
docker build -t fastapi-app .
docker run -p 8000:8000 fastapi-app
``` 

## Variables d'environnement

Pour que les applications FastAPI et Django fonctionnent correctement, il est nécessaire de définir certaines variables d'environnement. Ces variables peuvent être stockées dans un fichier .env et un fichier terraform.tfvars que vous créerez dans des répertoires différents. Voici les variables à définir :

## 1. Fichiers .env

#### Pour la base de données Django :
```bash 
repertoire APPLI_DJANGO/1.BDD_Postgres_SQLSERVER/.env
``` 
- POSTGRES_DB : Nom de la base de données pour l'application Django.
- POSTGRES_USER : Nom d'utilisateur pour accéder à la base de données.
- POSTGRES_PASSWORD : Mot de passe associé à l'utilisateur de la base de données.
- POSTGRES_PORT : 1433.
- DATABASE_URL : URL de connexion à la base de données, formatée pour PostgreSQL.

#### Pour l'application Django :
```bash 
repertoire APPLI_DJANGO/2.appli_django/.env
``` 
- DJANGO_SECRET_KEY : Clé secrète utilisée par Django pour la sécurité.
- DEBUG : Indique si l'application est en mode débogage (True/False).
- BANK_NAME : Nom de la banque.
- BANK_STATE : État de la banque.
- EMAIL : Adresse e-mail de l'administrateur.
- PASSWORD : Mot de passe de l'administrateur.
- ACCESS_TOKEN : Jeton d'accès pour l'authentification. (laisser vide car sera définie automatiquement par l'application)
- API_ADDRESS : URL de l'API FastAPI.
- POSTGRES_DB : Nom de la base de données pour l'application Django.
- POSTGRES_USER : Nom d'utilisateur pour accéder à la base de données.
- POSTGRES_PASSWORD : Mot de passe associé à l'utilisateur de la base de données.
- POSTGRES_PORT : 1433.
- POSTGRES_HOST : Hôte de la base de données PostgreSQL.

#### Pour la base de données FastAPI :
```bash 
repertoire APPLI_FAST_API/1.BDD_MariaDB_SQLSERVER/.env
``` 
- ADMIN_USER : Nom d'utilisateur administrateur pour la base de données FastAPI
- ADMIN_PASSWORD : Mot de passe associé à l'utilisateur administrateur
- DATABASE_NAME : Nom de la base de données utilisée par l'application FastAPI
- API_USER : Nom d'utilisateur pour l'accès API
- API_PASSWORD : Mot de passe associé à l'utilisateur API

#### Pour l'application FastAPI :
```bash 
repertoire APPLI_FAST_API/2.appli_fast_api/.env
``` 
- SECRET_KEY : Clé secrète utilisée pour signer les jetons d'accès.
- ALGORITHM : Algorithme utilisé pour le chiffrement des jetons.
- ACCESS_TOKEN_EXPIRE_MINUTES : Durée d'expiration des jetons d'accès en minutes.
- DATABASE_USERNAME : Nom d'utilisateur pour accéder à la base de données FastAPI.
- DATABASE_PASSWORD : Mot de passe associé à l'utilisateur de la base de données FastAPI.
- DATABASE_NAME : Nom de la base de données pour l'application FastAPI.
- HOST_NAME : Hôte de la base de données.
- PORT : 1433.
- DATABASE_URL : URL de connexion à la base de données, formatée pour MSSQL.

## 2. Fichier terraform.tfvars
```
Renommez le fichier terraform.tfvars.txt en terraform.tfvars, puis complétez-le en renseignant les valeurs pour chacune des variables.
```
#### Pour Django :

- DJANGO_SECRET_KEY : Clé secrète utilisée par Django pour la sécurité.
- DEBUG : Indique si l'application est en mode débogage (True/False).
- BANK_NAME : Nom de la banque.
- BANK_STATE : État de la banque.
- EMAIL : Adresse e-mail de l'administrateur.
- PASSWORD : Mot de passe de l'administrateur.
- ACCESS_TOKEN : Jeton d'accès pour l'authentification.
- API_ADDRESS : URL de l'API FastAPI.
- POSTGRES_DB : Nom de la base de données pour l'application Django.
- POSTGRES_USER : Nom d'utilisateur pour accéder à la base de données.
- POSTGRES_PASSWORD : Mot de passe associé à l'utilisateur de la base de données.
- POSTGRES_HOST : adresse du serveur de base de données sql server.
- POSTGRES_PORT=1433

#### Pour FastAPI :

- SECRET_KEY : Clé secrète utilisée pour signer les jetons d'accès.
- ALGORITHM : Algorithme utilisé pour le chiffrement des jetons.
- ACCESS_TOKEN_EXPIRE_MINUTES : Durée d'expiration des jetons d'accès en minutes.
- DATABASE_USERNAME : Nom d'utilisateur pour accéder à la base de données FastAPI.
- DATABASE_PASSWORD : Mot de passe associé à l'utilisateur de la base de données FastAPI.
- DATABASE_NAME : Nom de la base de données pour l'application FastAPI.
- HOST_NAME : Hôte de la base de données.
- PORT : 1433
- DATABASE_URL : URL de connexion à la base de données, formatée pour MSSQL.

#### Pour Azure :

- azure_subscription_id : ID de l'abonnement Azure.
- azure_tenant_id : ID du locataire Azure.
  - pour obtenir les credentials : az acr credential show --name <registry_name>
- resource_group_name : Nom du groupe de ressources Azure.
- AZURE_SERVER : Nom du serveur Azure Container Registry.
- AZURE_USERNAME : Nom d'utilisateur pour se connecter à l'ACR.
- AZURE_PASSWORD : Mot de passe pour se connecter à l'ACR.
- location : Localisation des ressources Azure.
- AZURE_SQL_SERVER_NAME : Nom du serveur SQL Azure.
- AZURE_SQL_ADMIN_LOGIN : Nom d'utilisateur administrateur pour le serveur SQL.
- AZURE_SQL_ADMIN_PASSWORD : Mot de passe administrateur pour le serveur SQL.
- AZURE_TERRAFORM_NAME : Nom du groupe de conteneurs Azure à déployer.
- DNS_NAME : Étiquette DNS pour le groupe de conteneurs.
- FAST_API_ACR_IMAGE : URL complète de l'image FastAPI dans l'Azure Container Registry.
- DJANGO_ACR_IMAGE : URL complète de l'image Django dans l'Azure Container Registry.

# Remarques

* Sécurité : Ne partagez jamais vos fichiers .env ou terraform.tfvars dans des dépôts publics. Ajoutez-les à votre fichier .gitignore pour éviter qu'ils ne soient suivis par Git.
* Valeurs sensibles : Utilisez des gestionnaires de secrets ou des services de stockage sécurisés pour gérer les valeurs sensibles en production.


### Architecture technique

- Frontend : Templates Django avec CSS personnalisé
- Backend Django : Framework Django avec ORM intégré
- Backend FastAPI : Framework FastAPI avec SQLAlchemy et Pydantic
- Bases de données : MSSQL Server sur Azure (tier GP_S_Gen5_1)
- Machine Learning : Modèle CatBoost pour l'analyse des demandes de prêt
- Infrastructure : Services Azure déployés via Terraform
- Conteneurisation : Docker pour le packaging des applications
- Registry : Azure Container Registry pour stocker les images Docker

### Maintenance
#### Suppression des ressources

Pour supprimer toutes les ressources déployées, exécutez :

```bash
cd TERRAFORM
terraform destroy
``` 

#### Mise à jour des applications

Pour mettre à jour les applications après des modifications :

- Reconstruire les images Docker
- Pousser les images vers Azure Container Registry
- Redéployer les applications en utilisant les scripts de déploiement ou en exécutant terraform apply à nouveau

#### Accès aux applications

Une fois déployées, les applications sont accessibles via les URLs suivantes :

-   FastAPI : http://<votre_domaine>.azurecontainer.io:8000
-   Django : http://<votre_domaine>.azurecontainer.io:8080

### Contribution

Les contributions sont les bienvenues ! Pour contribuer :

- Forkez le projet
- Créez une branche pour votre fonctionnalité
- Committez vos changements
- Poussez vers la branche
- Ouvrez une Pull Request

## Licence
MIT License

Copyright (c) 2025 malek boumedine

L'autorisation est accordée, gracieusement, à toute personne obtenant une copie
de ce logiciel et des fichiers de documentation associés (le "Logiciel"), de traiter
le Logiciel sans restriction, notamment sans limitation les droits
d'utiliser, de copier, de modifier, de fusionner, de publier, de distribuer, de sous-licencier,
et/ou de vendre des copies du Logiciel, ainsi que d'autoriser les personnes auxquelles le
Logiciel est fourni à le faire, sous réserve des conditions suivantes :

La notice de copyright ci-dessus et cette notice d'autorisation doivent être incluses dans
toutes les copies ou parties substantielles du Logiciel.

LE LOGICIEL EST FOURNI "TEL QUEL", SANS GARANTIE D'AUCUNE SORTE, EXPLICITE OU IMPLICITE,
NOTAMMENT SANS GARANTIE DE QUALITÉ MARCHANDE, D'ADÉQUATION À UN USAGE PARTICULIER ET
D'ABSENCE DE CONTREFAÇON. EN AUCUN CAS, LES AUTEURS OU TITULAIRES DU DROIT D'AUTEUR NE
SERONT RESPONSABLES DE TOUT DOMMAGE, RÉCLAMATION OU AUTRE RESPONSABILITÉ, QUE CE SOIT DANS
LE CADRE D'UN CONTRAT, D'UN DÉLIT OU AUTRE, EN PROVENANCE DE, CONSÉCUTIF À OU EN RELATION
AVEC LE LOGICIEL OU SON UTILISATION, OU AVEC D'AUTRES ÉLÉMENTS DU LOGICIEL.


