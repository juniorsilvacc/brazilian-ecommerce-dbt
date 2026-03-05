with payments as (
    select * from {{ ref('stg_order_payments') }}
),

final as (
    select
        order_id,
        payment_sequential, -- Caso o cliente use mais de um cartão
        
        -- Padronização dos nomes para o BI
        case 
            when payment_type = 'credit_card' then 'Cartão de Crédito'
            when payment_type = 'boleto' then 'Boleto'
            when payment_type = 'voucher' then 'Cupom/Vale'
            when payment_type = 'debit_card' then 'Cartão de Débito'
            else 'Outros'
        end as payment_method,

        installments_count as installments, -- Número de parcelas
        payment_value as amount
        
    from payments
)

select * from final