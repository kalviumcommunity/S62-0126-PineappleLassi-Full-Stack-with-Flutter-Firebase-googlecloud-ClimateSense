from app.core.city import compute_city_stress, detect_trend
from app.cache.city import (
    get_city_stress_cache,
    set_city_stress_cache,
    get_city_grids,
    get_city_previous_stress,
    set_city_previous_stress,
)
from app.cache.stress import get_stress


MIN_GRIDS_FOR_CONFIDENCE = 5

def calculate_city_stress(city: str):

    # 1️⃣ Cache check
    cached = get_city_stress_cache(city)
    if cached:
        return cached

    # 2️⃣ Collect grid stresses
    grid_ids = get_city_grids(city)
    grid_count = len(grid_ids)

    if grid_count == 0:
        result = {
            "city": city,
            "available": False,
            "confidence": None,
            "grid_count": 0,
            "avg_stress": None,
            "trend": None,
        }
        set_city_stress_cache(city, result)
        return result

    stresses = []
    for grid_id in grid_ids:
        stress = get_stress(grid_id)
        if stress:
            stresses.append(stress["value"])

    if not stresses:
        result = {
            "city": city,
            "available": False,
            "confidence": None,
            "grid_count": grid_count,
            "avg_stress": None,
            "trend": None,
        }
        set_city_stress_cache(city, result)
        return result

    # 3️⃣ Compute city average
    city_avg = compute_city_stress(stresses)

    # 4️⃣ Confidence & trend
    if grid_count < MIN_GRIDS_FOR_CONFIDENCE:
        result = {
            "city": city,
            "available": True,
            "confidence": "low",
            "grid_count": grid_count,
            "avg_stress": city_avg,
            "trend": "unknown",
        }

        # IMPORTANT: do NOT update previous
        set_city_stress_cache(city, result)
        return result

    # 5️⃣ High-confidence case
    prev = get_city_previous_stress(city)
    prev_val = int(prev) if prev is not None else city_avg

    trend = detect_trend(prev_val, city_avg)

    result = {
        "city": city,
        "available": True,
        "confidence": "high",
        "grid_count": grid_count,
        "avg_stress": city_avg,
        "trend": trend,
    }

    # 6️⃣ Cache + update baseline
    set_city_stress_cache(city, result)
    set_city_previous_stress(city, city_avg)

    return result
