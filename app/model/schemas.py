from pydantic import BaseModel
from typing import List

class ForecastInput(BaseModel):
    features: List[float]

class ForecastResponse(BaseModel):
    prediction: float