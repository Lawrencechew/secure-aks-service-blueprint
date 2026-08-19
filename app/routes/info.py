from fastapi import APIRouter

from app.config import settings

router = APIRouter()


@router.get("/")
async def root():
    return {"service": settings.service_name, "environment": settings.environment}
