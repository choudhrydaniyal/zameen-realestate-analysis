select * 
from listings
limit 10;

select count(*)
from listings;

-- City Level Comparison
select 
	city,
    format(avg(price_pkr), 2) as avg_price,
    format(avg(price_per_marla), 2) as avg_price_per_marla,
    count(*) as total_listings
from listings
group by city;

--  Top 10 most expensive neighbourhoods per city
with rankings as(
select 
	city,
    neighbourhood,
    format(avg(price_per_marla), 2) as avg_price_per_marla,
    rank() over(partition by city order by AVG(price_per_marla) desc) as rnk
from listings
group by city, neighbourhood
)
select city, neighbourhood, avg_price_per_marla, rnk
from rankings
where rnk <= 10;

