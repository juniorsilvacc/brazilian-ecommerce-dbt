with source as (
    select * from {{ source('brazilian-ecommerce', 'raw_products') }}
),

renamed as (
    select
        cast(product_id as varchar) as product_id,

        lower(trim(product_category_name)) as category_name,

        cast(product_name_lenght as integer) as name_length,
        cast(product_description_lenght as integer) as description_length,
        cast(product_photos_qty as integer) as photos_count,

        cast(product_weight_g as numeric) as weight_g,
        cast(product_length_cm as numeric) as length_cm,
        cast(product_height_cm as numeric) as height_cm,
        cast(product_width_cm as numeric) as width_cm
    from source
)

select * from renamed