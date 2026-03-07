select
    v.status_pedido,
    v.metodo_pagamento_predominante,
    
    -- Métricas Agregadas
    count(distinct v.pedido_id) as qtd_pedidos,
    sum(v.valor_total_item) as valor_bruto,

    -- Verificando perda por cancelamento
    sum(case when v.status_pedido = 'canceled' then v.valor_total_item else 0 end) as valor_cancelado
from {{ ref('fct_vendas') }} v
group by 1, 2