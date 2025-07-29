with 

source as (

    select * from {{ source('staging', 'fhv_tripdata') }}

),

renamed as (

    select
        dispatching_base_num,
        pickup_datetime,
        dropoff_datetime,
        safe_cast(pulocationid as INT64) as pickup_locationid,
        safe_cast(dolocationid as INT64) as dropoff_locationid,
        affiliated_base_number,
        sr_flag

    from source

)

select * from renamed
where dispatching_base_num is not null
