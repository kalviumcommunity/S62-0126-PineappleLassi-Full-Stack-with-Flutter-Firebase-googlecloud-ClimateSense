def grid_id_key(grid_id: str) -> str:
    return f"grid:{grid_id}"

def grid_id_weather_key(grid_id: str) -> str:
    return f"{grid_id_key(grid_id)}:weather"

def stress_key(grid_id: str) -> str:
    return f"{grid_id_key(grid_id)}:stress"

def grid_timeline_key(grid_id: str) -> str:
    return f"{grid_id_key(grid_id)}:timeline"

def city_stress_key(city: str) -> str:
    return f"city:{city}:current"

def city_previous_stress_key(city: str) -> str:
    return f"city:{city}:previous"

def city_grid_key(city: str) -> str:
    return f"city:{city}:grids"
