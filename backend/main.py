from fastapi import FastAPI, File, UploadFile, HTTPException, Depends, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from PIL import Image
from io import BytesIO
from models.prediction import PredictionResponse
from services.ml_model import predict_image
from services.auth import verify_token, db
import uuid
from datetime import datetime
import logging
import os
from pathlib import Path

# Configurar logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="FindOutMole API")

# Configurar CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:4200", "http://localhost:8000", "http://127.0.0.1:8000", "http://localhost:8080"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Montar directorio estático para servir imágenes
UPLOAD_DIR = Path("uploads")
UPLOAD_DIR.mkdir(exist_ok=True)
app.mount("/uploads", StaticFiles(directory=UPLOAD_DIR), name="uploads")

@app.get("/")
async def root():
    return {"message": "Welcome to FindOutMole API"}

@app.options("/predict")
async def options_predict():
    return JSONResponse(status_code=200)

@app.post("/predict", response_model=PredictionResponse)
async def predict(request: Request, file: UploadFile = File(...), user: dict = Depends(verify_token)):
    logger.info(f"Recibida solicitud POST /predict para usuario: {user.get('uid')}")
    logger.info(f"Content-Type del archivo: {file.content_type}")

    if not file.content_type.startswith("image/"):
        logger.error("Archivo no es una imagen")
        raise HTTPException(status_code=400, detail="File must be an image")

    try:
        # Leer la imagen
        logger.info("Leyendo contenido del archivo")
        contents = await file.read()
        if not contents:
            logger.error("El archivo está vacío")
            raise HTTPException(status_code=400, detail="Empty file")

        image = Image.open(BytesIO(contents))
        logger.info("Imagen cargada correctamente")

        # Hacer la predicción
        logger.info("Realizando predicción")
        prediction, prediction_type, probabilities = predict_image(image)
        logger.info(f"Predicción completada: {prediction}")

        # Generar un ID único para el diagnóstico
        diagnostic_id = str(uuid.uuid4())
        user_id = user.get('uid')
        logger.info(f"Generado diagnostic_id: {diagnostic_id} para user_id: {user_id}")

        # Guardar la imagen localmente
        logger.info("Guardando imagen localmente")
        user_dir = UPLOAD_DIR / "diagnostics" / user_id
        user_dir.mkdir(parents=True, exist_ok=True)
        image_path = user_dir / f"{diagnostic_id}.jpg"
        with open(image_path, "wb") as f:
            f.write(contents)
        logger.info(f"Imagen guardada en: {image_path}")

        # Generar URL para la imagen
        base_url = str(request.base_url).rstrip("/")
        image_url = f"{base_url}/uploads/diagnostics/{user_id}/{diagnostic_id}.jpg"
        logger.info(f"URL de la imagen: {image_url}")

        # Guardar el diagnóstico en Firestore
        logger.info("Guardando diagnóstico en Firestore")
        diagnostic_data = {
            "prediction": prediction,
            "type": prediction_type,
            "probabilities": probabilities,
            "image_url": image_url,
            "timestamp": datetime.utcnow(),
            "diagnostic_id": diagnostic_id,  # Incluir diagnostic_id
        }
        db.collection("users").document(user_id).collection("diagnostics").document(diagnostic_id).set(diagnostic_data)
        logger.info("Diagnóstico guardado en Firestore")

        return PredictionResponse(
            prediction=prediction,
            type=prediction_type,
            probabilities=probabilities
        )
    except Exception as e:
        logger.error(f"Error procesando la solicitud: {str(e)}", exc_info=True)
        raise HTTPException(status_code=500, detail=f"Error processing image: {str(e)}")

@app.get("/diagnostics")
async def get_diagnostics(user: dict = Depends(verify_token)):
    logger.info(f"Recibida solicitud GET /diagnostics para usuario: {user.get('uid')}")
    try:
        user_id = user.get('uid')
        docs = db.collection("users").document(user_id).collection("diagnostics").stream()
        diagnostics = [
            {**doc.to_dict(), "diagnostic_id": doc.id} for doc in docs
        ]
        logger.info(f"Devolviendo {len(diagnostics)} diagnósticos")
        return {"diagnostics": diagnostics}
    except Exception as e:
        logger.error(f"Error obteniendo diagnósticos: {str(e)}", exc_info=True)
        raise HTTPException(status_code=500, detail=f"Error retrieving diagnostics: {str(e)}")

@app.delete("/diagnostics/{diagnostic_id}")
async def delete_diagnostic(diagnostic_id: str, user: dict = Depends(verify_token)):
    logger.info(f"Recibida solicitud DELETE /diagnostics/{diagnostic_id} para usuario: {user.get('uid')}")
    try:
        user_id = user.get('uid')
        # Verificar que el diagnóstico existe
        doc_ref = db.collection("users").document(user_id).collection("diagnostics").document(diagnostic_id)
        doc = doc_ref.get()
        if not doc.exists:
            logger.error(f"Diagnóstico {diagnostic_id} no encontrado")
            raise HTTPException(status_code=404, detail="Diagnostic not found")

        # Eliminar la imagen local
        image_path = UPLOAD_DIR / "diagnostics" / user_id / f"{diagnostic_id}.jpg"
        if image_path.exists():
            image_path.unlink()
            logger.info(f"Imagen eliminada: {image_path}")
        else:
            logger.warning(f"Imagen no encontrada: {image_path}")

        # Eliminar el documento de Firestore
        doc_ref.delete()
        logger.info(f"Diagnóstico {diagnostic_id} eliminado de Firestore")

        return {"message": "Diagnostic deleted successfully"}
    except Exception as e:
        logger.error(f"Error eliminando diagnóstico: {str(e)}", exc_info=True)
        raise HTTPException(status_code=500, detail=f"Error deleting diagnostic: {str(e)}")