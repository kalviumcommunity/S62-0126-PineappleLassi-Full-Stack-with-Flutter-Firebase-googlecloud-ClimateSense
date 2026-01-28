from fastapi import FastAPI
from contextlib import asynccontextmanager

from app.db.session import engine
from app.db.base import Base
import app.models  # noqa: F401

@asynccontextmanager
async def lifespan(app: FastAPI):
    # STARTUP
    Base.metadata.create_all(bind=engine)
    yield
    # SHUTDOWN (optional cleanup)


app = FastAPI(title="Climate Sense API", lifespan=lifespan)

@app.get("/")
def root():
    return {"message": "FastAPI is running"}
