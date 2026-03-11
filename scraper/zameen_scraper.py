from playwright.sync_api import sync_playwright
import csv
import time
import random
import os

CITIES = {
    "islamabad": "https://www.zameen.com/Homes/Islamabad-3-{page}.html",
    "lahore":    "https://www.zameen.com/Homes/Lahore-1-{page}.html",
    "karachi":   "https://www.zameen.com/Homes/Karachi-2-{page}.html",
}

PAGES_PER_CITY = 100
DATA_DIR = "../data"
FIELDNAMES = ["city", "price", "location", "beds", "baths", "size", "title"]

def extract_listing(listing, city):
    def get_field(aria_label):
        el = listing.query_selector(f"[aria-label='{aria_label}']")
        return el.inner_text().strip() if el else None

    return {
        "city":     city,
        "price":    get_field("Price"),
        "location": get_field("Location"),
        "beds":     get_field("Beds"),
        "baths":    get_field("Baths"),
        "size":     get_field("Area"),
        "title":    get_field("Title"),
    }

def init_csv(filepath):
    """Create CSV with headers if it doesn't exist yet"""
    if not os.path.exists(filepath):
        with open(filepath, "w", newline="", encoding="utf-8") as f:
            writer = csv.DictWriter(f, fieldnames=FIELDNAMES)
            writer.writeheader()

def append_to_csv(filepath, rows):
    """Append rows to existing CSV"""
    with open(filepath, "a", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=FIELDNAMES)
        writer.writerows(rows)

def scrape_city(page, city, url_template):
    city_file    = os.path.join(DATA_DIR, f"{city}_listings_raw.csv")
    combined_file = os.path.join(DATA_DIR, "all_listings_raw.csv")

    init_csv(city_file)
    init_csv(combined_file)

    total_scraped = 0

    for page_num in range(1, PAGES_PER_CITY + 1):
        url = url_template.format(page=page_num)
        print(f"  [{city.upper()}] Page {page_num}/{PAGES_PER_CITY}", end=" — ")

        try:
            page.goto(url, wait_until="domcontentloaded")
            time.sleep(random.uniform(3, 6))

            page.wait_for_selector("li.a37d52f0", timeout=15000)
            listings = page.query_selector_all("li.a37d52f0")

            rows = []
            for listing in listings:
                data = extract_listing(listing, city)
                if data["price"]:
                    rows.append(data)

            # save after every page
            append_to_csv(city_file, rows)
            append_to_csv(combined_file, rows)

            total_scraped += len(rows)
            print(f"{len(rows)} listings scraped (total: {total_scraped})")

        except Exception as e:
            print(f"ERROR — {e} — skipping")
            continue

    print(f"\n  [{city.upper()}] Done. {total_scraped} total listings saved.\n")
    return total_scraped

def main():
    os.makedirs(DATA_DIR, exist_ok=True)

    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)  # no visible browser
        page = browser.new_page()

        page.set_extra_http_headers({
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
        })

        grand_total = 0
        for city, url_template in CITIES.items():
            print(f"\n{'='*50}")
            print(f"Starting {city.upper()}")
            print(f"{'='*50}")
            scraped = scrape_city(page, city, url_template)
            grand_total += scraped

        browser.close()

    print(f"\nAll done. {grand_total} total listings across all cities.")

if __name__ == "__main__":
    main()