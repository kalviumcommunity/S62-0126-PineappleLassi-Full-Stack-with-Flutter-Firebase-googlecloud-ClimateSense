import json
from app.cache.redis import redis_client
from app.cache.keys import grid_id_weather_key

WEATHER_TTL = 10*60 # 10 minutes

def get_grid_weather(grid_id: str):
    try:
        key = grid_id_weather_key(grid_id)
        data = redis_client.get(key)
        return json.loads(data) if data else None
    except Exception:
        return None
    

def set_grid_weather(grid_id : str, data: dict):
    try:
        key = grid_id_weather_key(grid_id)
        redis_client.setex(key, WEATHER_TTL, json.dumps(data))
    except Exception:
        pass
