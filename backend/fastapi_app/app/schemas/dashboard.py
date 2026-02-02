from pydantic import BaseModel
from app.schemas.stress import StressData
from app.schemas.city import CityStressResponse


class WeatherData(BaseModel):
    temp: int
    humidity: int
    aqi: int
    weather: str
    icon: str


class DashboardResponse(BaseModel):
    grid_id: str
    area: str | None
    city: str | None
    current: WeatherData
    stress : StressData
    city_data : CityStressResponse
