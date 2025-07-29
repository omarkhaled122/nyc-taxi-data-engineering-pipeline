{{
    config(
        materialized='table'
    )
}}

with quarterly_revenue as (
    select
        service_type,
        extract(year from pickup_datetime) as year,
        extract(quarter from pickup_datetime) as quarter,
        sum(total_amount) as quarter_revenue
    from {{ ref('fact_trips') }}
    where extract(year from pickup_datetime) between 2019 and 2020
    group by 1, 2, 3
),

yoy as (
    select
        current_.service_type,
        current_.year,
        current_.quarter,
        current_.quarter_revenue,
        prior_.quarter_revenue as prior_year_revenue,
        case
            when prior_.quarter_revenue is not null and prior_.quarter_revenue > 0     
            then ((current_.quarter_revenue - prior_.quarter_revenue) * 100.0 / prior_.quarter_revenue)
            else null
        end as yoy_growth_perecentage

    from
        quarterly_revenue current_
        left join
        quarterly_revenue prior_
        on
        current_.service_type = prior_.service_type and
        current_.year = prior_.year + 1 and
        current_.quarter = prior_.quarter 
            
)

select * from yoy
order by    
    service_type, year, quarter