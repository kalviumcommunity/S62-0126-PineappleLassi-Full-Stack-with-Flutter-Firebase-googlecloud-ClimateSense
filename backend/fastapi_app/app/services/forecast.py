import requests
from app.core.config import settings
from app.core.logger import logger
from fastapi import HTTPException


def fetch_weather_forecast(lat: float, lng: float, hours: int = 12):
    url = f"{settings.OPENWEATHER_BASE_URL}/forecast"
    params = {
        "lat": lat,
        "lon": lng,
        "appid": settings.OPENWEATHER_API_KEY,
        "units": "metric"
    }

    try:

        r = requests.get(url, params=params, timeout=5)
        r.raise_for_status()

        data = r.json()["list"][:hours]

        hourly = []
        for item in data:
            hourly.append({
                "timestamp": item["dt"],
                "temp": round(item["main"]["temp"]),
                "humidity": item["main"]["humidity"],
                "weather": item["weather"][0]["main"],
                "icon": item["weather"][0]["icon"]
            })

        return hourly
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


def fetch_aqi_forecast(lat: float, lng: float, hours: int = 12):
    url = f"{settings.OPENWEATHER_BASE_URL}/air_pollution/forecast"
    params = {
        "lat": lat,
        "lon": lng,
        "appid": settings.OPENWEATHER_API_KEY,
    }

    try:
        r = requests.get(url, params=params, timeout=5)
        r.raise_for_status()

        data = r.json()["list"][:hours]

        aqi_forecast = {}
        for item in data:
            aqi_forecast[item["dt"]] = item["main"]["aqi"] * 50
            # 1–5 → ~50–250 normalization

        return aqi_forecast

    except requests.HTTPError as e:
        status = e.response.status_code if e.response else None

        if status == 429:
            logger.warning(
                "AQI API rate limited",
                extra={"service": "openweather", "status": status},
            )
            raise HTTPException(503, "AQI API rate limited")

        logger.error(
            "AQI API HTTP error",
            extra={"service": "openweather", "status": status},
            exc_info=e,
        )
        raise HTTPException(502, "AQI API error")

    except (requests.Timeout, requests.ConnectionError) as e:
        logger.error(
            "AQI API unreachable",
            extra={"service": "openweather"},
            exc_info=e,
        )
        raise HTTPException(503, "AQI service unavailable")