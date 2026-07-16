-- Dimension table: commodities
CREATE TABLE commodities (
    commodity_id SERIAL PRIMARY KEY,
    commodity_name VARCHAR(50) UNIQUE NOT NULL
);

-- Dimension table: origins
CREATE TABLE origins (
    origin_id SERIAL PRIMARY KEY,
    origin VARCHAR(50) UNIQUE NOT NULL
);

-- Staging table: temporary landing spot for raw CSV import (plain text, no foreign keys)
CREATE TABLE staging_daily_prices (
    commodity_name VARCHAR(50),
    report_date DATE,
    origin VARCHAR(50),
    avg_price NUMERIC(10,2),
    min_price NUMERIC(10,2),
    max_price NUMERIC(10,2),
    num_listings INT
);

-- Fact table: daily_prices, with real foreign keys to commodities and origins
CREATE TABLE daily_prices (
    price_id SERIAL PRIMARY KEY,
    commodity_id INT REFERENCES commodities(commodity_id),
    report_date DATE NOT NULL,
    origin_id INT REFERENCES origins(origin_id),
    avg_price NUMERIC(10,2),
    min_price NUMERIC(10,2),
    max_price NUMERIC(10,2),
    num_listings INT
);