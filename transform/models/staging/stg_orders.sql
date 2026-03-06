with source as (
    select * from {{ source('brazilian-ecommerce', 'raw_orders') }}
),

renamed as (
    select 
       cast(order_id as varchar) as pedido_id,
       cast(customer_id as varchar) as cliente_id,

       lower(trim(order_status)) as status_pedido,

        cast(order_purchase_timestamp as timestamp) as pedido_criado_em,
        cast(order_approved_at as timestamp) as pedido_aprovado_em,
        cast(order_delivered_carrier_date as timestamp) as entregue_transportadora_em,
        cast(order_delivered_customer_date as timestamp) as entregue_cliente_em,
        cast(order_estimated_delivery_date as timestamp) as entrega_estimada_em
    from source
)

select * from renamed