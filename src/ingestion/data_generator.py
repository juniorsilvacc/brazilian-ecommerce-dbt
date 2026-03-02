import os
import zipfile
import logging
from pathlib import Path
from dotenv import load_dotenv

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

BASE_DIR = Path(__file__).resolve().parents[2]
RAW_DATA_PATH = BASE_DIR / "data" / "raw"
DOTENV_PATH = BASE_DIR / ".env"

# Carregamento de Credenciais
load_dotenv(dotenv_path=DOTENV_PATH)
os.environ['KAGGLE_API_TOKEN'] = os.getenv('KAGGLE_API_TOKEN', '')

from kaggle.api.kaggle_api_extended import KaggleApi

def ingest_kaggle_data():
    """Extrai dados brutos do Kaggle para a Landing Zone (Raw)"""
    dataset_name = 'olistbr/brazilian-ecommerce'
    
    try:
        # 1. Autenticação
        api = KaggleApi()
        api.authenticate()
        
        # 2. Garantir que o diretório existe
        if not os.path.exists(RAW_DATA_PATH):
            os.makedirs(RAW_DATA_PATH)
            
        logging.info(f"📥 Iniciando extração de {dataset_name}...")

        # 3. Download
        api.dataset_download_files(dataset_name, path=str(RAW_DATA_PATH), unzip=False)
        
        # 4. Extração
        zip_file = RAW_DATA_PATH / 'brazilian-ecommerce.zip'    
        with zipfile.ZipFile(zip_file, 'r') as zip_ref:
            zip_ref.extractall(RAW_DATA_PATH)
        
        # 5. Remove o arquivo Zip
        os.remove(zip_file)

        logging.info(f"✅ Extração concluída! Arquivos disponíveis em: {RAW_DATA_PATH}")
        
    except Exception as e:
        logging.error(f"Erro durante a ingestão: {e}")

if __name__ == "__main__":
    ingest_kaggle_data()