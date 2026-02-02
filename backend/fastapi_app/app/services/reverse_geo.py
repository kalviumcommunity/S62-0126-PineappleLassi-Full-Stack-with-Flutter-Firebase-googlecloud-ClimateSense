import requests
from app.core.config import settings
from app.core.logger import logger



def reverse_geocode(lat: float, lng: float) -> dict:
    params = {
        "lat": lat,
        "lon": lng,
        "format": "json"
    }

    headers = {
        "User-Agent": "ClimateSense/1.0"
    }
    try: 
        response = requests.get(
            settings.NOMINATION_URL,
            params=params,
            headers=headers,
            timeout=5
        )
        response.raise_for_status()

        address = response.json().get("address", {})

        return {
            "area": address.get("suburb")
                    or address.get("neighbourhood")
                    or address.get("locality")
                    or address.get("county"),
            "city": address.get("city")
                    or address.get("town")
                    or address.get("state_district")
                    or address.get("state")
        }
    except (requests.Timeout, requests.ConnectionError, requests.HTTPError) as e:
        logger.warning("Reverse geocoding failed", exc_info=e)
        return {}

