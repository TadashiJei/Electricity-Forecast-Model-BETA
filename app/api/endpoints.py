from fastapi import APIRouter, HTTPException
from app.models.schemas import ForecastInput, ForecastResponse
from app.services.predictor import PredictionService

router = APIRouter()
prediction_service = PredictionService()

@router.post("/predict", response_model=ForecastResponse)
async def predict(input_data: ForecastInput):
    try:
        prediction = prediction_service.predict(input_data.features)
        return ForecastResponse(prediction=prediction)
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))