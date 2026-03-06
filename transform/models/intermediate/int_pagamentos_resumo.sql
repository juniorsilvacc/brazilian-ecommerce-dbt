select
    pedido_id,
    sum(valor_pagamento) as valor_total_pago,
    count(pagamento_sequencial) as qtd_metodos_pagamento,
    max(numero_parcelas) as max_parcelas
from {{ ref('stg_order_payments') }}
group by 1