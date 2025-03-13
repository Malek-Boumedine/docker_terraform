from sqlmodel import SQLModel, create_engine, text, Session
from dotenv import load_dotenv
import os
from .modeles import *
import urllib.parse

"""
Module de configuration et de gestion de la connexion à la base de données.
"""

load_dotenv()
DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./test.db")

if "mysql" in DATABASE_URL:
    DATABASE_USERNAME = os.getenv("DATABASE_USERNAME", "root")
    DATABASE_PASSWORD = os.getenv("DATABASE_PASSWORD", "root")
    HOST_NAME = os.getenv("HOST_NAME", "localhost")
    PORT = os.getenv("PORT", "3306")
    DATABASE_NAME = os.getenv("DATABASE_NAME", "loan")

    temp_engine = create_engine(f"mysql+pymysql://{DATABASE_USERNAME}:{DATABASE_PASSWORD}@{HOST_NAME}:{PORT}/")

    with temp_engine.connect() as conn:
        conn.execute(text(f"CREATE DATABASE IF NOT EXISTS {DATABASE_NAME}"))
    temp_engine.dispose()

    DATABASE_URL = f"mysql+pymysql://{DATABASE_USERNAME}:{DATABASE_PASSWORD}@{HOST_NAME}:{PORT}/{DATABASE_NAME}"

elif "mssql" in DATABASE_URL:  # Changé if en elif
    DATABASE_USERNAME = os.getenv("DATABASE_USERNAME")
    DATABASE_PASSWORD = os.getenv("DATABASE_PASSWORD")
    HOST_NAME = os.getenv("HOST_NAME")
    DATABASE_NAME = os.getenv("DATABASE_NAME")
    PORT = os.getenv("PORT", "1433")  # Ajouté le port SQL Server

    connection_string = (
        f"DRIVER={{ODBC Driver 18 for SQL Server}};"
        f"SERVER={HOST_NAME};"
        f"DATABASE={DATABASE_NAME};"
        f"UID={DATABASE_USERNAME};"
        f"PWD={DATABASE_PASSWORD};"
        "Encrypt=yes;"
        "TrustServerCertificate=no;"
        "Connection Timeout=30;"
    )

    params = urllib.parse.quote_plus(connection_string)
    DATABASE_URL = f"mssql+pyodbc:///?odbc_connect={params}"

# Configuration de SQLAlchemy
connect_args = {"check_same_thread": False} if "sqlite" in DATABASE_URL else {}

try:
    # Création du moteur avec logging SQL
    engine = create_engine(DATABASE_URL, connect_args=connect_args, echo=True)

    # Test de connexion
    with engine.connect() as conn:
        print("Connexion à la base de données réussie!")

    # Création des tables
    SQLModel.metadata.create_all(engine)
    print("Tables créées avec succès!")

except Exception as e:
    print(f"Erreur lors de la connexion à la base de données: {str(e)}")
    raise

def db_connection():
    """
    Générateur de session de base de données pour FastAPI.
    """
    session = Session(engine)
    try:
        yield session
    finally:
        session.close()