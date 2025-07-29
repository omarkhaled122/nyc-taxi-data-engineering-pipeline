{{
    config(
        materialized='table'
    )
}}

with tripdata as (
    select
        tripid,
        service_type,
        extract(year from pickup_datetime) as year,
        extract(month from pickup_datetime) as month,
        fare_amount,
    from
        {{ ref('fact_trips') }}
    where
        fare_amount > 0 and
        trip_distance > 0 and
        payment_type_description in ('Credit card', 'Cash')
)

select
    service_type,
    year,
    month,
    fare_amount,
    ntile(100) over (partition by service_type, year, month order by fare_amount) as percentile 
from
    tripdata
order by 1, 2, 3, 4
