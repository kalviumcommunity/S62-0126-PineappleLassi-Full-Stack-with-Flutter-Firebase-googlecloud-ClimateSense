# app/core/grid.py

from math import floor

# ~1 km grid (good for city-scale apps)
GRID_SIZE = 0.009


def get_grid_id(lat: float, lng: float) -> str:
    """
    Snap latitude & longitude to a grid.
    Returns a stable grid_id.
    """
    grid_lat = floor(lat / GRID_SIZE) * GRID_SIZE
    grid_lng = floor(lng / GRID_SIZE) * GRID_SIZE

    return f"{grid_lat:.3f}_{grid_lng:.3f}"


def get_grid_center(grid_id: str) -> dict:
    """
    Given a grid_id, return the center of the grid.
    """
    lat, lng = map(float, grid_id.split("_"))

    center_lat = lat + GRID_SIZE / 2
    center_lng = lng + GRID_SIZE / 2

    return {
        "lat": round(center_lat, 6),
        "lng": round(center_lng, 6)
    }
