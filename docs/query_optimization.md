# SpendWise Enterprise - Query Optimization Evidence (Step 4)

This document records performance profiling and optimization using PostgreSQL's `EXPLAIN ANALYZE` for heavy financial aggregation queries.

## Target Query: Monthly Category Expenditure Summary

Calculates aggregate monthly spending per category for budget tracking dashboards.

### Before Optimization (Sequential Scan)

- **Execution Plan:**

  ```text Seq Scan on transactions  (cost=0.00..1425.00 rows=50000 width=36)
  Filter: (transaction_date >= '2026-11-01' AND transaction_date <= '2026-11-30')
  Execution Time: 850.412 ms
  ```
