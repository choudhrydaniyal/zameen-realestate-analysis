select * 
from listings
limit 100;

select count(*)
from listings;

-- 1. City Level Comparison
select 
	city,
    format(avg(price_pkr), 2) as avg_price,
    format(avg(price_per_marla), 2) as avg_price_per_marla,
    count(*) as total_listings
from listings
group by city;

--  2. Top 10 most expensive neighbourhoods per city
with ranking as(
select 
	city,
    neighbourhood,
    format(avg(price_per_marla), 2) as avg_price_per_marla,
    rank() over(partition by city order by AVG(price_per_marla) desc) as rnk
from listings
group by city, neighbourhood
)
select city, neighbourhood, avg_price_per_marla, rnk
from ranking
where rnk <= 10;

-- 3. Price vs Size Relationship
select
	city,
    case
		when size_marla <= 5 then 'small'
        when size_marla <= 10 then 'medium'
        when size_marla <= 20 then 'large'
        else 'luxury'
	end as size_bucket,
    count(*) as total_listings,
    round(avg(size_marla), 2) as avg_marla,
    format(avg(price_pkr), 2) as avg_price,
    format(avg(price_per_marla), 2) as avg_price_per_marla
from listings
group by city, size_bucket
order by city, 
CASE size_bucket
    WHEN 'small'  THEN 1
    WHEN 'medium' THEN 2
    WHEN 'large'  THEN 3
    WHEN 'luxury' THEN 4
END;

-- Bedroom Premium Analysis
select 
	city,
    round(beds) as beds_count,
    count(*) as total_listings,
    format(avg(price_pkr), 2) as avg_price,
    format(avg(price_per_marla), 2) as avg_price_per_marla
from listings
group by city, beds_count
order by city, beds_count;
    
    
-- 4. Most Listings By Area
with ranking as
(
select
	city,
    area,
    count(*) as total_listings,
	row_number() over(partition by city order by count(*) desc) as rnk,
	FORMAT(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY city), 2) AS listings_percentage
from listings
group by city, area
)
select 
	city,
    area,
    total_listings,
    rnk,
    listings_percentage
from ranking
where rnk <= 10
order by city, rnk;

-- 4. Most Listings By Neighbourhood
with ranking as
(
select
	city,
    neighbourhood,
    count(*) as total_listings,
	row_number() over(partition by city order by count(*) desc) as rnk,
	FORMAT(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY city), 2) AS listings_percentage
from listings
group by city, neighbourhood
)
select 
	city,
    neighbourhood,
    total_listings,
    rnk,
    listings_percentage
from ranking
where rnk <= 10
order by city, rnk;

-- 5. Price Deviation
with ranking as
(
select
	city,
    neighbourhood,
    count(*) as total_listings,
    format(avg(price_per_marla), 2) as avg_price_per_marla,
    format(stddev(price_per_marla), 2) as std_dev,
    format(min(price_per_marla), 2) as min_price_per_marla,
	format(max(price_per_marla), 2) as max_price_per_marla,
    ROUND(STDDEV(price_per_marla) / AVG(price_per_marla) * 100, 2) as cv,
    row_number() over(partition by city order by (STDDEV(price_per_marla) / AVG(price_per_marla) * 100) desc) as rnk
from listings
group by city, neighbourhood
having count(*) > 10
order by city, cv desc
)
select *
from ranking
where rnk <= 10;

select * from listings
where neighbourhood like 'Gulberg Greens';

WITH city_avg AS (
    SELECT 
        city,
        AVG(price_per_marla) AS city_avg_price_per_marla,
        AVG(size_marla)      AS city_avg_size_marla
    FROM listings
    GROUP BY city
)
SELECT 
    l.city,
    l.neighbourhood,
    COUNT(*)                                   AS total_listings,
    FORMAT(AVG(l.price_per_marla), 2)          AS avg_price_per_marla,
    ROUND(AVG(l.size_marla), 2)                AS avg_size_marla,
    FORMAT(ca.city_avg_price_per_marla, 2)     AS city_avg_price_per_marla,
    ROUND(ca.city_avg_size_marla, 2)           AS city_avg_size_marla
FROM listings l
JOIN city_avg ca ON l.city = ca.city
GROUP BY l.city, l.neighbourhood, ca.city_avg_price_per_marla, ca.city_avg_size_marla
HAVING AVG(l.price_per_marla) < ca.city_avg_price_per_marla
   AND AVG(l.size_marla)      > ca.city_avg_size_marla
   AND COUNT(*) >= 5
ORDER BY l.city, AVG(l.price_per_marla) ASC;
