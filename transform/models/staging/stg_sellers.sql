with source as (
    select * from {{ source('brazilian-ecommerce', 'raw_sellers') }}
),

renamed as (
    select
        cast(seller_id as varchar) as vendedor_id, 
        cast(seller_zip_code_prefix as varchar) as cep,

        upper(trim(seller_city)) as cidade,
        upper(trim(seller_state)) as estado
    from source
)

select * from renamed