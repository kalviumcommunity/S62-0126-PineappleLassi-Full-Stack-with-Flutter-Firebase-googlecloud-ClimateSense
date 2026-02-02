import json
from app.cache.redis import redis_client
from app.cache.keys import grid_timeline_key

TIMELINE_TTL = 60 * 60  # 60 minutes


def get_grid_timeline(grid_id: str):
    try:
        key = grid_timeline_key(grid_id)
        data = redis_client.get(key)
        return json.loads(data) if data else None
    except Exception:
        return None

def set_grid_timeline(grid_id: str, data: dict):
    try:
        key = grid_timeline_key(grid_id)
        redis_client.setex(key, TIMELINE_TTL, json.dumps(data))
    except Exception:
        pass
