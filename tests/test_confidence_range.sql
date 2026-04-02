select *
from {{ ref('mart_association_rules') }}
where confidence < 0 or confidence > 1