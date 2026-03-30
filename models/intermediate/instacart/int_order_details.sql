{{ config(
    materialized='incremental',
    unique_key=['order_id', 'product_id']
) }}

with orders as (

    select *
    from {{ ref('stg_orders') }}

    {% if is_incremental() %}
        where cast(order_id as {{ dbt.type_int() }}) > (
            select coalesce(max(order_id), 0)
            from {{ this }}
        )
    {% endif %}

),

order_products as (

    select * from {{ ref('stg_order_products') }}

),

products as (

    select * from {{ ref('stg_products') }}

),

departments as (

    select * from {{ ref('stg_departments') }}

),

aisles as (

    select * from {{ ref('stg_aisles') }}

)

select
    cast(o.order_id as {{ dbt.type_int() }}) as order_id,
    cast(o.user_id as {{ dbt.type_int() }}) as user_id,
    cast(o.order_number as {{ dbt.type_int() }}) as order_number,
    cast(o.order_dow as {{ dbt.type_int() }}) as order_dow,
    cast(o.order_hour_of_day as {{ dbt.type_int() }}) as order_hour_of_day,

    cast(op.product_id as {{ dbt.type_int() }}) as product_id,
    cast(p.product_name as {{ dbt.type_string() }}) as product_name,

    cast(d.department as {{ dbt.type_string() }}) as department,
    cast(a.aisles_name as {{ dbt.type_string() }}) as aisles_name,

    cast(op.add_to_cart_order as {{ dbt.type_int() }}) as add_to_cart_order,
    cast(op.reordered as {{ dbt.type_boolean() }}) as reordered

from orders o
join order_products op on o.order_id = op.order_id
join products p on op.product_id = p.product_id
join departments d on p.department_id = d.department_id
join aisles a on p.aisle_id = a.aisles_id