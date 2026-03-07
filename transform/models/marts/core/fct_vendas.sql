with pedidos_detalhados as (
    select * from {{ ref('int_pedidos_detalhados') }}
),

pagamentos as (
    select * from {{ ref('int_pagamentos_resumo') }}
),

reviews as (
    select * from {{ ref('int_reviews_pedidos') }}
)

select
    pd.pedido_id,
    pd.produto_id,
    pd.cliente_id,
    pd.vendedor_id,
    pd.pedido_criado_em,
    pd.status_pedido,
    -- Métricas de Valor
    pd.preco,
    pd.valor_frete,
    pd.valor_total_item,
    -- Métricas de Pagamento
    pg.metodo_pagamento_predominante,
    pg.valor_total_pago,
    pg.qtd_metodos_pagamento,
    pg.max_parcelas,
    -- Métricas de Satisfação
    rv.media_score_review
from pedidos_detalhados pd
left join pagamentos pg on pd.pedido_id = pg.pedido_id
left join reviews rv on pd.pedido_id = rv.pedido_id