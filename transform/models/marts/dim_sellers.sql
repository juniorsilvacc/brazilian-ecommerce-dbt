with sellers as (
    select * from {{ ref('stg_sellers') }}
),

final as (
    select
        seller_id,
        city as seller_city,
        state as seller_state
    from sellers
)

select * from final