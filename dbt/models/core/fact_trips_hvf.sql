{{
    config(
        materialized='table'
    )
}}

with hvf_data as (
    select
        *
    from
        {{ ref('stg_fhv_tripdata') }}
),

dim_zones as (
    select
        *
    from
        {{ ref('dim_zones') }}
    where
        borough != 'Unknown'
)

select
    hd.dispatching_base_num,
    hd.pickup_datetime,
    hd.dropoff_datetime,
    hd.pickup_locationid,
    hd.dropoff_locationid,
    hd.affiliated_base_number,
    hd.sr_flag,
    extract(year from hd.pickup_datetime) as year,
    extract(month from hd.pickup_datetime) as month,
    z_pickup.borough as pickup_borough,
    z_dropoff.borough as dropoff_borough,
    z_pickup.zone as pickup_zone,
    z_dropoff.zone as dropoff_zone,
    z_pickup.service_zone 
from
    hvf_data as hd
    inner join dim_zones as z_pickup 
    on z_pickup.locationid = hd.pickup_locationid
    inner join dim_zones as z_dropoff
    on z_dropoff.locationid = hd.dropoff_locationid