from fastapi import APIRouter

router = APIRouter()


@router.get("/ready")
async def ready():
    # readiness checks would go here (conf, external dependencies)
    return {"ready": True}
