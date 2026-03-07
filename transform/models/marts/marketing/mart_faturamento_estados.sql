--- Quais estados geram mais faturamento?

select 
    c.cliente_estado, 
    sum(v.valor_total_item) as faturamento_total
from {{ ref('fct_vendas') }} v
join {{ ref('dim_clientes') }} c on v.cliente_id = c.cliente_id
group by 1
order by 2 desc