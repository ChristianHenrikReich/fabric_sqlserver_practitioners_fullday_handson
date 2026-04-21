/*
  Module 3 Exercise: The Warehouse Reading Silver

  Run this in SSMS (or Azure Data Studio) connected to the SQL endpoint of your
  silver lakehouse. The tables below are the same Delta tables Spark wrote in
  modules 1 and 2. No ETL, no copy, same storage.

  Default database: silver (the lakehouse SQL endpoint).
*/


-- 1. Read what Spark wrote --------------------------------------------------
-- These are Delta tables, surfaced as T-SQL tables via the SQL endpoint.

SELECT TOP (10) * FROM dbo.customers;
SELECT TOP (10) * FROM dbo.orders;


-- 2. Constant folding, the T-SQL version ------------------------------------
-- Same rewrite Catalyst did in module_2_2_Catalyst.ipynb, now in the
-- Warehouse's SQL Server-lineage optimiser. Turn on the estimated plan button
-- in SSMS (Ctrl+L), then run the query. In the plan XML, the Compute Scalar
-- operator shows the expression already folded to (quantity + 6).

SET SHOWPLAN_XML ON;
GO
SELECT (quantity + 1 + 2 + 3) AS quantity
FROM   dbo.orders
WHERE  year = 2025;
GO
SET SHOWPLAN_XML OFF;
GO


-- 3. A distributed plan -----------------------------------------------------
-- Same query shape you know, new operators. Look for Shuffle / Distribute /
-- Broadcast steps: that is the Warehouse engine deciding how to move data
-- between compute nodes. SQL Server single-box plans never had those.

SELECT c.country,
       COUNT(*)     AS orders,
       SUM(o.total) AS revenue
FROM   dbo.orders    AS o
JOIN   dbo.customers AS c ON c.id = o.customer_id
WHERE  o.year = 2025
GROUP BY c.country
ORDER BY revenue DESC;


-- 4. Observability ----------------------------------------------------------
-- queryinsights is the Warehouse equivalent of sys.dm_exec_query_stats. Every
-- query you just ran is here, with duration, rows, and the plan hash.

SELECT TOP (20)
       start_time,
       status,
       total_elapsed_time_ms,
       command
FROM   queryinsights.exec_requests_history
ORDER BY start_time DESC;


/*
  Key takeaway

  The Warehouse runs T-SQL against the same Delta tables Spark wrote, through
  a SQL Server-lineage optimiser that does the same classes of rewrites
  (constant folding, predicate pushdown) you already rely on. The plan reads
  the same way, with a few new distributed operators. Your SSMS muscle memory
  transfers directly; the storage layer is what changed, not the query engine
  you're talking to.
*/
