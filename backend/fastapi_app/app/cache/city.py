import json
from app.cache.redis import redis_client
from app.cache.keys import city_stress_key, city_grid_key, city_previous_stress_key

CITY_TTL = 30*60 # 30 minutes
CITY_STRESS_TTL = 60 * 60 #60 minutes

def get_city_stress_cache(city: str):
    try:
        key = city_stress_key(city)
        data = redis_client.get(key)
        return json.loads(data) if data else None
    except Exception:
        return None

def set_city_stress_cache(city: str, data: dict):
    try:
        key = city_stress_key(city)
        redis_client.setex(key, CITY_TTL, json.dumps(data))
    except Exception:
        pass

def get_city_grids(city: str):
    try:
        key = city_grid_key(city)
        grids = redis_client.smembers(key)
        return list(grids) if grids else []
    except Exception:
        return []

def set_city_grids(city: str, grid_id: str):
    try:
        key = city_grid_key(city)
        redis_client.sadd(key, grid_id)
    except Exception:
        pass

def get_city_previous_stress(city: str):
    try:
        key = city_previous_stress_key(city)
        data = redis_client.get(key)
        return json.loads(data) if data else None
    except Exception:
        return None

def set_city_previous_stress(city: str, stress: int):
    try:
        key = city_previous_stress_key(city)
        redis_client.setex(key,CITY_STRESS_TTL, stress)
    except Exception:
        pass