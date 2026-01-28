import json
from app.cache.redis import redis_client
from app.cache.keys import stress_key

STRESS_TTL = 300  # 5 minutes

def get_stress(user_id: str):
    key = stress_key(user_id)
    data = redis_client.get(key)
    return json.loads(data) if data else None

def set_stress(user_id: str, data: dict):
    key = stress_key(user_id)
    redis_client.setex(key, STRESS_TTL, json.dumps(data))
