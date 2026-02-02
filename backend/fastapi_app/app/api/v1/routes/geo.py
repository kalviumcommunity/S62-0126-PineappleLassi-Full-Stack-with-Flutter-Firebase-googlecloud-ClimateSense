from fastapi import APIRouter
from app.schemas.geo import GeoResolveRequest, GeoResolveResponse
from app.core.grid import get_grid_id, get_grid_center
from app.core.grid_meta import get_grid_meta

router = APIRouter()


@router.post("/resolve", response_model=GeoResolveResponse)
def resolve_location(payload: GeoResolveRequest):
    grid_id = get_grid_id(payload.lat, payload.lng)
    center = get_grid_center(grid_id)
    
    geo = get_grid_meta(grid_id, center)

    return {
        "grid_id": grid_id,
        "center": center,
        "area" : geo.get("area"),
        "city" : geo.get("city"),
    }
