with customers as (
    select * from {{ ref('stg_customers') }}
),

geo as (
    -- Agrupamos geo para evitar duplicatas (um CEP pode ter várias latitudes)
    select 
        cep,
        min(cidade) as cidade,
        min(estado) as estado
    from {{ ref('stg_geolocation') }}
    group by 1
),

final as (
    select
        c.cliente_id,
        c.cliente_unico_id,
        c.cep,
        coalesce(g.cidade, c.cidade) as cidade,
        coalesce(g.estado, c.estado) as estado
    from customers c
    left join geo g on c.cep = g.cep
)

select * from final