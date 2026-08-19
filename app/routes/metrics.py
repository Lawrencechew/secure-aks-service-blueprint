from fastapi import APIRouter

from app.observability import metrics_endpoint

router = APIRouter()


@router.get("/metrics")
async def metrics():
    return metrics_endpoint()
