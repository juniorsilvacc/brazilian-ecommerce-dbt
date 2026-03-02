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

## 🏗️ Arquitetura do Pipeline

IMG

---

## 🛠️ Tecnologias Utilizadas
- Orquestração: Apache Airflow
- Ingestão: Python (Simulação de carga incremental/Batch).
- Armazenamento (DW): PostgreSQL
- Transformação: dbt (Data Build Tool) para modelagem SQL.
- Qualidade de Dados: dbt tests para garantir integridade.

---

## 📊 Estrutura dos Dados
O projeto processa informações de:
- Pedidos e itens de pedidos.
- Pagamentos e avaliações de clientes.
- Geolocalização e logística de entrega.
- Performance de vendedores por categoria.

---

## 🎯 O Diferencial deste Projeto
Diferente de uma análise estática, este pipeline simula uma extração programática. Em vez de carregar um CSV manualmente, o Airflow gerencia tarefas que:
- Buscam os dados via API/Script de extração.
- Carregam os dados na camada Bronze (Raw).
- Utilizam o dbt para limpar e transformar os dados na camada Silver (Tratada).
- Consolidam indicadores de performance (KPIs) na camada Gold (Modelada para Negócio).

---

## 🚀 Etapas do Projeto
### 1️⃣ Extração (Extract)
Os dados foram baixados diretamente do Kaggle em formato CSV e armazenados localmente.

Arquivos utilizados:
- raw_orders.csv
- raw_order_items.csv
- raw_order_payments.csv
- raw_products.csv
- raw_sellers.csv
- raw_customers.csv
- raw_geolocation.csv

---

### 2️⃣ Carga (Load)
Os arquivos CSV foram carregados no PostgreSQL como tabelas raw, preservando o esquema original dos dados.

Boas práticas aplicadas:
- Tipagem adequada de colunas
- Nenhuma regra de negócio aplicada nesta etapa
- Estrutura preparada para consumo pelo dbt

Resultado:
```text
- raw.raw_orders
- raw.raw_order_items
- raw.raw_order_payments
- raw.raw_products
- raw.raw_sellers
- raw.raw_customers
- raw.raw_geolocation
- raw.raw_reviwes
```

---

### 3️⃣ Transformação (Transform – dbt)
As transformações foram realizadas utilizando dbt, organizadas em três camadas principais:
- Camada Bronze
- Camada Silver
- Camada Gold

--- 

## Camada Bronze 🥉
**Objetivo:**
- Limpeza
- Padronização
- Renomeação de colunas
- Aplicação de testes básicos

**Características:**
- 1 modelo por tabela raw
- Nenhuma agregação
- Granularidade idêntica à fonte

**Exemplos:**
- raw_orders
- raw_order_items
- raw_order_payments
- raw_products
- raw_sellers

**Testes aplicados:**
- not_null
- unique
- relationships

---

## Camada Silver 🥈
**Objetivo:**
- Aplicar regras de negócio
- Realizar joins entre entidades
- Criar métricas base reutilizáveis

**Características:**
- Agregações controladas
- Métricas consolidadas
- Modelos reutilizáveis pelos marts

**Principais modelos:**
- Vendas por ano
- Vendas por ano-mês
- Vendas por categoria
- Vendas por cidade / estado
- Forma de pagamento
- Vendas acumuladas

Essa camada atua como **fundação analítica** do projeto.

---

## Camada Gold 🥇
**Objetivo:**
- Entregar dados prontos para análise
- Responder perguntas de negócio
- Servir BI, dashboards e stakeholders

**Características:**
- Modelos finais
- Linguagem de negócio
- Granularidade explícita

**Principais marts criados:**
- marts_forma_pgto
- marts_top10_categorias
- marts_top10_cidades
- marts_top10_estados
- marts_venda_ano
- marts_venda_ano_mes
- marts_venda_acumulada

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