from app.services.reverse_geo import reverse_geocode
from app.cache.grid import get_grid, set_grid
from app.cache.city import set_city_grids


def get_grid_meta(grid_id: str, center: dict) -> dict:

    cached = get_grid(grid_id)
    if cached:
        return cached

    geo = reverse_geocode(center["lat"], center["lng"])

    if geo:
        set_grid(grid_id, geo)
        if geo.get("city"):
            set_city_grids(geo["city"], grid_id)

    return geo or {}
