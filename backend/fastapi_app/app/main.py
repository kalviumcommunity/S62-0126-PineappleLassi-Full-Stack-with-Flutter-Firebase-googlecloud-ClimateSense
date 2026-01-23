from fastapi import FastAPI

app = FastAPI(title="Climate Sense API")

@app.get("/")
def root():
    return {"message": "FastAPI is running"}
