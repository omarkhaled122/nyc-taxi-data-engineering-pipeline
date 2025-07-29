SELECT
    locationid,
    borough,
    zone,
    replace(service_zone, 'boro', 'green') AS service_zone 
From
    {{ ref('taxi_zone_lookup') }}