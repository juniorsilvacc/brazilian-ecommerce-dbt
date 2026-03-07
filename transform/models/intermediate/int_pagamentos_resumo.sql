with ranking_pagamentos as (
    select 
        pedido_id,
        tipo_pagamento,
        valor_pagamento,
        numero_parcelas,
        pagamento_sequencial,
        -- Ranqueia o método que pagou o maior valor no pedido
        row_number() over (
            partition by pedido_id 
            order by valor_pagamento desc
        ) as ranking
    from {{ ref('stg_order_payments') }}
),

agregado_por_pedido as (
    -- Aqui pegamos as somas totais do pedido antes de filtrar o ranking
    select
        pedido_id,
        sum(valor_pagamento) as valor_total_pago,
        count(pagamento_sequencial) as qtd_metodos_pagamento,
        max(numero_parcelas) as max_parcelas
    from {{ ref('stg_order_payments') }}
    group by 1
)

select
    agg.pedido_id,
    agg.valor_total_pago,
    agg.qtd_metodos_pagamento,
    agg.max_parcelas,
    -- Tradução apenas do método "vencedor"
    case 
        when r.tipo_pagamento = 'credit_card' then 'Cartão de Crédito'
        when r.tipo_pagamento = 'boleto' then 'Boleto'
        when r.tipo_pagamento = 'voucher' then 'Vale/Cupom'
        when r.tipo_pagamento = 'debit_card' then 'Cartão de Débito'
        else 'Outros'
    end as metodo_pagamento_predominante
from agregado_por_pedido agg
join ranking_pagamentos r on agg.pedido_id = r.pedido_id
where r.ranking = 1 -- Garante que só teremos o método principal