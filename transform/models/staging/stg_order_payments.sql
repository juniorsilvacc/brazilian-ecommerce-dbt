with source as (
    select * from {{ source('brazilian-ecommerce', 'raw_order_payments') }}
),

renamed as (
    select
        cast(order_id as varchar) as order_id,
        cast(payment_sequential as integer) as payment_sequential,
        lower(trim(payment_type)) as payment_type,
        cast(payment_installments as integer) as installments_count,
        cast(payment_value as numeric(10, 2)) as payment_value
    from source
)

select * from renamed