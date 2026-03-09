from __future__ import annotations

import sqlite3
from pathlib import Path

import pandas as pd


BASE_DIR = Path(__file__).resolve().parents[1]
CSV_PATH = BASE_DIR / "data" / "raw" / "customer_transactions.csv"
DB_PATH = BASE_DIR / "data" / "processed" / "customer_analytics.db"

EXPECTED_COLUMNS = [
    "order_id",
    "order_date",
    "customer_id",
    "country",
    "product_id",
    "product_name",
    "category",
    "quantity",
    "unit_price",
    "discount_pct",
    "gross_revenue",
    "net_revenue",
]


def validate_source_file() -> None:
    if not CSV_PATH.exists():
        raise FileNotFoundError(
            f"Source CSV not found at: {CSV_PATH}. "
            "Run scripts/generate_dataset.py first."
        )


def validate_columns(df: pd.DataFrame) -> None:
    missing_columns = [col for col in EXPECTED_COLUMNS if col not in df.columns]
    extra_columns = [col for col in df.columns if col not in EXPECTED_COLUMNS]

    if missing_columns:
        raise ValueError(f"Missing expected columns: {missing_columns}")

    if extra_columns:
        print(f"Warning: extra columns found and will be preserved: {extra_columns}")


def enforce_types(df: pd.DataFrame) -> pd.DataFrame:
    typed_df = df.copy()

    typed_df["order_id"] = typed_df["order_id"].astype(str)
    typed_df["order_date"] = pd.to_datetime(typed_df["order_date"]).dt.strftime("%Y-%m-%d")
    typed_df["customer_id"] = typed_df["customer_id"].astype(str)
    typed_df["country"] = typed_df["country"].astype(str)
    typed_df["product_id"] = typed_df["product_id"].astype(str)
    typed_df["product_name"] = typed_df["product_name"].astype(str)
    typed_df["category"] = typed_df["category"].astype(str)

    typed_df["quantity"] = typed_df["quantity"].astype(int)
    typed_df["unit_price"] = typed_df["unit_price"].astype(float)
    typed_df["discount_pct"] = typed_df["discount_pct"].astype(float)
    typed_df["gross_revenue"] = typed_df["gross_revenue"].astype(float)
    typed_df["net_revenue"] = typed_df["net_revenue"].astype(float)

    return typed_df


def create_table(conn: sqlite3.Connection) -> None:
    conn.execute("DROP TABLE IF EXISTS customer_transactions;")

    conn.execute(
        """
        CREATE TABLE customer_transactions (
            order_id TEXT NOT NULL,
            order_date TEXT NOT NULL,
            customer_id TEXT NOT NULL,
            country TEXT NOT NULL,
            product_id TEXT NOT NULL,
            product_name TEXT NOT NULL,
            category TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            unit_price REAL NOT NULL,
            discount_pct REAL NOT NULL,
            gross_revenue REAL NOT NULL,
            net_revenue REAL NOT NULL
        );
        """
    )

    conn.commit()


def create_indexes(conn: sqlite3.Connection) -> None:
    index_statements = [
        "CREATE INDEX IF NOT EXISTS idx_ct_order_date ON customer_transactions(order_date);",
        "CREATE INDEX IF NOT EXISTS idx_ct_customer_id ON customer_transactions(customer_id);",
        "CREATE INDEX IF NOT EXISTS idx_ct_category ON customer_transactions(category);",
        "CREATE INDEX IF NOT EXISTS idx_ct_product_id ON customer_transactions(product_id);",
    ]

    for stmt in index_statements:
        conn.execute(stmt)

    conn.commit()


def load_data(conn: sqlite3.Connection, df: pd.DataFrame) -> None:
    df.to_sql("customer_transactions", conn, if_exists="append", index=False)


def run_basic_checks(conn: sqlite3.Connection) -> dict[str, object]:
    total_rows = conn.execute(
        "SELECT COUNT(*) FROM customer_transactions;"
    ).fetchone()[0]

    date_range = conn.execute(
        """
        SELECT MIN(order_date), MAX(order_date)
        FROM customer_transactions;
        """
    ).fetchone()

    distinct_customers = conn.execute(
        "SELECT COUNT(DISTINCT customer_id) FROM customer_transactions;"
    ).fetchone()[0]

    distinct_products = conn.execute(
        "SELECT COUNT(DISTINCT product_id) FROM customer_transactions;"
    ).fetchone()[0]

    return {
        "total_rows": total_rows,
        "min_date": date_range[0],
        "max_date": date_range[1],
        "distinct_customers": distinct_customers,
        "distinct_products": distinct_products,
    }


def main() -> None:
    validate_source_file()

    df = pd.read_csv(CSV_PATH)
    validate_columns(df)
    df = enforce_types(df)

    DB_PATH.parent.mkdir(parents=True, exist_ok=True)

    with sqlite3.connect(DB_PATH) as conn:
        create_table(conn)
        load_data(conn, df)
        create_indexes(conn)

        checks = run_basic_checks(conn)

    print(f"SQLite database created successfully: {DB_PATH}")
    print(f"Rows loaded: {checks['total_rows']:,}")
    print(f"Date range: {checks['min_date']} to {checks['max_date']}")
    print(f"Distinct customers: {checks['distinct_customers']:,}")
    print(f"Distinct products: {checks['distinct_products']:,}")


if __name__ == "__main__":
    main()