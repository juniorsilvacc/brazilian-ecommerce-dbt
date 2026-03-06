with source as (
    select * from {{ source('brazilian-ecommerce', 'raw_order_reviews') }}
),

renamed as (
    select 
        cast(review_id as varchar) as review_id,
        cast(order_id as varchar) as pedido_id,

        cast(review_score as integer) as review_nota,

        -- Se o comentário for vazio, vira NULL
        nullif(trim(review_comment_title), '') as review_titulo,
        nullif(trim(review_comment_message), '') as review_messagem,

        cast(review_creation_date as timestamp) as criado_em,
        cast(review_answer_timestamp as timestamp) as respondido_em
    from source
)

select * from renamed