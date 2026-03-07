with fct_vendas_por_pedido as (
    select
        pedido_id,
        max(vendedor_id) as vendedor_id,
        status_pedido
    from {{ ref('fct_vendas') }}
    group by 1, 3
),

orders as (
    select * from {{ ref('stg_orders') }}
)

select
    v.vendedor_id,
    v.pedido_id,
    v.status_pedido,
    o.pedido_aprovado_em,
    o.pedido_criado_em as data_postagem,
    o.entregue_cliente_em as data_entrega_real,
    o.entrega_estimada_em as data_entrega_prometida,
    
    -- Cálculo de dias de atraso
    date_part('day', o.entregue_cliente_em - o.entrega_estimada_em) as dias_atraso,
    
    -- Flag de Status de Entrega
    case 
        when o.entregue_cliente_em is null then 'Em Trânsito / Pendente'
        when o.entregue_cliente_em <= o.entrega_estimada_em then 'No Prazo'
        else 'Atrasado'
    end as status_entrega
    
from fct_vendas v
join orders o on v.pedido_id = o.pedido_id