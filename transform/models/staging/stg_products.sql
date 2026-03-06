with source as (
    select * from {{ source('brazilian-ecommerce', 'raw_products') }}
),

renamed as (
    select
        cast(product_id as varchar) as produto_id,

        lower(trim(product_category_name)) as categoria_nome,

        cast(product_name_lenght as integer) as nome_comprimento,
        cast(product_description_lenght as integer) as descricao_comprimento,
        cast(product_photos_qty as integer) as fotos_quantidade,

        cast(product_weight_g as numeric) as peso_g,
        cast(product_length_cm as numeric) as comprimento_cm,
        cast(product_height_cm as numeric) as altura_cm,
        cast(product_width_cm as numeric) as largura_cm
    from source
)

select * from renamed