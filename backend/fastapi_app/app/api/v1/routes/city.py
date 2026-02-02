from fastapi import APIRouter
from app.services.city import calculate_city_stress
from app.schemas.city import CityStressResponse

router = APIRouter()



@router.get("/stress",response_model=CityStressResponse)
def get_city_stress(city: str):
    return calculate_city_stress(city)