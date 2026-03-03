with source as (
    select * from {{ source('brazilian-ecommerce', 'raw_customers') }}
),

renamed as (
    select
        distinct
        
        cast(customer_id as varchar) as customer_id,
        cast(customer_unique_id as varchar) as customer_unique_id,

        cast(customer_zip_code_prefix as varchar) as zip_code,
   
        upper(trim(customer_city)) as city,
        upper(trim(customer_state)) as state,

        case 
            when customer_state in ('SP', 'RJ', 'MG', 'ES') then 'Sudeste'
            when customer_state in ('PR', 'SC', 'RS') then 'Sul'
            when customer_state in ('MT', 'MS', 'GO', 'DF') then 'Centro-Oeste'
            when customer_state in ('BA', 'PE', 'CE', 'RN', 'PB', 'AL', 'SE', 'MA', 'PI') then 'Nordeste'
            else 'Norte'
        end as region
    from source
)

select * from renamed
where customer_id is not null