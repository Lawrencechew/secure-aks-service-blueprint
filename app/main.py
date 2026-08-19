import uuid

import uvicorn
from fastapi import FastAPI, Request

from app.config import settings
from app.logging import configure_logging, logger
from app.observability import instrument_app
from app.routes import health, info, metrics, ready

app = FastAPI(title=settings.service_name)


@app.middleware("http")
async def add_request_id(request: Request, call_next):
    request_id = str(uuid.uuid4())
    request.state.request_id = request_id
    logger.info(
        "request.start",
        method=request.method,
        path=request.url.path,
        request_id=request_id,
    )
    response = await call_next(request)
    response.headers["X-Request-ID"] = request_id
    logger.info("request.end", status_code=response.status_code, request_id=request_id)
    return response


app.include_router(info.router)
app.include_router(health.router)
app.include_router(ready.router)
app.include_router(metrics.router)


@app.on_event("startup")
async def startup_event():
    configure_logging(level=settings.log_level.upper())
    instrument_app(
        app, enable_otlp=settings.enable_otlp, otlp_endpoint=settings.otlp_endpoint
    )
    logger.info("service.startup")


@app.on_event("shutdown")
async def shutdown_event():
    logger.info("service.shutdown")


if __name__ == "__main__":
    uvicorn.run("app.main:app", host="0.0.0.0", port=8080, log_level=settings.log_level)
