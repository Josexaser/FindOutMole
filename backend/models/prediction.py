from pydantic import BaseModel
from typing import Dict

class PredictionResponse(BaseModel):
    prediction: str
    type: str
    probabilities: Dict[str, float]