{{ config(
    materialized='table'
) }}

with association_rules as (

    select *
    from {{ ref('mart_association_rules') }}

),

products as (

    select *
    from {{ ref('stg_products') }}

)

select
    ar.product_1,
    p1.product_name as product_1_name,
    ar.product_2,
    p2.product_name as product_2_name,
    ar.support_ab,
    ar.support_a,
    ar.support_b,
    ar.confidence,
    ar.lift

from association_rules ar
join products p1
    on ar.product_1 = p1.product_id
join products p2
    on ar.product_2 = p2.product_id