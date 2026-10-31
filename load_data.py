import sqlite3
import sys
from pathlib import Path

import pandas as pd

TABLES = {
    "orders": "olist_orders_dataset.csv",
    "customers": "olist_customers_dataset.csv",
    "order_items": "olist_order_items_dataset.csv",
    "order_payments": "olist_order_payments_dataset.csv",
    "order_reviews": "olist_order_reviews_dataset.csv",
    "products": "olist_products_dataset.csv",
    "sellers": "olist_sellers_dataset.csv",
    "category_translation": "product_category_name_translation.csv",
}


def main(data_dir="data", db_path="olist.db"):
    data_dir = Path(data_dir)
    with sqlite3.connect(db_path) as conn:
        for table, filename in TABLES.items():
            df = pd.read_csv(data_dir / filename)
            df.to_sql(table, conn, if_exists="replace", index=False)
            print(f"{table}: {len(df):,} rows")
        conn.executescript(
            """
            CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders(customer_id);
            CREATE INDEX IF NOT EXISTS idx_items_order     ON order_items(order_id);
            CREATE INDEX IF NOT EXISTS idx_items_product   ON order_items(product_id);
            CREATE INDEX IF NOT EXISTS idx_payments_order  ON order_payments(order_id);
            CREATE INDEX IF NOT EXISTS idx_reviews_order   ON order_reviews(order_id);
            """
        )


if __name__ == "__main__":
    main(*sys.argv[1:])
