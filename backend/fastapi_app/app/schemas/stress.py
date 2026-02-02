from pydantic import BaseModel
from typing import List


class StressReason(BaseModel):
    type: str
    value: int
    impact: float
    message: str


class StressData(BaseModel):
    value: int
    reasons: List[StressReason]
    version: str
