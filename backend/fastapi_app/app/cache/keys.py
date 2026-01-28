def forecast_key(lat: float, lon: float) -> str:
    return f"forecast:{lat}:{lon}"

def stress_key(user_id: str) -> str:
    return f"stress:{user_id}"

def city_stress_key(city: str) -> str:
    return f"city_stress:{city}"
