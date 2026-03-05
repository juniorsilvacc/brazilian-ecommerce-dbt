with reviews as (
    select * from {{ ref('stg_order_reviews') }}
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
    from reviews
)

select * from final