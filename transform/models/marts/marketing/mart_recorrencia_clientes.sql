with vendas_cliente as (
    select
        c.cliente_unico_id,
        count(distinct v.pedido_id) as total_pedidos,
        min(v.pedido_criado_em) as primeira_compra,
        max(v.pedido_criado_em) as ultima_compra,
        sum(v.valor_total_item) as lifetime_value
    from {{ ref('fct_vendas') }} v
    join {{ ref('dim_clientes') }} c on v.cliente_id = c.cliente_id
    group by 1
)

select
    *,
    case 
        when total_pedidos > 1 then 'Cliente Recorrente'
        else 'Cliente Único'
    end as perfil_cliente,

    date_part('day', ultima_compra - primeira_compra) as dias_entre_compras
from vendas_cliente