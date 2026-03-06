with source as (
    select * from {{ source('brazilian-ecommerce', 'raw_order_items') }}
),

renamed as (
    select
        cast(order_id as varchar) as pedido_id,
        cast(order_item_id as integer) as pedido_item_id,
        cast(product_id as varchar) as produto_id,
        cast(seller_id as varchar) as vendedor_id,

        cast(shipping_limit_date as timestamp) as limite_envio_em,

        cast(price as numeric(10, 2)) as preco,
        cast(freight_value as numeric(10, 2)) as valor_frete,

        cast((price + freight_value) as numeric(10,2)) as valor_total_item
    from source 
)

select * from renamed