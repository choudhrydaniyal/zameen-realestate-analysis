# Pakistan Real Estate Market Analysis
## Islamabad | Lahore | Karachi

### Project Overview

This project analyzes residential property listings scraped from Zameen.com — Pakistan's largest real estate platform. The dataset covers **~7,300 listings** across Islamabad, Lahore, and Karachi, collected via a custom Playwright-based web scraper. Data was cleaned in Python (Pandas) and analyzed using MySQL, with visualizations built in Power BI.

**Tools Used:** Python (Playwright, Pandas), MySQL, Power BI  
**Data Source:** Zameen.com (scraped)  
**Dataset Size:** ~7,300 residential listings (post-cleaning)

---

### Project Structure

```
zameen-realestate-analysis/
├── scraper/
│   └── zameen_scraper.py        # Playwright scraper for all 3 cities
├── data/
│   ├── islamabad_listings_raw.csv
│   ├── lahore_listings_raw.csv
│   ├── karachi_listings_raw.csv
│   ├── all_listings_raw.csv
│   └── all_listings_clean.csv
├── notebooks/
│   └── cleaning.ipynb           # Data cleaning pipeline
├── sql/
│   └── analysis_queries.sql     # All analysis queries
└── README.md
```

---

### Data Collection & Cleaning

- Scraped 100 pages per city (~25 listings per page) using Playwright, which renders JavaScript-heavy pages like Zameen.com
- Random delays of 3–6 seconds between page requests to mimic human behaviour and avoid bot detection
- Data saved progressively after every page to prevent loss on failure

**Cleaning steps:**
- Parsed price strings (Lakh, Crore, Arab) into numeric PKR values
- Parsed size strings (Marla, Kanal, Sq. Yd., Sq. Ft.) into a unified Marla numeric value — note Karachi listings predominantly use Square Yards
- Split location into neighbourhood and area columns
- Calculated price per Marla as a key derived metric
- Filled missing beds/baths using group median by size category, with overall median as fallback
- Removed 162 commercial listings (shops, offices) identified via title keywords

---

### Key Findings

#### City Level Comparison

**Finding 1 — Islamabad is Pakistan's most expensive residential market.**
At PKR 6.1M per Marla on average, Islamabad is 33% more expensive than Lahore (4.6M/Marla) and 7% more expensive than Karachi (5.7M/Marla) — despite Karachi being Pakistan's financial and commercial hub. This premium likely reflects Islamabad's planned infrastructure, security, and government/diplomatic demand.

| City | Avg Price (PKR) | Avg Price/Marla (PKR) | Listings |
|------|----------------|----------------------|----------|
| Islamabad | 106.7M | 6.12M | 2,500 |
| Karachi | 78.4M | 5.71M | 2,498 |
| Lahore | 67.2M | 4.61M | 2,495 |

---

#### Top Neighbourhoods by Price Per Marla

**Finding 2 — Premium neighbourhood character differs significantly by city.**

- **Islamabad** — F and G sectors dominate entirely. F-7/3 leads at PKR 24.3M/Marla. These are Islamabad's most established and centrally located sectors
- **Karachi** — Institutional and defence housing leads. KDA Officers Society tops at 18.2M/Marla. Premium Karachi real estate is heavily tied to government and military housing schemes
- **Lahore** — Zameen's own branded developments (Arx, Madison Square, Zee Avenue) occupy 5 of the top 10 spots, representing a potential platform bias. DHA Phase 5 and 8 are the only traditional premium neighbourhoods in the top 10

**Finding 3 — Islamabad's premium ceiling is significantly higher than other cities.**
Islamabad's top neighbourhood (F-7/3 at 24.3M/Marla) is 64% more expensive than Lahore's top neighbourhood (14.8M/Marla) and 33% more expensive than Karachi's top neighbourhood (18.2M/Marla).

---

#### Price vs Property Size

**Finding 4 — Larger properties cost more per Marla, not less — consistent across all three cities.**
This is counterintuitive compared to western real estate markets where smaller properties typically command a size premium. In Pakistan, luxury properties command a per-Marla premium, not a discount.

| Size Bucket | Islamabad PKR/Marla | Karachi PKR/Marla | Lahore PKR/Marla |
|-------------|--------------------|--------------------|------------------|
| Small (<5M) | 5.0M | 4.6M | 4.5M |
| Medium (5–10M) | 5.4M | 5.2M | 4.4M |
| Large (10–20M) | 6.8M | 6.4M | 4.7M |
| Luxury (20M+) | 9.5M | 8.6M | 5.2M |

**Finding 5 — Islamabad's luxury segment commands the steepest premium.**
Luxury properties in Islamabad average 9.5M PKR/Marla — 90% more expensive than small properties in the same city, and 82% more expensive than luxury properties in Lahore.

**Finding 6 — Lahore's pricing is remarkably flat across size categories.**
The difference between small and luxury in Lahore is only 0.75M PKR/Marla, compared to 4.5M in Islamabad. Lahore pricing is driven more by location and neighbourhood prestige than property size.

---

#### Bedroom Premium Analysis

**Finding 7 — Bedroom count is a strong price driver in Islamabad up to 8 bedrooms.**
Each additional bedroom meaningfully increases price per Marla in Islamabad. Beyond 8 bedrooms sample sizes become too small (<35 listings) to draw reliable conclusions.

**Finding 8 — Karachi shows an unusual premium for 1-bedroom properties.**
1-bed properties in Karachi average 7.2M PKR/Marla — higher than 2, 3, and 4 bed properties. This suggests 1-bed listings in Karachi are predominantly small luxury apartments in premium locations rather than starter homes.

**Finding 9 — Lahore's bedroom premium plateaus after 6 beds.**
After 6 bedrooms, price per Marla actually declines in Lahore. Large bedroom counts do not command the same premium as in Islamabad and Karachi — consistent with Lahore's generally flatter pricing structure.

---

#### Supply Concentration

**Finding 10 — DHA appears in the top 3 supply areas of every city.**
DHA developments are the dominant organised residential supply across all three cities — the single most important housing brand in Pakistan's real estate market.

**Finding 11 — Supply is heavily concentrated at area level but distributed at neighbourhood level.**
At area level, the top 3 areas account for 50%+ of supply in each city. At neighbourhood level, no single neighbourhood exceeds 7% of city supply — meaning buyers have genuine choice within their preferred area.

**Finding 12 — Large generic area tags (Islamabad, Lahore, Karachi) represent significant listing volume.**
34.8% of Islamabad listings, 21.7% of Lahore listings, and 12% of Karachi listings use generic city-level area tags rather than specific neighbourhood names — a data quality limitation of the Zameen platform.

**Finding 13 — Bahria Town features prominently in Islamabad and Karachi but not Lahore's top neighbourhoods** — likely underrepresented in this dataset despite Bahria Town Lahore being one of Pakistan's largest housing schemes.

---

#### Price Volatility by Neighbourhood

**Finding 14 — Karachi has the most extreme price volatility.**
Naya Nazimabad in Karachi has a Coefficient of Variation (CV) of 137.7 — the standard deviation exceeds the average price itself. Price range spans from 2.96M to 58.9M PKR/Marla within the same neighbourhood, suggesting very different property types are categorised under the same neighbourhood tag.

**Finding 15 — Islamabad's most volatile neighbourhoods are mid-tier developing areas.**
E-11, D-17, and Faisal Town lead Islamabad's volatility list — transitional neighbourhoods where pricing hasn't stabilised. Notably F-7, F-6 and other established premium sectors do not appear, confirming that mature premium areas have consistent well-established pricing.

**Finding 16 — Lahore's volatility is concentrated in DHA Phase 6.**
DHA Phase 6 and its sub-blocks dominate Lahore's volatile list with a CV of 45 and a price range of 937K to 16.25M PKR/Marla — driven by significant variation in plot sizes, locations within the phase, and development status.

> **Interpretation:** High CV neighbourhoods represent potential buyer opportunity — pricing is inconsistent, motivated sellers exist, and significant below-average deals are possible. Low CV neighbourhoods have stable, well-established pricing with less room for negotiation.

---

#### Value Hotspots

Neighbourhoods with **above average property size AND below average price per Marla** — the best value-for-money areas in each city.

**Finding 17 — Islamabad's best value hotspots are Bani Gala and Gulberg Greens.**
Gulberg Greens averages 73.9 Marla at only 3.88M PKR/Marla against a city average of 6.1M/Marla and 20.9 Marla average size — 36% cheaper per Marla with 3.5x more space than the city average. Bani Gala offers 29.6 Marla at 3.4M/Marla — the largest and cheapest combination in Islamabad.

**Finding 18 — Bahria Town developments represent Karachi's best value proposition.**
Bahria Sports City, Bahria Paradise, and multiple Bahria precincts all offer above average sizes at well below city average price per Marla. Bahria Sports City averages only 1.2M PKR/Marla against a city average of 5.7M — though remote location accounts for much of this discount.

**Finding 19 — Lahore has the most accessible value hotspots of the three cities.**
20 Lahore neighbourhoods qualify as value hotspots compared to Islamabad's 8 and Karachi's 15. DHA Phase 7 blocks dominate with multiple sub-blocks offering above average sizes at below average prices. Valencia Housing Society at 25.9 Marla average and 3.88M/Marla is particularly strong.

**Finding 20 — Lahore offers the most options for value-conscious buyers.**
Consistent with the flat pricing structure identified in the size analysis, Lahore's market rewards buyers who prioritise space over prestige — more neighbourhoods offer large properties at below-market rates than either Islamabad or Karachi.

---

### Data Limitations

1. **Generic area tags** — a significant portion of listings use city-level tags rather than specific neighbourhood names, limiting neighbourhood-level analysis precision
2. **Commercial listings** — 162 commercial properties were removed based on title keywords; some may remain in the dataset
3. **Large property outliers** — properties above 100 Marla (farms, agricultural plots) were retained in the dataset and filtered at query level where relevant
4. **Platform bias** — Zameen's own branded developments (Zameen Arx, Zameen Vault etc.) appear prominently in Lahore's premium listings, which may reflect promotional placement rather than true market pricing
5. **Snapshot data** — data represents a single point in time and does not capture price trends over time

---

### How to Run This Project

**1. Scrape data:**
```bash
cd scraper
python zameen_scraper.py
```

**2. Clean data:**
Open `notebooks/cleaning.ipynb` and run all cells top to bottom.

**3. Load to MySQL:**
```sql
CREATE DATABASE zameen_dataset;
USE zameen_dataset;
-- run schema creation and LOAD DATA commands from sql/analysis_queries.sql
```

**4. Run analysis:**
Execute queries in `sql/analysis_queries.sql` in MySQL Workbench.

**5. Visualize:**
Open Power BI and connect directly to `zameen_dataset` MySQL database.
