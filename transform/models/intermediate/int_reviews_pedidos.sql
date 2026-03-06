-- Agrega as avaliações por pedido (caso um pedido tenha recebido mais de uma review).

select
    pedido_id,
    avg(review_nota) as media_score_review,
    count(review_id) as total_reviews
from {{ ref('stg_order_reviews') }}
group by 1