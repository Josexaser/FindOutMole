from fastapi import HTTPException, Security, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import firebase_admin
from firebase_admin import auth, credentials, firestore
import logging

# Configurar logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Inicializar Firebase Admin SDK
try:
    cred = firebase_admin.credentials.Certificate("firebase-adminsdk.json")
    firebase_admin.initialize_app(cred)  # Sin storageBucket
    logger.info("Firebase Admin SDK inicializado correctamente")
except Exception as e:
    logger.error(f"Error inicializando Firebase Admin SDK: {str(e)}", exc_info=True)
    raise Exception(f"Failed to initialize Firebase: {str(e)}")

# Inicializar Firestore
db = firestore.client()

security = HTTPBearer()

async def verify_token(credentials: HTTPAuthorizationCredentials = Depends(security)):
    try:
        token = credentials.credentials
        decoded_token = auth.verify_id_token(token)
        logger.info(f"Token verificado para usuario: {decoded_token.get('uid')}")
        return decoded_token
    except Exception as e:
        logger.error(f"Error verificando token: {str(e)}", exc_info=True)
        raise HTTPException(status_code=401, detail=f"Invalid token: {str(e)}")