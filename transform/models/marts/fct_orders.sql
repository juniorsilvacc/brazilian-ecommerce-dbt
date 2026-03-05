with orders as (
    select * from {{ ref('stg_orders') }}
),

order_items as (
    -- Agregar os itens para ter o valor total por pedido
    select 
        order_id,
        sum(price) as total_item_value,
        sum(freight_value) as freight_value,
        count(order_item_id) as items_count
    from {{ ref('stg_order_items') }}
    group by 1
),

final as (
    select
        o.order_id,
        o.customer_id,
        o.order_status,
        o.purchased_at,

        oi.total_item_value,
        oi.freight_value,
        (oi.total_item_value + oi.freight_value) as total_order_amount, -- Receita Bruta
        oi.items_count,
        
        -- Calcula o tempo de entrega em dias
        extract(day from (o.delivered_customer_at - o.purchased_at)) as delivery_lead_time_days
    from orders o
    inner join order_items oi on o.order_id = oi.order_id
)

select * from final