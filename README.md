# 📦 Brazilian E-Commerce Analytics Pipeline

Este projeto simula um ecossistema completo de Engenharia de Dados, desde a ingestão de dados brutos de um e-commerce até a disponibilização de modelos prontos para negócio (BI), utilizando as melhores práticas de Medallion Architecture.

# 📌 Sobre

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

<img width="1609" height="872" alt="Image" src="https://github.com/juniorsilvacc/brazilian-ecommerce-dbt/blob/master/arquitetura.png" />

1. Ingestão: Scripts Python extraem os dados e carregam no PostgreSQL (Landing Zone).
2. Orquestração: Apache Airflow gerencia a ordem de execução e falhas.
3. Transformação (ELT): O dbt assume o papel central, transformando dados brutos em tabelas dimensionais usando SQL.
4. Qualidade: Testes automatizados garantem que nenhum dado "sujo" chegue ao dashboard.

---

## 🛠️ Tecnologias Utilizadas
- **Orquestração:** Apache Airflow
- **Ingestão:** Python (Simulação de carga incremental/Batch).
- **Armazenamento (DW):** PostgreSQL
- **Transformação:** dbt (Data Build Tool) para modelagem SQL.
- **Qualidade de Dados:** dbt tests para garantir integridade.

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
- Extrai e Carregam os dados na camada Raw (Dados Brutos).
- Utilizam o dbt para limpar e transformar os dados na camada Staging (Tratada).
- Consolidam indicadores de performance (KPIs) na camada Marts (Modelada para Negócio).

---

## 🚀 Etapas do Projeto
### 1️⃣ Extração (Extract)
Os dados foram baixados diretamente do Kaggle em formato CSV e armazenados localmente.

**Arquivos utilizados:**
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

**Boas práticas aplicadas:**
- Tipagem adequada de colunas
- Nenhuma regra de negócio aplicada nesta etapa
- Estrutura preparada para consumo pelo dbt

**Resultado:**
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
As transformações foram realizadas utilizando dbt.

---

## 📐 Arquitetura organizada em três camadas principais:
- Camda Raw (dados brutos sem nenhuma alteração)
- Camada Staging (limpeza e padronização)
- Camada Marts (modelagem dimensional)

---

### Camada Raw 🟤
**Objetivo:**
- Dados crus
- Sem transformação de negócio
- Sem limpeza pesada
- Mesmo formato do arquivo original

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

## Camada Staging ⚪
**Objetivo:**
- Casting de tipos
- Rename de colunas
- Padronização de nomes
- Remoção de duplicatas
- Tratamento básico de nulos
- Aplicar regras de negócio
- Realizar joins entre entidades

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

Essa camada ainda não é modelo dimensional. Ela é dados limpos e organizados.

---

## Camada Marts 🟡
**Objetivo:**
- Entregar dados prontos para análise
- Responder perguntas de negócio
- Servir BI e dashboards

**Características:**
- Modelos finais
- Linguagem de negócio
- Granularidade explícita

**Principais marts criados:**
- fct_orders.sql
- fct_payments.sql
- fct_reviews.sql
- dim_customers.sql
- dim_products.sql
- dim_sellers.sql

**Ouro para o negócio.
Aqui aplicamos o Star Schema (Esquema Estrela):**
- Tabelas Fato (fct_): Registram os eventos quantitativos (Vendas, Pagamentos, Reviews).
- Tabelas Dimensão (dim_): Contêm os contextos (Produtos, Clientes, Vendedores).

**Principais KPIs Gerados:**
1. GMV: Faturamento bruto total.
2. Delivery Lead Time: Tempo médio entre compra e entrega.
3. NPS Simulado: Score de satisfação convertido em métricas binárias.
4. Mix de Pagamento: Distribuição entre Cartão, Boleto e Voucher.

---

## 🛡️ Cultura de Qualidade de Dados
Diferente de scripts SQL comuns, este projeto utiliza testes automatizados em cada etapa do dbt:
1. Unique: Garante que IDs não se repitam.
2. Not Null: Impede que métricas essenciais (como preço) fiquem vazias.
3. Relationships: Valida a integridade referencial (ex: não existe pagamento para um pedido inexistente).
4. Accepted Values: Garante que status de pedidos e regiões brasileiras estejam dentro do esperado.

--- 

## 🔧 Parte Técnica
1. Sources: Mapeaste os dados brutos.
2. Staging (Silver): Limpaste tipos de dados e padronizaste strings.
3. Marts (Gold): Criaste a lógica de negócio (Traduções, KPIs de tempo de entrega, Consolidação financeira).
4. Tests: Implementaste testes de unicidade, nulidade e integridade referencial.
5. Docs: Criaste uma homepage e documentaste cada coluna.

---

## 📂 Estrutura do Projeto
```text
brazilian-ecommerce-pipeline-dbt/
├── airflow/                   # Configurações do Orquestrador
│   ├── dags/                  # Suas DAGs que chamam o dbt e o Python
├── dbt_transform/             # Projeto de Transformação SQL utilizando dbt
│   ├── models/
│   │   ├── staging/           # Limpeza e padronização (Silver)
│   │   └── marts/             # Modelagem Dimensional (Gold)
│   └── dbt_project.yml
├── src/                       # CÓDIGO FONTE CUSTOMIZADO
│   ├── ingestion/             
│   │   └── data_generator.py  # Script do Kaggle
│   └── utils/                 
│       └── db_helpers.py      # Funções de conexão, logs, etc.
├── data/                      # Landing Zone (Ignorada no .gitignore)
│   ├── landing/               # Datasets baixandos do Kaggle
│   └── raw/                   # Parquets
├── .env                       # Configuração de Ambientes
├── .gitignore
├── README.md
└── requirements.txt
```

## 🚀 Instalação e Configuração
### 1️⃣ Clone o repositório:
```bash
# 1. Clone o repositório:
git clone https://github.com/juniorsilvacc/brazilian-ecommerce-dbt.git
```

### 2️⃣ Obtenha sua API Kaggle
1. Acesse APIs Nasa: [Kaggle](https://www.kaggle.com/) 
2. Crie uma conta gratuita
3. Gere sua API Key 

### 3️⃣Configure as variáveis no .env
```bash
# Variáveis para o banco de dados do Airflow (Interno)
DB_HOST=postgres
DB_USER=airflow
DB_PASSWORD=airflow
DB_NAME=brazilian_ecommerce_db
DB_PORT=5432

# Variáveis do Airflow
AIRFLOW_UID=501
_AIRFLOW_WWW_USER_USERNAME=airflow
_AIRFLOW_WWW_USER_PASSWORD=airflow

# KEY KAGGLE
KAGGLE_API_TOKEN=
```

### 4️⃣ Execução Automática (Via Ambiente Airflow)
```bash
# Crie a estrutura de pastas necessária
mkdir -p ./dags ./logs ./plugins ./config ./data ./src ./notebooks
```

### 5️⃣ Centralizar o profiles.yml
Para garantir que o Airflow e o dbt encontrem as configurações de conexão sem depender de pastas ocultas do sistema operacional (~/.dbt/), mantenha o arquivo na raiz do projeto dbt.
```bash
# Copia o profiles.yml global para a pasta local do projeto
cp ~/.dbt/profiles.yml ~/brazilian-ecommerce-dbt/transform/profiles.yml
```

### 6️⃣ Inicie os Containers Docker
```bash
# Construir as imagens
docker-compose build

# Executar todos os serviços(containers)
docker-compose up -d
```

--- 

## ▶️ Como Executar o Airflow
### 1️⃣ Acesse a Interface do Airflow
Abra seu navegador em: http://localhost:8080

### Credenciais padrão:
```text
Username: airflow
Password: airflow
```

### 2️⃣ Ative a DAG
1. Na interface do Airflow, localize a DAG brazilian-ecommerce-dbt
2. Clique no botão de Acionar/Trigger para ativá-la
3. A DAG está configurada para executar todos os dias às 8:00 AM

--- 

## ▶️ Execução Manual / Debug (Via Terminal)
Caso precise rodar apenas as transformações do dbt ou gerar documentação sem disparar o Airflow, utilize os comandos abaixo de dentro do container do Airflow Worker:
### 1️⃣ Entrar no ambiente do dbt:
```bash
# Entra no container
docker exec -it airflow-worker bash

# Ir para a pasta do projeto
cd /opt/airflow/transform
```

### 2️⃣ Rodar o Pipeline de Transformação
O comando build executa os modelos, roda os testes e aplica os snapshots em uma única operação.
```bash
# Rodar o build. Definido no profiles.yml
dbt build --profile transform --profiles-dir .
```

### 3️⃣ Gerar e Visualizar Documentação
O dbt gera um site estático com a linhagem dos dados (Lineage Graph) e dicionário de dados.
```bash
# Gera a documentação
dbt docs generate --profile transform --profiles-dir .

# Visualização (abre um servidor na porta 8081 do container)
dbt docs serve --profile transform --profiles-dir . --port 8001
```

---

### 👷 Autor
[Linkedin](https://www.linkedin.com/in/juniiorsilvadev/) 
