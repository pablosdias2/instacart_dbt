select
    aisles_id,
    aisles_name
from {{ source('instacart', 'aisles') }}