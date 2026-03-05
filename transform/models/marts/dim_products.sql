with products as (
    select * from {{ ref('stg_products') }}
),

translation as (
    select * from {{ source('brazilian-ecommerce', 'raw_product_category_translation') }}
),

final as (
    select
        p.product_id,
        coalesce(t.product_category_name_english, p.category_name) as category_en,
        p.category_name as category_pt,
        p.weight_g,

        -- Calculamos o volume cúbico do produto para logística. Espaço que o produto ocupa no caminhão
        (p.length_cm * p.height_cm * p.width_cm) as volume_cm3
    from products p
    left join translation t on p.category_name = t.product_category_name
)

select * from final
