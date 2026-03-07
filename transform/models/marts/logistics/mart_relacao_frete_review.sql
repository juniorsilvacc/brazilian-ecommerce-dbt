--- Existe relação entre o valor do frete e a nota da review?

select 
    media_score_review,
    avg(valor_frete) as frete_medio
from {{ ref('fct_vendas') }}
group by 1
order by 1 desc