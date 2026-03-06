with payments as (
    select * from {{ ref('stg_order_payments') }}
),

-- Muitas vezes um pedido tem mais de uma forma de pagamento (ex: metade no cartão, metade no boleto). Esta tabela consolida isso por pedido.

final as (
    select
        pedido_id,
        
        -- Criando colunas específicas para cada método (Pivoting)
        sum(case when tipo_pagamento = 'credit_card' then valor_pagamento else 0 end) as valor_cartao_credito,
        sum(case when tipo_pagamento = 'boleto' then valor_pagamento else 0 end) as valor_boleto,
        sum(case when tipo_pagamento = 'voucher' then valor_pagamento else 0 end) as valor_voucher,
        sum(case when tipo_pagamento = 'debit_card' then valor_pagamento else 0 end) as valor_cartao_debito,

        -- Métricas agregadas do pedido
        sum(valor_pagamento) as valor_total_pedido,
        max(numero_parcelas) as total_parcelas
    from payments
    group by 1
)

select * from final