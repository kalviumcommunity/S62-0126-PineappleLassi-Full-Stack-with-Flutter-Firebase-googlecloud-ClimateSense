import requests
from app.core.config import settings
from fastapi import HTTPException
from app.core.logger import logger

def fetch_weather(lat: float, lng: float) -> dict:
    url = f"{settings.OPENWEATHER_BASE_URL}/weather"
    params = {
        "lat": lat, 
        "lon": lng,
        "appid": settings.OPENWEATHER_API_KEY,
        "units": "metric"
    }

    try:

        r = requests.get(url, params=params, timeout=5)
        r.raise_for_status()
        data: dict = r.json()

        return {
            "temp": round(data["main"]["temp"]),
            "humidity": data["main"]["humidity"],
            "weather": data["weather"][0]["main"],
            "icon": f"https://openweathermap.org/img/wn/{data["weather"][0]["icon"]}@2x.png"
        }
    except requests.HTTPError as e:
        status = e.response.status_code if e.response else None

        if status == 429:
            logger.warning(
                "Weather API rate limited",
                extra={"service": "openweather", "status": status},
            )
            raise HTTPException(503, "Weather API rate limited")

        logger.error(
            "Weather API HTTP error",
            extra={"service": "openweather", "status": status},
            exc_info=e,
        )
        raise HTTPException(502, "Weather API error")
    
    except (requests.Timeout, requests.ConnectionError) as e:
        logger.error(
            "Weather API unreachable",
            extra={"service": "openweather"},
            exc_info=e,
        )
        raise HTTPException(503, "Weather service unavailable")
        


def fetch_aqi(lat: float, lng: float) -> int:
    url = f"{settings.OPENWEATHER_BASE_URL}/air_pollution"
    params = {
        "lat": lat,
        "lon": lng,
        "appid": settings.OPENWEATHER_API_KEY
    }

    try:
        r = requests.get(url, params=params, timeout=5)
        r.raise_for_status()
        data = r.json()

        return data["list"][0]["main"]["aqi"] * 50  # normalize (1–5 → ~50–250)
    
    except requests.HTTPError as e:
        status = e.response.status_code if e.response else None

        if status == 429:
            logger.warning(
                "AQI API rate limited",
                extra={"service": "openweather", "status": status},
            )
            raise HTTPException(503, "Weather API rate limited")

        logger.error(
            "AQI API HTTP error",
            extra={"service": "openweather", "status": status},
            exc_info=e,
        )
        raise HTTPException(502, "Weather API error")

    except (requests.Timeout, requests.ConnectionError) as e:
        logger.error(
            "AQI API unreachable",
            extra={"service": "openweather"},
            exc_info=e,
        )
        raise HTTPException(503, "Weather service unavailable")
