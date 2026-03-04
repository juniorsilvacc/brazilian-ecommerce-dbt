with source as (
    select * from {{ source('brazilian-ecommerce', 'raw_geolocation') }}
),

renamed as (
    select
        cast(geolocation_zip_code_prefix as varchar) as zip_code,

        cast(geolocation_lat as numeric) as latitude,
        cast(geolocation_lng as numeric) as longitude, 

        upper(trim(geolocation_city)) as city,
        upper(trim(geolocation_state)) as state
    from source
),

deduplicated as (
    select 
        zip_code,
        city,
        state,
        avg(latitude) as latitude,
        avg(longitude) as longitude
    from renamed
    group by 1, 2, 3
)

select * from deduplicated
