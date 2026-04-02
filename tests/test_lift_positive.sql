select *
from {{ ref('mart_association_rules') }}
where lift <= 0