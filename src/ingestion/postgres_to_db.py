import os
import time
import logging
from dotenv import load_dotenv
from sqlalchemy import create_engine, Engine
from sqlalchemy.exc import SQLAlchemyError

load_dotenv()

logging.basicConfig(
    level=logging.INFO, 
    format="%(asctime)s - %(levelname)s - %(message)s"
)

DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME")

DATABASE_URL = f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

_engine = None

def get_engine() -> Engine:
    """Retorna um Singleton do Engine do SQLAlchemy com lógica de Retry. """
    global _engine
    
    if _engine is not None:
        return _engine

    for i in range(1, 6):
        try:
            logging.info(f"Tentativa {i}/5 - Conectando ao banco em {DB_HOST}...")
            temp_engine = create_engine(DATABASE_URL)
            
            with temp_engine.connect() as conn:
                pass 
                
            _engine = temp_engine
            logging.info("✅ Conexão estabelecida com sucesso!")
            return _engine
            
        except SQLAlchemyError as e:
            logging.error(f"Erro na tentativa {i}/5: {e}")
            if i < 5:
                time.sleep(3)
    
    raise Exception("Falha crítica: Não foi possível conectar ao banco após 5 tentativas.")
