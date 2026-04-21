# data/

Seed files referenced by `Setup.ipynb`.

All tabular data is generated synthetically at runtime via Spark (see `../Setup.ipynb`
and `../notebooks/`), so this folder stays intentionally small and human-readable.

| File | Purpose |
|------|---------|
| (generated at runtime) `Files/raw/sales_orders.csv` | CSV slice of orders used by Module 4 bronze demo. Written by `Setup.ipynb`. |
| (generated at runtime) `Files/orders_parquet/` | Partitioned parquet copy of the orders table, used by Module 1 file-layout demos. |

If you want to distribute a fixed CSV with the repo instead of generating one, drop it
here and flip `GENERATE_RAW_CSV = False` in `Setup.ipynb`.
