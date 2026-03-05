FROM apache/airflow:3.1.7

USER root
# Instala git caso o dbt precise baixar algum pacote do hub
RUN apt-get update && apt-get install -y git && apt-get clean

USER airflow

# Copia o seu requirements.txt da máquina local para dentro do container
COPY requirements.txt /requirements.txt

# Instala o dbt e o conector do postgres
RUN pip install --no-cache-dir -r /requirements.txt