from PIL import Image
import torch
from torchvision import transforms, models
import numpy as np
from typing import Dict, Tuple
import logging

# Configurar logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Definir las clases
CLASSES = [
    "Nevus (Benigno)",
    "Melanoma (Maligno)",
    "Carcinoma basocelular (Maligno)",
    "Queratosis actínica (Maligno)",
    "Queratosis benigna (Benigno)",
    "Dermatofibroma (Benigno)",
    "Lesión vascular (Benigno)",
    "Carcinoma de células escamosas (Maligno)"
]

# Cargar el modelo
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
try:
    model = models.resnet18(pretrained=False)
    model.fc = torch.nn.Linear(model.fc.in_features, 8)
    state_dict = torch.load("models/bcn20000_model_8classes.pth", map_location=device)
    model.load_state_dict(state_dict)
    model = model.to(device)
    model.eval()
    logger.info("Modelo cargado correctamente")
except Exception as e:
    logger.error(f"Error cargando el modelo: {str(e)}", exc_info=True)
    raise Exception(f"Failed to load model: {str(e)}")

# Transformaciones para preprocesar la imagen
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])

def predict_image(image: Image.Image) -> Tuple[str, str, Dict[str, float]]:
    try:
        if image.mode == "RGBA":
            image = image.convert("RGB")
            logger.info("Imagen convertida de RGBA a RGB")

        image_tensor = transform(image).unsqueeze(0)
        image_tensor = image_tensor.to(device)
        logger.info("Imagen preprocesada y enviada al dispositivo")

        with torch.no_grad():
            outputs = model(image_tensor)
            probabilities = torch.softmax(outputs, dim=1)[0].cpu().numpy() * 100

        probabilities_dict = {cls: float(prob) for cls, prob in zip(CLASSES, probabilities)}
        max_class = max(probabilities_dict, key=probabilities_dict.get)
        prediction_type = "Benigno" if "Benigno" in max_class else "Maligno"
        logger.info(f"Predicción: {max_class}, Tipo: {prediction_type}")

        return max_class, prediction_type, probabilities_dict
    except Exception as e:
        logger.error(f"Error en predict_image: {str(e)}", exc_info=True)
        raise Exception(f"Failed to predict image: {str(e)}")