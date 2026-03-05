with reviews as (
    select * from {{ ref('stg_order_reviews') }}
),

deduplicated as (
    -- Seleciona apenas o review mais recente ou o primeiro que aparecer
    -- Garante que o review_id seja único
    select
        review_id,
        order_id,
        review_score,
        created_at,
        row_number() over (
            partition by review_id 
            order by created_at desc
        ) as row_num
    from reviews
),

final as (
    select
        review_id,
        order_id,
        review_score,

        -- Métrica binária de satisfação
        case when review_score >= 4 
            then 1 
            else 0 
        end as is_satisfied,
        created_at as reviewed_at
    from deduplicated
    where row_num = 1 -- Filtra para manter apenas uma linha por ID
)

select * from final