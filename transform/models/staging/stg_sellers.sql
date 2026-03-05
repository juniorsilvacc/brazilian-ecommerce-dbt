with source as (
    select * from {{ source('brazilian-ecommerce', 'raw_sellers') }}
),

renamed as (
    select
        cast(seller_id as varchar) as seller_id, 
        cast(seller_zip_code_prefix as varchar) as zip_code,

        upper(trim(seller_city)) as city,
        upper(trim(seller_state)) as state
    from source
)

select * from renamed