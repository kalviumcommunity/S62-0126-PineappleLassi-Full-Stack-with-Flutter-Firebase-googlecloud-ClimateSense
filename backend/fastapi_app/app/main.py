from fastapi import FastAPI
from contextlib import asynccontextmanager

from app.db.session import engine
from app.db.base import Base
import app.models  # noqa: F401
from app.api.v1.api import api_router

@asynccontextmanager
async def lifespan(app: FastAPI):
    # STARTUP
    Base.metadata.create_all(bind=engine)
    yield
    # SHUTDOWN (optional cleanup)


app = FastAPI(title="Climate Sense API", lifespan=lifespan)

app.include_router(api_router, prefix="/api/v1");

@app.get("/")
def root():
    return {"message": "FastAPI is running"}
