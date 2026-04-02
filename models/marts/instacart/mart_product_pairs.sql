{{ config(
    materialized='table'
) }}

with pairs as (

    select * from {{ ref('int_product_pairs') }}

),

pair_counts as (

    select
        product_1,
        product_2,
        count(*) as support_count

    from pairs

    group by product_1, product_2

),

total_orders as (

    select count(distinct order_id) as total
    from {{ ref('stg_orders') }}

)

select
    pc.product_1,
    pc.product_2,
    pc.support_count,
    pc.support_count * 1.0 / t.total as support

from pair_counts pc
cross join total_orders t

where pc.support_count * 1.0 / t.total >= 0.01  -- min_sup (1%)