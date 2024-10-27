from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import numpy as np
from typing import List
import uvicorn
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load Forecast model
model = joblib.load('electricity_forecast_model.joblib')

class ForecastInput(BaseModel):
    features: List[float]

class ForecastResponse(BaseModel):
    prediction: float

@app.post("/predict", response_model=ForecastResponse)
async def predict(input_data: ForecastInput):
    try:
        features = np.array(input_data.features).reshape(1, -1)
        prediction = model.predict(features)[0]
        return ForecastResponse(prediction=float(prediction))
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
