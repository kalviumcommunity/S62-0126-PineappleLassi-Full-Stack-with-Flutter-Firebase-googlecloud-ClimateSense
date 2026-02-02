import json
from app.cache.redis import redis_client
from app.cache.keys import stress_key

STRESS_TTL = 10 * 60  # 10 minutes


def get_stress(grid_id: str):
    try:
        key = stress_key(grid_id)
        data = redis_client.get(key)
        return json.loads(data) if data else None
    except Exception:
        return None

def set_stress(grid_id: str, data: dict):
    try:
        key = stress_key(grid_id)
        redis_client.setex(key, STRESS_TTL, json.dumps(data))
    except Exception:
        pass
