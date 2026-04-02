{{ config(
    materialized='table'
) }}

with pairs as (

    select * from {{ ref('mart_product_pairs') }}

),

products as (

    select * from {{ ref('stg_products') }}

)

select
    p1.product_name as product_1_name,
    p2.product_name as product_2_name,
    pairs.support,
    pairs.support_count

from pairs
join products p1 on pairs.product_1 = p1.product_id
join products p2 on pairs.product_2 = p2.product_id