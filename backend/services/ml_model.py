from PIL import Image
import torch
from torchvision import transforms, models
import numpy as np
from typing import Dict, Tuple

# Definir las clases (ajusta según las clases reales de tu modelo)
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

# Cargar el modelo (usamos ResNet50 como suposición)
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = models.resnet18(pretrained=False)  # Creamos una instancia de ResNet50
model.fc = torch.nn.Linear(model.fc.in_features, 8)  # Ajustamos la capa final para 8 clases
state_dict = torch.load("models/bcn20000_model_8classes.pth", map_location=device)
model.load_state_dict(state_dict)  # Cargamos los pesos
model = model.to(device)
model.eval()  # Poner el modelo en modo evaluación

# Transformaciones para preprocesar la imagen
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])

def predict_image(image: Image.Image) -> Tuple[str, str, Dict[str, float]]:
    """
    Procesa la imagen y devuelve la predicción usando el modelo entrenado.
    """
    # Convertir la imagen a formato RGB si tiene canal alfa
    if image.mode == "RGBA":
        image = image.convert("RGB")
    
    # Aplicar transformaciones
    image_tensor = transform(image).unsqueeze(0)  # Añadir dimensión batch
    image_tensor = image_tensor.to(device)
    
    # Hacer predicción
    with torch.no_grad():
        outputs = model(image_tensor)
        probabilities = torch.softmax(outputs, dim=1)[0].cpu().numpy() * 100
    
    # Crear diccionario de probabilidades
    probabilities_dict = {cls: float(prob) for cls, prob in zip(CLASSES, probabilities)}
    
    # Obtener la predicción y el tipo
    max_class = max(probabilities_dict, key=probabilities_dict.get)
    prediction_type = "Benigno" if "Benigno" in max_class else "Maligno"
    
    return max_class, prediction_type, probabilities_dict