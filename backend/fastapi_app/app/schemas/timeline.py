# app/schemas/timeline.py

from pydantic import BaseModel


class HourlyData(BaseModel):
    time: str
    temp: int
    aqi: int
    stress: int
    icon: str
    is_now: bool


class TimelineResponse(BaseModel):
    grid_id: str
    hourly: list[HourlyData]
