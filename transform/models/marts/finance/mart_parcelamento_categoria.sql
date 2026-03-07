--- Qual categoria de produto vende mais parcelado?

with vendas as (
    select * from {{ ref('fct_vendas') }}
),

produtos as (
    select * from {{ ref('dim_produtos') }}
)

select 
    p.categoria_nome,

    -- Métrica de parcelamento
    avg(v.max_parcelas) as media_parcelas,
    
    -- Métricas de volume para dar contexto
    count(distinct v.pedido_id) as qtd_pedidos,
    sum(v.valor_total_item) as faturamento_total
from vendas v
join produtos p on v.produto_id = p.produto_id
group by 1
order by 2 desc