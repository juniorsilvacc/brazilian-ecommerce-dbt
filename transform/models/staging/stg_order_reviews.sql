with source as (
    select * from {{ source('brazilian-ecommerce', 'raw_order_reviews') }}
),

renamed as (
    select 
        cast(review_id as varchar) as review_id,
        cast(order_id as varchar) as order_id,

        cast(review_score as integer) as review_score,

        -- Se o comentário for vazio, vira NULL
        nullif(trim(review_comment_title), '') as review_title,
        nullif(trim(review_comment_message), '') as review_message,

        cast(review_creation_date as timestamp) as created_at,
        cast(review_answer_timestamp as timestamp) as answered_at
    from source
)

select * from renamed