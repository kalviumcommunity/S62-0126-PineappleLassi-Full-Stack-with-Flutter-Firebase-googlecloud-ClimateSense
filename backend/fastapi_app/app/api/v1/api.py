from fastapi import APIRouter
from app.api.v1.routes import geo, dashboard, city

api_router = APIRouter()

api_router.include_router(geo.router, prefix="/geo", tags=["Geo"])
api_router.include_router(dashboard.router, prefix="/dashboard", tags=["Dashboard"])
api_router.include_router(city.router, prefix="/city", tags=["City"])