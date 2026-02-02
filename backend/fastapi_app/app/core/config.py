# app/core/config.py
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    DATABASE_URL: str
    REDIS_URL: str
    NOMINATION_URL: str
    OPENWEATHER_API_KEY: str
    OPENWEATHER_BASE_URL: str

    class Config:
        env_file = ".env"

settings = Settings()
