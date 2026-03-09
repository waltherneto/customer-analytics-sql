from __future__ import annotations

import random
from dataclasses import dataclass
from datetime import datetime, timedelta
from pathlib import Path

import pandas as pd


SEED = 42
N_ROWS = 200_000
N_CUSTOMERS = 12_000
N_PRODUCTS = 250

START_DATE = datetime(2023, 1, 1)
END_DATE = datetime(2024, 12, 31)

BASE_DIR = Path(__file__).resolve().parents[1]
OUTPUT_PATH = BASE_DIR / "data" / "raw" / "customer_transactions.csv"


@dataclass(frozen=True)
class Product:
    product_id: str
    product_name: str
    category: str
    base_price: float


def build_products() -> list[Product]:
    categories = {
        "Electronics": (80, 900),
        "Home": (20, 250),
        "Fashion": (15, 180),
        "Beauty": (10, 120),
        "Sports": (25, 300),
        "Books": (8, 60),
        "Toys": (12, 150),
        "Groceries": (5, 40),
    }

    products: list[Product] = []
    product_counter = 1

    for category, (min_price, max_price) in categories.items():
        n_per_category = N_PRODUCTS // len(categories)

        for i in range(n_per_category):
            base_price = round(random.uniform(min_price, max_price), 2)
            product_id = f"P{product_counter:04d}"
            product_name = f"{category[:-1] if category.endswith('s') else category} Product {i + 1}"
            products.append(
                Product(
                    product_id=product_id,
                    product_name=product_name,
                    category=category,
                    base_price=base_price,
                )
            )
            product_counter += 1

    while len(products) < N_PRODUCTS:
        category = "Home"
        base_price = round(random.uniform(20, 250), 2)
        product_id = f"P{product_counter:04d}"
        product_name = f"Home Product Extra {product_counter}"
        products.append(Product(product_id, product_name, category, base_price))
        product_counter += 1

    return products


def build_customers() -> pd.DataFrame:
    countries = ["United Kingdom", "Germany", "France", "Spain", "Netherlands", "Italy"]
    country_weights = [0.35, 0.18, 0.16, 0.12, 0.10, 0.09]

    customer_ids = [f"C{idx:05d}" for idx in range(1, N_CUSTOMERS + 1)]

    segments = random.choices(
        population=["VIP", "Loyal", "Regular", "Occasional", "At Risk"],
        weights=[0.05, 0.20, 0.35, 0.25, 0.15],
        k=N_CUSTOMERS,
    )

    assigned_countries = random.choices(countries, weights=country_weights, k=N_CUSTOMERS)

    return pd.DataFrame(
        {
            "customer_id": customer_ids,
            "country": assigned_countries,
            "segment": segments,
        }
    )


def random_order_date() -> datetime:
    delta_days = (END_DATE - START_DATE).days
    random_days = random.randint(0, delta_days)
    base_date = START_DATE + timedelta(days=random_days)

    month = base_date.month
    seasonal_multiplier = 1.0

    if month in [11, 12]:
        seasonal_multiplier = 1.25
    elif month in [6, 7]:
        seasonal_multiplier = 1.10

    if random.random() > seasonal_multiplier / 1.3:
        shifted_days = random.randint(0, delta_days)
        base_date = START_DATE + timedelta(days=shifted_days)

    return base_date


def segment_order_weight(segment: str) -> float:
    weights = {
        "VIP": 6.0,
        "Loyal": 3.5,
        "Regular": 2.0,
        "Occasional": 1.0,
        "At Risk": 0.7,
    }
    return weights[segment]


def segment_quantity_range(segment: str) -> tuple[int, int]:
    ranges = {
        "VIP": (1, 6),
        "Loyal": (1, 5),
        "Regular": (1, 4),
        "Occasional": (1, 3),
        "At Risk": (1, 2),
    }
    return ranges[segment]


def segment_discount_range(segment: str) -> tuple[float, float]:
    ranges = {
        "VIP": (0.00, 0.20),
        "Loyal": (0.00, 0.15),
        "Regular": (0.00, 0.10),
        "Occasional": (0.00, 0.08),
        "At Risk": (0.00, 0.12),
    }
    return ranges[segment]


def generate_dataset() -> pd.DataFrame:
    random.seed(SEED)

    customers_df = build_customers()
    products = build_products()

    customer_records = customers_df.to_dict(orient="records")
    customer_weights = [segment_order_weight(row["segment"]) for row in customer_records]

    rows = []

    for row_num in range(1, N_ROWS + 1):
        customer = random.choices(customer_records, weights=customer_weights, k=1)[0]
        product = random.choice(products)

        min_qty, max_qty = segment_quantity_range(customer["segment"])
        quantity = random.randint(min_qty, max_qty)

        price_noise = random.uniform(0.85, 1.20)
        unit_price = round(product.base_price * price_noise, 2)

        min_discount, max_discount = segment_discount_range(customer["segment"])
        discount_pct = round(random.uniform(min_discount, max_discount), 4)

        gross_revenue = round(quantity * unit_price, 2)
        net_revenue = round(gross_revenue * (1 - discount_pct), 2)

        order_date = random_order_date()
        order_id = f"O{row_num:07d}"

        rows.append(
            {
                "order_id": order_id,
                "order_date": order_date.strftime("%Y-%m-%d"),
                "customer_id": customer["customer_id"],
                "country": customer["country"],
                "product_id": product.product_id,
                "product_name": product.product_name,
                "category": product.category,
                "quantity": quantity,
                "unit_price": unit_price,
                "discount_pct": discount_pct,
                "gross_revenue": gross_revenue,
                "net_revenue": net_revenue,
            }
        )

    df = pd.DataFrame(rows).sort_values(["order_date", "order_id"]).reset_index(drop=True)
    return df


def main() -> None:
    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)

    df = generate_dataset()
    df.to_csv(OUTPUT_PATH, index=False)

    print(f"Dataset generated successfully: {OUTPUT_PATH}")
    print(f"Rows: {len(df):,}")
    print(f"Columns: {len(df.columns)}")
    print("\nSample:")
    print(df.head())


if __name__ == "__main__":
    main()