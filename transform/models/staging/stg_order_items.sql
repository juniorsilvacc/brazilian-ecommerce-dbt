with source as (
    select * from {{ source('brazilian-ecommerce', 'raw_order_items') }}
),

renamed as (
    select
        cast(order_id as varchar) as order_id,
        cast(order_item_id as integer) as order_item_id,
        cast(product_id as varchar) as product_id,
        cast(seller_id as varchar) as seller_id,

        cast(shipping_limit_date as timestamp) as shipping_limit_at,

        cast(price as numeric(10, 2)) as price,
        cast(freight_value as numeric(10, 2)) as freight_value,

        cast((price + freight_value) as numeric(10,2)) as total_item_value
    from source 
)

select * from renamed