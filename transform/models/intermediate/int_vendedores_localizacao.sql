-- Une vendedores com sua localização

with sellers as (
    select * from {{ ref('stg_sellers') }}
),

geo as (
    select 
        cep, 
        min(cidade) as cidade, 
        min(estado) as estado
    from {{ ref('stg_geolocation') }} 
        group by 1
),

final as (
    select
        s.vendedor_id,
        s.cep,
        coalesce(g.cidade, s.cidade) as cidade,
        coalesce(g.estado, s.estado) as estado
    from sellers s
    left join geo g on s.cep = g.cep
)

select * from final