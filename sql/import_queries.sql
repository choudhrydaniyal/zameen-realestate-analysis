CREATE DATABASE zameen_database;

USE zameen_database;

CREATE TABLE listings (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    city             VARCHAR(50),
    price            VARCHAR(50),
    location         VARCHAR(255),
    beds             DOUBLE,
    baths            DOUBLE,
    size             VARCHAR(50),
    title            TEXT,
    price_pkr        DOUBLE,
    size_marla       DOUBLE,
    neighbourhood    VARCHAR(255),
    area             VARCHAR(255),
    price_per_marla  DOUBLE
);

-- Deleting Commercial Properties
delete from listings
WHERE title LIKE '%Shop%'
OR title LIKE '%Commercial%'
OR title LIKE '%Office%';

select * from listings
limit 20;
