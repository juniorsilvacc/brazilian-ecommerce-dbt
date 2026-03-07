with products as (
    select * from {{ ref('stg_products') }}
),

final as (
    select
        produto_id,
        categoria_nome,
        -- Adicionando metadados úteis para análise de logística
        peso_g as produto_peso_gramas,
        comprimento_cm as produto_comprimento_cm,
        altura_cm as produto_altura_cm,
        largura_cm as produto_largura_cm,
        -- Criando uma flag de volume
        case 
            when (comprimento_cm * altura_cm * largura_cm) > 20000 
            then 'Grande Porte'
            else 'Pequeno/Médio Porte'
        end as categoria_volumetria
    from products
)

select * from final