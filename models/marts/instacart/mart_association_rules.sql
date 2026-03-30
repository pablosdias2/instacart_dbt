with pairs as (

    select *
    from {{ ref('mart_product_pairs') }}

),

-- total de pedidos
total_orders as (

    select count(distinct order_id) as total
    from {{ ref('stg_orders') }}

),

-- suporte individual recalculado corretamente
product_support_fixed as (

    select
        op.product_id,
        count(distinct op.order_id) * 1.0 / t.total as support
    from {{ ref('stg_order_products') }} op
    cross join total_orders t
    group by op.product_id, t.total

)

select
    p.product_1,
    p.product_2,
    p.support as support_ab,

    ps1.support as support_a,
    ps2.support as support_b,

    -- confidence
    p.support / ps1.support as confidence,

    -- lift
    (p.support / ps1.support) / ps2.support as lift

from pairs p

join product_support_fixed ps1
    on p.product_1 = ps1.product_id

join product_support_fixed ps2
    on p.product_2 = ps2.product_id

where ps1.support > 0
  and ps2.support > 0