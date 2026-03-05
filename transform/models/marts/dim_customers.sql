with customers as (
    select * from {{ ref('stg_customers') }}
),

final as (
    select
        customer_id,
        city as customer_city,
        state as customer_state,
        case 
            when state in ('SP', 'RJ', 'MG', 'ES') then 'Sudeste'
            when state in ('PR', 'SC', 'RS') then 'Sul'
            when state in ('MT', 'MS', 'GO', 'DF') then 'Centro-Oeste'
            when state in ('BA', 'PE', 'CE', 'RN', 'PB', 'AL', 'SE', 'MA', 'PI') then 'Nordeste'
            else 'Norte'
        end as customer_region
    from customers
)

select * from final