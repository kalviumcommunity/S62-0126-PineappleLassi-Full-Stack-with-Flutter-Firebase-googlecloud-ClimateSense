import json
from app.cache.redis import redis_client
from app.cache.keys import grid_id_key

GRID_TTL = 24*60*60 # 24 hours

def get_grid(grid_id: str):
    try:
        key = grid_id_key(grid_id)
        data = redis_client.get(key)
        return json.loads(data) if data else None
    except Exception:
        return {"area": None, "city": None}

def set_grid(grid_id: str, data: dict):
    try:
        key = grid_id_key(grid_id)
        redis_client.setex(key, GRID_TTL, json.dumps(data))
    except Exception:
        pass

