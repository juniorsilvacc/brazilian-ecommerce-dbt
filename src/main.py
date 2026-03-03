from ingestion.data_generator import ingest_kaggle_data
from processing.raw_converter import convert_to_parquet

def main():
    ingest_kaggle_data()
    convert_to_parquet()

if __name__ == '__main__':
    main()