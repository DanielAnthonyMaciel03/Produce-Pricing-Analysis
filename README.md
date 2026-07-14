# Produce Price Seasonality & Cash Flow Planning Analysis

## Business Question
How do wholesale prices for Avocados, Tomatoes, Romaine Lettuce, Strawberries, and Bananas change seasonally, and what does that mean for how a produce company should plan cash flow around purchasing throughout the year?

## Data Source
- USDA AMS Specialty Crops Market News — Terminal Market daily price reports
- [My Market News public data tool](https://mymarketnews.ams.usda.gov/public_data)
- Market hub: Los Angeles, California (closest available proxy to Houston's import/domestic supply mix — Texas border crossings aren't available in this report type)
- Jan 2023 – Dec 2025, daily granularity, pulled per commodity in 12-month increments (tool query limit)

## Cleaning (pandas)
- Dropped 15 columns that were empty or populated in under 15% of rows
- Filtered to conventional (non-organic) listings to avoid price-premium skew
- Built a representative price per listing: USDA's "mostly price" when available, falling back to the low/high midpoint (~45% of rows) when missing
- Dropped 145 rows with no usable price, and 14 rows with a generic "Imports" origin label
- Kept origin unfiltered for all commodities — some (e.g., lettuce) shift growing regions seasonally, and filtering risked creating data gaps

## Database Schema (PostgreSQL)
Normalized, 3-table design:
- `commodities` (dimension) — commodity_id, commodity_name
- `origins` (dimension) — origin_id, origin
- `daily_prices` (fact) — commodity_id (FK), report_date, origin_id (FK), avg_price, min_price, max_price, num_listings

Loaded via a staging table to translate raw text values into proper foreign key IDs before inserting into the final fact table.

## Tools
Python (pandas), PostgreSQL, SQL, GitHub


