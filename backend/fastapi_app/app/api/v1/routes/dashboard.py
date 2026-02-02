# app/api/dashboard.py

from fastapi import APIRouter
from app.core.grid import get_grid_id, get_grid_center
from app.core.stress import calculate_stress
from app.core.timeline import build_hourly_timeline
from app.core.grid_meta import get_grid_meta
from app.services.weather import fetch_weather, fetch_aqi
from app.services.city import calculate_city_stress
from app.schemas.dashboard import DashboardResponse
from app.schemas.timeline import TimelineResponse
from app.cache.weather import get_grid_weather, set_grid_weather
from app.cache.stress import get_stress, set_stress
from app.cache.timeline import get_grid_timeline, set_grid_timeline
from app.services.forecast import fetch_weather_forecast, fetch_aqi_forecast

router = APIRouter()


@router.get("/current", response_model=DashboardResponse)
def get_current_dashboard(lat: float, lng: float):

    grid_id = get_grid_id(lat, lng)
    center = get_grid_center(grid_id)

    # 1️⃣ Try cache
    cached = get_grid_weather(grid_id)
    if cached:
        weather = cached
    else:
        # 2️⃣ Fetch from APIs
        weather = fetch_weather(center["lat"], center["lng"])
        weather["aqi"] = fetch_aqi(center["lat"], center["lng"])

        set_grid_weather(grid_id, weather)

    # 3️⃣ Fetch location name (already cached in step 2)

    cached_stress = get_stress(grid_id)
    if cached_stress:
        stress = cached_stress
    else:
        stress = calculate_stress(
            temp=weather["temp"],
        humidity=weather["humidity"],
        aqi=weather["aqi"]
        )

        set_stress(grid_id, stress)

    location = get_grid_meta(grid_id,center)

    city_data = calculate_city_stress(location.get("city"))


    return {
        "grid_id": grid_id,
        "area": location.get("area"),
        "city": location.get("city"),
        "current": weather,
        "stress" : stress,
        "city_data" : city_data
    }


@router.get("/timeline", response_model=TimelineResponse)
def get_timeline(lat: float, lng: float):

    grid_id = get_grid_id(lat, lng)
    center = get_grid_center(grid_id)

    cached = get_grid_timeline(grid_id)
    if cached:
        return {
            "grid_id": grid_id,
            "hourly": cached
        }

    weather_hours = fetch_weather_forecast(center["lat"], center["lng"])
    aqi_forecast = fetch_aqi_forecast(center["lat"], center["lng"])
    
    timeline = build_hourly_timeline(weather_hours, aqi_forecast)

    set_grid_timeline(grid_id,timeline)

    return {
        "grid_id": grid_id,
        "hourly": timeline
    }
