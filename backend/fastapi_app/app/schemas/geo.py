from pydantic import BaseModel, Field


class GeoResolveRequest(BaseModel):
    lat: float = Field(..., description="Latitude")
    lng: float = Field(..., description="Longitude")


class GridCenter(BaseModel):
    lat: float
    lng: float


class GeoResolveResponse(BaseModel):
    grid_id: str
    center: GridCenter
    area: str | None = None
    city: str | None = None
