import pandas as pd
import logging
from pathlib import Path
import os

logging.basicConfig(
    level=logging.INFO, 
    format="%(asctime)s - %(levelname)s - %(message)s"
)

BASE_DIR = Path(__file__).resolve().parents[2]
LANDING_PATH  = BASE_DIR / "data" / "landing"
RAW_PATH = BASE_DIR / "data" / "raw"

FILE_MAPPING = {
    "olist_customers_dataset": "raw_customers",
    "olist_geolocation_dataset": "raw_geolocation",
    "olist_order_items_dataset": "raw_order_items",
    "olist_order_payments_dataset": "raw_order_payments",
    "olist_order_reviews_dataset": "raw_order_reviews",
    "olist_orders_dataset": "raw_orders",
    "olist_products_dataset": "raw_products",
    "olist_sellers_dataset": "raw_sellers",
    "product_category_name_translation": "raw_product_category_translation"
}

def convert_to_parquet():
    """Converte arquivos CSV da (Landing) para Parquet na (Raw)"""
    try:
        # 1. Garantir que o diretório existe
        if not os.path.exists(RAW_PATH):
            os.makedirs(RAW_PATH)
            
        logging.info("🚀 Iniciando conversão de CSV para Parquet (Camada Raw)...")
        
        # 2. Iterar sobre o mapeamento para garantir a renomeação
        for old_name, new_name in FILE_MAPPING.items():
            source_file = LANDING_PATH / f"{old_name}.csv"
            target_file = RAW_PATH / f"{new_name}.parquet"
            
            if source_file.exists():
                logging.info(f"⚡ Processando: {old_name}.csv -> {new_name}.parquet")
                
                df = pd.read_csv(source_file)
    
                df.to_parquet(target_file, index=False, engine='pyarrow', compression='snappy')
            else:
                logging.warning(f"Arquivo não encontrado na Landing: {old_name}.csv")
        logging.info(f"✅ Processo concluído! Arquivos disponíveis em: {RAW_PATH}")
    except Exception as e:
        logging.error(f"Erro na conversão para Bronze: {e}")
