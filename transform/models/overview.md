{% docs __overview__ %}

# 📊 Projeto Brazilian E-commerce - Data Engineer

Bem-vindo à documentação do pipeline de dados da **Olist**. Este projeto utiliza a metodologia **Medallion Architecture** para transformar dados brutos de e-commerce em insights estratégicos para as áreas de negócio.

### 🏗️ Arquitetura do Projeto
O projeto implementa a **Medallion Architecture** para garantir a rastreabilidade e a qualidade do dado em cada estágio:

1.  **Staging (Bronze):** Camada de limpeza técnica. Padronização de nomes (snake_case), tratamento de nulos e conversão de tipos (dates, timestamps e floats).
2.  **Intermediate (Silver):** Camada de integração. Onde aplicamos os `JOINs` complexos entre pedidos, itens, pagamentos e clientes, consolidando as métricas base (ex: valor total do item, frete acumulado).
3.  **Marts (Gold):** Camada de negócio (Self-Service BI), organizada por domínios:
    * **Core:** Tabelas fundamentais como `fct_vendas` (grão de item) e dimensões de `clientes` e `produtos`.
    * **Finance:** KPIs de faturamento, perdas por cancelamento e comportamento de parcelamento.
    * **Logistics:** KPIs de SLA (Service Level Agreement), dias de atraso e correlação frete-satisfação.
    * **Marketing:** Visão de CRM com **LTV (Lifetime Value)** e segmentação de **Recorrência**.

### 🛠️ Stack Tecnológica
* **Data Warehouse:** PostgreSQL / Snowflake.
* **Transformação:** dbt (data build tool) 1.11+.
* **Linguagem:** SQL (Common Table Expressions - CTEs).
* **Qualidade:** dbt-tests & dbt-utils

### 🚀 Inteligência de Negócio & Dashboards
Os modelos foram desenhados para responder perguntas críticas:
* **Curva ABC:** Quais são os produtos "Classe A" que sustentam 80% da receita?
* **Análise de Atrasos:** Como o tempo de entrega real vs. prometido impacta as reviews dos clientes?
* **Fidelização:** Qual o intervalo médio de dias entre compras de clientes recorrentes?

### ✅ Garantia de Qualidade (Data Quality)
"Este projeto implementa mais de **+50 testes automatizados**, garantindo que:
-   **Integridade Referencial:** Garante que toda venda possua um cliente e produto válido.
-   **Unicidade:** Testes de PK (Primary Key) em todas as dimensões e tabelas de Marts.
-   **Regras de Negócio:** Validação de `accepted_values` para status de pedidos e classes ABC.
-   **Sanidade Financeira:** Bloqueio de valores de frete ou itens negativos.

---

**Mantenedor:** Junior Silva - Data Engineer
**Linkedin:** [Linkedin](https://www.linkedin.com/in/juniiorsilvadev/)
**Linkedin:** [Github](https://github.com/juniorsilvacc)
**Última Atualização:** 2026-03-07

{% enddocs %}