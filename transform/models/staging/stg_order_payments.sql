with source as (
    select * from {{ source('brazilian-ecommerce', 'raw_order_payments') }}
),

renamed as (
    select
        cast(order_id as varchar) as pedido_id,
        cast(payment_sequential as integer) as pagamento_sequencial,
        lower(trim(payment_type)) as tipo_pagamento,
        cast(payment_installments as integer) as numero_parcelas,
        cast(payment_value as numeric(10, 2)) as valor_pagamento
    from source
)

select * from renamed