# 📦 Brazilian E-Commerce Analytics Pipeline

Este projeto simula um ecossistema completo de Engenharia de Dados, desde a ingestão de dados brutos de um e-commerce até a disponibilização de modelos prontos para negócio (BI), utilizando as melhores práticas de Medallion Architecture.

# 📌 Sobre

A base de dados utilizada é o Brazilian E-Commerce Public Dataset by Olist, disponibilizado publicamente no Kaggle:
- **Fonte**: Kaggle – Brazilian E-Commerce Public Dataset by Olist
- **Período**: 2016 a 2018
- **Volume**: ~100 mil pedidos
- **Domínio**: Marketplace / E-commerce

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

1. **Ingestão**: Scripts Python extraem os dados e carregam no PostgreSQL (Landing Zone).
2. **Orquestração**: Apache Airflow gerencia a ordem de execução e falhas.
3. **Transformação (ELT)**: O dbt assume o papel central, transformando dados brutos em tabelas dimensionais usando SQL.
4. **Qualidade**: Testes automatizados garantem que nenhum dado "sujo" chegue ao dashboard.

---

## 🛠️ Tecnologias Utilizadas
- **Orquestração:** Apache Airflow
- **Ingestão:** Python (Simulação de carga incremental/Batch).
- **Armazenamento (DW):** PostgreSQL
- **Transformação:** dbt (Data Build Tool) para modelagem SQL.
- **Qualidade de Dados:** dbt tests para garantir integridade.

---

## 📊 Estrutura dos Dados
**O projeto processa informações de:**
- Pedidos e itens de pedidos.
- Pagamentos e avaliações de clientes.
- Geolocalização e logística de entrega.
- Performance de vendedores por categoria.

---

## 🎯 O Diferencial deste Projeto
**Diferente de uma análise estática, este pipeline simula uma extração programática. Em vez de carregar um CSV manualmente, o Airflow gerencia tarefas que:**
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

## 🗃️ Camada de Transformações dos Dados
- **Camada Staging (limpeza e padronização)**:
  - Responsável por espelhar os dados brutos, aplicando renomeação de colunas, tipagem correta (casting) e tratamentos básicos de nulos. 

- **Camada Intermediate (Transformação e Lógica de Negócio)**:
  - Onde ocorre o cruzamento de entidades e a aplicação de regras complexas. É a fundação modular que evita a repetição de lógica nos modelos finais.

- **Camada Marts (modelagem dimensional)**:
  - A camada de entrega final organizada em tabelas de Fato e Dimensão. Projetada para alta performance em ferramentas de BI e clareza para os usuários de negócio.

---

## Camada Staging 🟤
**Objetivo**: Limpeza técnica e padronização. É o primeiro contato com os dados brutos.

- **Transformações**:
  - **Casting**: Conversão de strings para `DATE`, `TIMESTAMP` ou `NUMERIC`.
  - **Renaming**: Tradução de colunas (ex: de `customer_state` para `state`) para uma linguagem ubíqua.
  - **Sanitização**: `TRIM()` em strings e tratamento básico de nulos.

- **Características**:
  - **Relação 1:1**: Um modelo para cada tabela da fonte (`raw`).
  - **Sem Joins**: Não realizamos uniões entre tabelas nesta camada.
  - **Granularidade**: Idêntica à fonte original.
  - **Materialização**: Preferencialmente `view`.

---

## Camada Intermediate ⚪
**Objetivo:** Onde a mágica acontece. Aqui construímos a lógica de negócio que será reaproveitada em múltiplos Marts.

- **Transformações**:
  - **Joins Complexos**: União de entidades (ex: `orders` + `order_items`).
  - **Regras de Negócio**: Filtros específicos (ex: remover pedidos cancelados).
  - **Agregações de Base**: Cálculos que servem de alicerce (ex: `total_item_price`).

- **Características**:
  - **Modelos Efêmeros**: Frequentemente não são expostos ao BI (podem ser `ephemeral`).
  - **Modularidade**: Evita a repetição de código (DRY - Don't Repeat Yourself).

- **Modelos**:
  - `int_clientes_localizacao`
  - `int_pagamentos_pivoteados`
  - `int_pagamentos_resumo`
  - `int_pedidos_detalhados`
  - `int_reviews_pedidos`
  - `int_vendedores_desempenho`

---

## Camada Marts 🟡
**Objetivo:** Entrega de valor. Dados prontos para consumo por ferramentas de BI.

- **Estrutura (Star Schema)**:
  - **Dimensões (`dim_`)**: Entidades do negócio (Quem? O quê? Onde?). Contêm dados descritivos.
  - **Fatos (`fct_`)**: Eventos quantificáveis (Quanto? Quando?). Contêm métricas e chaves estrangeiras.

- **Características**:
  - **Linguagem de Negócio**: Nomes de colunas totalmente intuitivos para analistas.
  - **Performance**: Geralmente materializados como `table` ou `incremental` para rapidez na leitura.
  - **Granularidade**: Nível de granularidade explícita.
  
- **Star Schema (Esquema Estrela)**:
  - **Tabelas Fato (fct_)**: Registram os eventos quantitativos `fct_vendas`.
  - **Tabelas Dimensão (dim_)**: Contêm os contextos `dim_clientes`, `dim_produtos`.

### Principais KPIs Gerados
1. **GMV**: Faturamento bruto total.
2. **Delivery Lead Time**: Tempo médio entre compra e entrega.
3. **NPS Simulado**: Score de satisfação convertido em métricas binárias.
4. **Mix de Pagamento**: Distribuição entre Cartão, Boleto e Voucher.

---

## 🛡️ Cultura de Qualidade de Dados
**Diferente de scripts SQL comuns, este projeto utiliza testes automatizados em cada etapa do dbt**:
1. **Unique**: Garante que IDs não se repitam.
2. **Not Null**: Impede que métricas essenciais (como preço) fiquem vazias.
3. **Relationships**: Valida a integridade referencial (ex: não existe pagamento para um pedido inexistente).
4. **Accepted Values**: Garante que status de pedidos e regiões brasileiras estejam dentro do esperado.

--- 

## 🔧 Parte Técnica
1. **Sources**: Mapeaste os dados brutos.
2. **Staging (Silver)**: Limpaste tipos de dados e padronizaste strings.
3. **Marts (Gold)**: Criaste a lógica de negócio (Traduções, KPIs de tempo de entrega, Consolidação financeira).
4. **Tests**: Implementaste testes de unicidade, nulidade e integridade referencial.
5. **Docs**: Criaste uma homepage e documentaste cada coluna.

---

## 📂 Estrutura de Domínios (Marts)
| Pasta            | O que representa?                                                                    | Exemplos de Modelos que você criou           |
|------------------|--------------------------------------------------------------------------------------|----------------------------------------------|
| `core/`          | Tabelas base (Dimensões e Fatos centrais) que servem para todos os outros domínios.  | `dim_clientes`, `dim_produtos`, `fct_vendas` |
| `finance/`       | Métricas de dinheiro, pagamentos, faturamento e perdas.                              | `mart_analise_pagamentos_status`, `mart_parcelamento_categoria` |
| `logistics/`     | Tudo sobre o fluxo do produto: prazos, fretes e entregas.                            | `mart_performance_entrega`, `mart_relacao_frete_review` |
| `marketing/`     | Comportamento do cliente, retenção, CAC e segmentação.	                              | `mart_recorrencia_clientes`, `mart_faturamento_estados` |
| `product/`       | Performance de catálogo, estoque e popularidade.                                     | `mart_curva_abc_produtos` |

**Por que dividir assim?**
1. **Organização Mental**: Fica claro onde criar um novo modelo. Se for sobre "satisfação do cliente", vai para marketing ou core (se for uma métrica muito básica).
2. **Permissões (Governança)**: No futuro, se você usar um Data Warehouse grande (como BigQuery ou Snowflake), você pode dar permissão para o time de Finanças ver apenas a pasta finance, protegendo dados sensíveis.
3. **Documentação Limpa**: No dbt docs, os modelos aparecerão agrupados por essas pastas, o que torna a navegação intuitiva para quem não é técnico.

---

## 📂 Estrutura do Projeto
```text
brazilian-ecommerce-pipeline-dbt/
├── airflow/                    # Configurações do Orquestrador
│   ├── dags/                   # Suas DAGs (ex: dag_olist_pipeline.py)
│   ├── plugins/                # Operadores customizados se houver
│   └── logs/                   # Logs do Airflow
├── dbt_transform/              # Projeto dbt (Transformação SQL)
│   ├── models/                 # PASTA OBRIGATÓRIA PARA MODELOS
│   │   ├── staging/            # Limpeza inicial (Cast, Rename)
│   │   ├── intermediate/       # Joins e Agregações Complexas
│   │   └── marts/              # Camada Final de Negócio
│   │       ├── core/           # Fatos e Dimensões (fct_vendas, dim_produtos)
│   │       ├── finance/        # analise_pagamentos_status.sql
│   │       ├── marketing/      # categoria_produto_vendido.sql, recorrencia_clientes.sql
│   │       ├── logistics/      # estados_faturamento.sql, performance_entrega.sql
│   │       └── product/        # curva_abc_produtos.sql
│   ├── tests/                  # Testes customizados (.sql)
│   ├── macros/                 # Macros Jinja reutilizáveis
│   ├── target/                 # Arquivos compilados (ignorar no git)
│   ├── dbt_project.yml         # Configuração mestre do dbt
│   └── packages.yml            # Pacotes externos (ex: dbt_utils)
├── src/                        # CÓDIGO FONTE CUSTOMIZADO (Python)
│   ├── ingestion/             
│   │   └── data_generator.py   # Script do Kaggle / Extração
│   └── utils/                 
│       └── db_helpers.py       # Conexões e Logs
├── data/                       # Landing Zone (Ignorada no .gitignore)
│   ├── landing/                # CSVs brutos do Kaggle
│   └── raw/                    # Arquivos convertidos (Parquet)
├── .env                        # Variáveis de ambiente (DB_USER, DB_PASS)
├── .gitignore                  # IMPORTANTE: ignorar /data, /target e .env
├── README.md
└── requirements.txt            # dbt-postgres, pandas, apache-airflow, etc.
```

## 🚀 Instalação e Configuração
### 1️⃣ Clone o repositório:
```bash
# 1. Clone o repositório:
git clone https://github.com/juniorsilvacc/brazilian-ecommerce-dbt.git
```

### 2️⃣ Obtenha sua API Kaggle
1. Acesse APIs Kaggle: [Kaggle](https://www.kaggle.com/) 
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
Caso precise rodar apenas as transformações do dbt ou gerar documentação sem disparar o Airflow, utilize os comandos:
### 1️⃣ Entrar no ambiente do dbt:
```bash
# Ir para a pasta do projeto
cd /brazilian-ecommerce-dbt/transform
```

### 2️⃣ Rodar o Pipeline de Transformação
O comando build executa os modelos, roda os testes e aplica os snapshots em uma única operação.
```bash
# Execute para a instalação das dependências
dbt deps

# Execução do build. Combina em uma única etapa a compilação executando (modelos, testes, snapshots e seeds)
dbt build

# Executa apenas o modelos
dbt run

# Executa o domínio/modelo específico
dbt run --select marts
```

### 3️⃣ Gerar e Visualizar Documentação
O dbt gera um site estático com a linhagem dos dados (Lineage Graph) e dicionário de dados.
```bash
# Gera a documentação. Compila o projeto e gera os arquivos JSON da doc
dbt docs generate

# Visualização. Inicia o servidor na porta 8001
dbt docs serve --port 8001
```

---

### 👷 Autor
[Linkedin](https://www.linkedin.com/in/juniiorsilvadev/) 
