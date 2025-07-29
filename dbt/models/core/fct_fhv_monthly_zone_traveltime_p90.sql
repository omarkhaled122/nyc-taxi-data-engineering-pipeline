{{
    config(
        materialized='table'
    )
}}

with

hvf_data as (
    select
        *
    from
        {{ ref('fact_trips_hvf') }}
),

hvf_data_duration as (
    select
        *,
        timestamp_diff(hd.dropoff_datetime, hd.pickup_datetime, second) as trip_duration
    from
        hvf_data hd
)

select
    year,
    month,
    pickup_zone,
    dropoff_zone,
    trip_duration,
    ntile (100) over (partition by year, month, pickup_zone
                      order by trip_duration) as trip_duration_percentile
from
    hvf_data_duration
order by
    1, 2, 3, 5