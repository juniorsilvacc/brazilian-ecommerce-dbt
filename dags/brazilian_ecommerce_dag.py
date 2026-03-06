from datetime import datetime, timedelta
from airflow.decorators import dag, task
from airflow.operators.bash import BashOperator
from dotenv import load_dotenv
from pathlib import Path
import sys

sys.path.insert(0, '/opt/airflow')

from src.ingestion.data_generator import ingest_kaggle_data
from src.ingestion.load_to_db import load_bronze_to_postgres
from src.processing.raw_converter import convert_to_parquet

env_path = Path(__file__).resolve().parent.parent / '.env'
load_dotenv(env_path)

@dag(
    dag_id='brazilian-ecommerce-dbt',
    default_args={
        'owner': 'airflow',
        'depends_on_past': False,
        'retries': 2,
        'retry_delay': timedelta(minutes=5)
    },
    description='Pipeline ELT: Kaggle - Brazilian Ecommerce',
    schedule='0 8 * * *', # Rodando às 08:00 AM (Todos os dias)
    start_date=datetime(2026, 2, 1),
    catchup=False,
    tags=['ecommerce', 'kaggle', 'elt']
)
def brazilian_ecommerce():
    
    @task()
    def extract():
        ingest_kaggle_data()

    @task()
    def process():
        convert_to_parquet()
    
    @task()
    def load():
        load_bronze_to_postgres()

    dbt_run = BashOperator(
        task_id='dbt_build',
        bash_command='cd /opt/airflow/transform && dbt build --profile transform --profiles-dir .'
    )

    extract() >> process() >> load() >> dbt_run

brazilian_ecommerce()