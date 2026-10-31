import re
import sqlite3
import sys

import pandas as pd


def split_queries(sql_text):
    blocks = re.split(r"\n(?=-- Q\d+\.)", sql_text.strip())
    for block in blocks:
        title, _, body = block.partition("\n")
        yield title.lstrip("- ").strip(), body.strip().rstrip(";")


def format_value(value):
    if pd.isna(value):
        return ""
    if isinstance(value, float):
        if round(value, 2) == 0:
            return "0"
        return f"{value:,.0f}" if value.is_integer() and abs(value) >= 1000 else f"{value:,.2f}".rstrip("0").rstrip(".")
    if isinstance(value, int):
        return f"{value:,}"
    return str(value)


def format_table(df):
    return df.apply(lambda col: col.map(format_value)).to_markdown(index=False, disable_numparse=True)


def main(db_path="olist.db", sql_path="queries.sql", out_path="results.md"):
    with open(sql_path, encoding="utf-8") as f:
        sql_text = f.read()
    sections = ["# Query results\n"]
    with sqlite3.connect(db_path) as conn:
        for title, query in split_queries(sql_text):
            df = pd.read_sql_query(query, conn)
            sections.append(f"## {title}\n\n{format_table(df)}\n")
    with open(out_path, "w", encoding="utf-8") as f:
        f.write("\n".join(sections))
    print(f"wrote {out_path}")


if __name__ == "__main__":
    main(*sys.argv[1:])
