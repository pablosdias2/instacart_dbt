with order_details as (

    select * from {{ ref('int_order_details') }}

)

select
    product_id,
    product_name,
    count(*) as total_vendas,
    count(distinct user_id) as total_usuarios,
    sum(case when reordered then 1 else 0 end) as total_recompras

from order_details

group by
    product_id,
    product_name

order by total_vendas desc