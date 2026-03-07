select
    cliente_id,
    cliente_unico_id,
    cidade as cliente_cidade,
    estado as cliente_estado
from {{ ref('int_clientes_localizacao') }}