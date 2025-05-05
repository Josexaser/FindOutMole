from fastapi import FastAPI, File, UploadFile, HTTPException, Depends, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from PIL import Image
from io import BytesIO
from models.prediction import PredictionResponse
from services.ml_model import predict_image
from services.auth import verify_token

app = FastAPI(title="FindOutMole API")

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:4200", "http://localhost:8000", "http://127.0.0.1:8000", "http://localhost:8080"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "Welcome to FindOutMole API"}

@app.options("/predict")
async def options_predict():
    return JSONResponse(status_code=200)

@app.post("/predict", response_model=PredictionResponse)
async def predict(request: Request, file: UploadFile = File(...), user: dict = Depends(verify_token)):
    print(f"Content-Type del archivo: {file.content_type}")  # Añadir log para depurar
    #if not file.content_type.startswith("image/"):
        #raise HTTPException(status_code=400, detail="File must be an image")
    
    try:
        contents = await file.read()
        image = Image.open(BytesIO(contents))
        prediction, prediction_type, probabilities = predict_image(image)
        
        return PredictionResponse(
            prediction=prediction,
            type=prediction_type,
            probabilities=probabilities
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing image: {str(e)}")