with orders as (
    select * from {{ ref('stg_orders') }}
),
items as (
    select * from {{ ref('stg_order_items') }}
),
products as (
    select * from {{ ref('stg_products') }}
),

--- Une os itens dos pedidos com informações de produtos e vendedores

final as (
    select
        items.pedido_id,
        items.produto_id,
        orders.cliente_id,
        orders.status_pedido,
        orders.pedido_criado_em,
        items.preco,
        items.valor_frete,
        items.valor_total_item,
        items.vendedor_id,
        products.categoria_nome
    from items
    left join orders on items.pedido_id = orders.pedido_id
    left join products on items.produto_id = products.produto_id
)

select * from final