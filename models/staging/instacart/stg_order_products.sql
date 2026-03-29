select
    order_id,
    product_id,
    add_to_cart_order,
    reordered
from {{ source('instacart', 'order_products__prior') }}