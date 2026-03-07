with ranking_produtos as (
    select
        produto_id,
        sum(valor_total_item) as receita_total,
        sum(sum(valor_total_item)) over() as receita_global
    from {{ ref('fct_vendas') }}
    group by 1
),

calculo_percentual as (
    select
        produto_id,
        receita_total,
        -- Percentual acumulado para Curva ABC
        sum(receita_total) over(order by receita_total desc) / receita_global as pct_acumulado
    from ranking_produtos
)

select
    produto_id,
    receita_total,
    case 
        when pct_acumulado <= 0.8 then 'A'
        when pct_acumulado <= 0.95 then 'B'
        else 'C'
    end as classe_abc
from calculo_percentual