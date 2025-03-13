# Point d'entrée de l'application
from fastapi import FastAPI, Request
from app.endpoints import route_loans, route_admin, route_auth



"""
Point d'entrée principal de l'API de prédiction de prêts.

Ce module initialise l'application FastAPI et configure les routes
pour l'authentification, l'administration et la gestion des prêts.

Application Properties:
    title: "API de prêts"
    description: "API pour prédire l'accord de prêts"
    version: "0.1"

Routes incluses:
    - /loans: Gestion des demandes de prêts et prédictions
    - /admin: Administration des utilisateurs
    - /auth: Authentification et gestion des tokens

Note:
    L'API utilise FastAPI pour:
    - Documentation automatique (Swagger UI sur /docs)
    - Validation des données avec Pydantic
    - Gestion des routes avec APIRouter
    - Support asynchrone natif
"""

# Créer l'application FastAPI
app = FastAPI(title="API de prêts", description="API pour prédire l'accord de prêts", version="0.2")

@app.get("/")
def root(request: Request):
    # Récupérer l'URL de base de la requête (ex: http://localhost:8000 ou http://mon-api.com)
    base_url = str(request.base_url)
    
    return {
        "message": "Bienvenue sur l'API de Prédiction de Prêts",
        "description": "Cette API permet aux institutions bancaires de soumettre des demandes de prêts et d'obtenir une prédiction basée sur un modèle de machine learning CatBoost.",
        "documentation": {
            "swagger": f"Accédez à la documentation Swagger ici: {base_url}docs",
            "redoc": f"Accédez à la documentation Redoc ici: {base_url}redoc"
        },
        "status": "En cours de développement"
    }

# inclure les routes
app.include_router(route_loans.router)
app.include_router(route_admin.router)
app.include_router(route_auth.router)

