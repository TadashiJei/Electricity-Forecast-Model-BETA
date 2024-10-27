import joblib
import numpy as np
from fastapi import HTTPException

class PredictionService:
    def __init__(self):
        try:
            self.model = joblib.load('electricity_forecast_model.joblib')
        except Exception as e:
            raise RuntimeError(f"Failed to load model: {str(e)}")

    def predict(self, features: List[float]) -> float:
        try:
            features_array = np.array(features).reshape(1, -1)
            prediction = self.model.predict(features_array)[0]
            return float(prediction)
        except Exception as e:
            raise HTTPException(status_code=400, detail=f"Prediction failed: {str(e)}")