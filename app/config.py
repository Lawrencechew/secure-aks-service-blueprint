from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    service_name: str = "secure-aks-service"
    environment: str = "development"
    otlp_endpoint: str | None = None
    enable_otlp: bool = False
    log_level: str = "info"

    class Config:
        env_file = ".env"


settings = Settings()
