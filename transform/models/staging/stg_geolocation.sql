with source as (
    select * from {{ source('brazilian-ecommerce', 'raw_geolocation') }}
),

renamed as (
    select
        cast(geolocation_zip_code_prefix as varchar) as cep,

        cast(geolocation_lat as numeric) as latitude,
        cast(geolocation_lng as numeric) as longitude, 

        upper(trim(geolocation_city)) as cidade,
        upper(trim(geolocation_state)) as estado
    from source
),

deduplicated as (
    select 
        cep,
        cidade,
        estado,
        avg(latitude) as latitude,
        avg(longitude) as longitude
    from renamed
    group by 1, 2, 3
)

select * from deduplicated
