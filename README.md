# Workshop Prerequisite: Adapting to Microsoft Fabric

This repo provisions what attendees need for the SQLBits 2026 full-day workshop
**"Adapting to Microsoft Fabric: A SQL Server Practitioner's Way Forward"**.

> Repo name: *TBD*. A public companion repo will be published before the workshop.

## What `Setup.ipynb` does

1. Creates two Lakehouses and one Warehouse in the current workspace:
   `bronze` (Lakehouse), `silver` (Lakehouse), `gold` (Warehouse).
   Existing items with the same name are reused, so the notebook is safe to
   re-run. Lakehouses are created via `notebookutils.lakehouse.create`; the
   warehouse is created via `sempy_labs.warehouse.create_warehouse` because
   `notebookutils` does not yet expose a warehouse API.
2. Pulls the workshop notebooks from this GitHub repo into your workspace, each
   pre-bound to `silver` as the default Lakehouse:

   | Notebook | Default Lakehouse |
   |---|---|
   | `module_0_1_DataBuilder.ipynb` | `silver` |
   | `module_1_1_TimeTravel.ipynb` | `silver` |
   | `module_1_2_Optimize.ipynb` | `silver` |
   | `module_2_1_Language.ipynb` | `silver` |
   | `module_2_2_Catalyst.ipynb` | `silver` |
   | `module_2_3_Optimizing.ipynb` | `silver` |
   | `module_3_1_restore_point.ipynb` | `silver` |
   | `module_3_2_Interoperability.ipynb` | `silver` |

3. Runs `module_0_1_DataBuilder` so the source data is ready before the workshop starts:

   | Artefact                               | Notes                                                   |
   |----------------------------------------|---------------------------------------------------------|
   | `customers` (Delta table)              | 10M rows written in 15 append transactions              |
   | `orders` (Delta table, partitioned)    | 50M rows in 22 append transactions, partitioned y/m/d   |
   | `Files/orders_parquet/`                | Partitioned parquet copy of orders (Module 1 demos)     |
   | `Files/raw/sales_orders.csv`           | CSV slice used by the Module 4 capstone                 |

The multi-commit append pattern (15 / 22 transactions) is intentional: it gives
Module 1 a realistic Delta log for `VERSION AS OF` and `TIMESTAMP AS OF` demos.

## Installation

### Easiest

1. Create a Fabric workspace (trial or licensed capacity).
2. Create a new notebook in that workspace.
3. Copy the code cell from [`Setup.ipynb`](Setup.ipynb) into your notebook.
4. **Run all**.

### Alternative

1. Create a Fabric workspace.
2. Download `Setup.ipynb` from GitHub.
3. Import it into your workspace.
4. **Run all**.

Either way, attendees only ever touch `Setup.ipynb`. Everything else is pulled in
automatically.

Expect roughly 10–20 minutes on a starter Spark pool.

## Structure

```
prerequisite/
├── Setup.ipynb                        ← one-click entry point (lakehouses + notebook imports + DataBuilder)
├── notebooks/
│   ├── module_0_1_DataBuilder.ipynb   ← generates customers + orders + file copies
│   ├── module_1_1_TimeTravel.ipynb    ← Module 1 exercise (DESCRIBE HISTORY, VERSION AS OF)
│   ├── module_1_2_Optimize.ipynb      ← Module 1 exercise (OPTIMIZE, ZORDER, VACUUM)
│   ├── module_2_1_Language.ipynb      ← Module 2 exercise (Spark SQL vs DataFrame EXPLAIN)
│   ├── module_2_2_Catalyst.ipynb      ← Module 2 exercise (EXPLAIN EXTENDED, all four Catalyst stages)
│   ├── module_2_3_Optimizing.ipynb    ← Module 2 exercise (BROADCAST hint: SMJ vs BroadcastHashJoin)
│   ├── module_3_1_restore_point.ipynb ← Module 3 exercise (create_restore_point via semantic-link-labs)
│   └── module_3_2_Interoperability.ipynb ← Module 3 exercise (Spark → Warehouse via synapsesql)
├── sql/
│   └── module_3_1_Warehouse.sql       ← Module 3 exercise (run in SSMS against the silver SQL endpoint)
├── data/
│   └── README.md                      ← notes on the generated data shape
├── README.md
└── LICENSE                            ← MIT
```

## Troubleshooting

* **Session timeout during generation** : the data volume is deliberate. If the
  Spark session dies mid-run, just re-run `Setup.ipynb`; it creates-or-gets the
  lakehouses, re-imports the notebooks, and DataBuilder overwrites cleanly on its
  first batch.
* **Notebook import failed** : check that the workspace has Fabric items enabled
  and that your capacity is assigned. `notebookutils.notebook.create` needs a
  Fabric-backed workspace, not a Power BI Pro one.
* **Wanting a smaller dataset** : edit the two constants at the top of
  `notebooks/module_0_1_DataBuilder.ipynb` **after** Setup has imported it:
  `NUM_CUSTOMERS` and `NUM_ORDERS`. Then run the imported DataBuilder notebook
  directly.

## Licence

MIT. See [LICENSE](LICENSE).
