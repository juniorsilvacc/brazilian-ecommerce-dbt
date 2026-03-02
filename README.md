# 📦 Brazilian E-Commerce Analytics Pipeline

Este projeto simula um ecossistema completo de Engenharia de Dados, desde a ingestão de dados brutos de um e-commerce até a disponibilização de modelos prontos para negócio (BI), utilizando as melhores práticas de Medallion Architecture.

# 📌 Contexto

A base de dados utilizada é o Brazilian E-Commerce Public Dataset by Olist, disponibilizado publicamente no Kaggle:
- Fonte: Kaggle – Brazilian E-Commerce Public Dataset by Olist
- Período: 2016 a 2018
- Volume: ~100 mil pedidos
- Domínio: Marketplace / E-commerce

O dataset permite analisar o ciclo completo de um pedido, incluindo:
- Pedidos
- Itens vendidos
- Pagamentos
- Produtos
- Vendedores
- Localização geográfic

📎 Fonte oficial: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

---

## 🚀 O Diferencial deste Projeto
Diferente de uma análise estática, este pipeline simula uma extração programática. Em vez de carregar um CSV manualmente, o Airflow gerencia tarefas que:
- Buscam os dados via API/Script de extração.
- Carregam os dados na camada Bronze (Raw).
- Utilizam o dbt para limpar e transformar os dados na camada Silver (Tratada).
- Consolidam indicadores de performance (KPIs) na camada Gold (Modelada para Negócio).

---

## 📊 Estrutura dos Dados
O projeto processa informações de:
- Pedidos e itens de pedidos.
- Pagamentos e avaliações de clientes.
- Geolocalização e logística de entrega.
- Performance de vendedores por categoria.

---

## 🛠️ Tecnologias Utilizadas
- Orquestração: Apache Airflow
- Ingestão: Python (Simulação de carga incremental/Batch).
- Armazenamento (DW): PostgreSQL
- Transformação: dbt (Data Build Tool) para modelagem SQL.
- Qualidade de Dados: dbt tests para garantir integridade.

---

## 📂 Estrutura do Projeto
```text
brazilian-ecommerce-pipeline-dbt/
├── airflow/                   # Configurações do Orquestrador
│   ├── dags/                  # Suas DAGs que chamam o dbt e o Python
│   └── docker-compose.yaml    # Infraestrutura
├── dbt_project/               # Projeto de Transformação SQL
│   ├── models/                # Camadas Bronze, Silver, Gold
│   └── dbt_project.yml
├── src/                       # CÓDIGO FONTE CUSTOMIZADO
│   ├── ingestion/             
│   │   └── data_generator.py  # Script do Kaggle
│   └── utils/                 
│       └── db_helpers.py      # Funções de conexão, logs, etc.
├── data/                      # Landing Zone (Ignorada no .gitignore)
│   ├── raw/                   # CSVs
│   └── bronze/                # Parquets
├── .env                       # Configuração de Ambientes
├── .gitignore
├── README.md
└── requirements.txt
```

...