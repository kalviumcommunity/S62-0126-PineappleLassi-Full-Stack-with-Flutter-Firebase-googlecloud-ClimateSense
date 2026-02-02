from pydantic import BaseModel
from typing import Optional, Literal


class CityStressResponse(BaseModel):
    city: str
    available: bool
    confidence: Optional[Literal["low", "high"]] = None
    grid_count: int
    avg_stress: Optional[int] = None
    trend: Optional[Literal["rising", "falling", "stable", "unknown"]] = None
