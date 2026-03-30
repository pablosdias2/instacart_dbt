with order_products as (

    select
        order_id,
        product_id
    from {{ ref('stg_order_products') }}

),

pairs as (

    select
        op1.order_id,
        op1.product_id as product_1,
        op2.product_id as product_2

    from order_products op1
    join order_products op2
        on op1.order_id = op2.order_id
       and op1.product_id < op2.product_id

)

select * from pairs