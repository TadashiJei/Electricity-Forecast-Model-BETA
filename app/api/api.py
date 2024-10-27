from fastapi import APIRouter
from app.api.endpoints import router as predict_router

api_router = APIRouter()
api_router.include_router(predict_router, tags=["predictions"])