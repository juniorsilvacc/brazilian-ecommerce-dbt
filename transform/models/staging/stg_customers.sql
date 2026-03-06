with source as (
    select * from {{ source('brazilian-ecommerce', 'raw_customers') }}
),

renamed as (
    select
        distinct
        
        cast(customer_id as varchar) as cliente_id,
        cast(customer_unique_id as varchar) as cliente_unico_id,

        cast(customer_zip_code_prefix as varchar) as cep,
   
        upper(trim(customer_city)) as cidade,
        upper(trim(customer_state)) as estado,

        case 
            when customer_state in ('SP', 'RJ', 'MG', 'ES') then 'Sudeste'
            when customer_state in ('PR', 'SC', 'RS') then 'Sul'
            when customer_state in ('MT', 'MS', 'GO', 'DF') then 'Centro-Oeste'
            when customer_state in ('BA', 'PE', 'CE', 'RN', 'PB', 'AL', 'SE', 'MA', 'PI') then 'Nordeste'
            else 'Norte'
        end as regiao
    from source
)

select * from renamed
where cliente_id is not null