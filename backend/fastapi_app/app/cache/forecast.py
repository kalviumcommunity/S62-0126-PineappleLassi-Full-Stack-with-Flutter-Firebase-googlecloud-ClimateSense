import json
from app.cache.redis import redis_client
from app.cache.keys import forecast_key

FORECAST_TTL = 600  # 10 minutes

def get_forecast(lat: float, lon: float):
    key = forecast_key(lat, lon)
    data = redis_client.get(key)
    return json.loads(data) if data else None

def set_forecast(lat: float, lon: float, data: dict):
    key = forecast_key(lat, lon)
    redis_client.setex(key, FORECAST_TTL, json.dumps(data))
