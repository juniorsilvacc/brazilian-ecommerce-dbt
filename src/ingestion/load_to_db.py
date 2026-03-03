import pandas as pd
import logging
from pathlib import Path
from postgres_to_db import get_engine


logging.basicConfig(
    level=logging.INFO, 
    format="%(asctime)s - %(levelname)s - %(message)s"
)

BASE_DIR = Path(__file__).resolve().parents[2]
RAW_PATH = BASE_DIR / "data" / "raw"

def load_bronze_to_postgres():
    """Lê os ficheiros Parquet da pasta Raw e envia para o Postgres"""
    try:
        engine = get_engine()
        
        parquet_files = list(RAW_PATH.glob("*.parquet"))
        
        if not parquet_files:
            logging.warning("Nenhum ficheiro .parquet encontrado na pasta Raw.")
            return

        logging.info(f"Inicializando a carga de {len(parquet_files)} tabelas para o Postgres...")

        for file in parquet_files:
            table_name = file.stem 
            
            df = pd.read_parquet(file)
            
            df.to_sql(
                name=table_name, 
                con=engine, 
                if_exists='replace', 
                index=False,
                chunksize=10000
            )
            
            logging.info(f"✅ Tabela {table_name} carregada ({len(df)} linhas).")

        logging.info("✅ Carga concluída com sucesso!")

    except Exception as e:
        logging.error(f"Erro fatal durante a carga: {e}")
