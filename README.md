# SpendWise Enterprise

Multi-Tenant Financial Analytics & Transaction Management Engine

## Overview

**SpendWise Enterprise** is a secure, high-performance transactional and analytical platform designed for multi-tenant financial tracking. It combines a strictly normalized relational database (PostgreSQL) with automated auditing, Row-Level Security (RLS), versioned schema migrations (Flyway), and a high-speed caching layer (Redis).

---

## Table of Contents

1. Step 1: Requirements & ER Diagram(#step-1-requirements--er-diagram)
2. Step 2: Schema as Migrations(#step-2-schema-as-migrations)
3. Step 3: NoSQL Layer Redis(#step-3-nosql-layer-redis)
4. Step 4: Query Optimization Evidence(#step-4-query-optimization-evidence)
5. Step 5: Backup & Security Artifacts(#step-5-backup--security-artifacts)

---

## Step 1: Requirements & ER Diagram

### 1. Requirements Summary

- **Project Title:** SpendWise Enterprise
- **Domain:** FinTech / Personal & Small Business Financial Analytics
- **Core Objective:** Provide a secure, high-performance transactional and analytical platform where multi-tenant users can manage multiple accounts, categorize expenses, track budgets, and view real-time aggregated financial health metrics.
- **Key Functional Requirements:**
  1. **User Management & Authentication:** Secure registration, profile management, and role-based permissions (Standard User vs. Admin).
  2. **Multi-Account & Transaction Processing:** Support for multiple financial accounts (Checking, Savings, Credit Cards) with detailed transaction logging (amounts, categories, merchant info, timestamps).
  3. **Budget Tracking:** Automated monthly spending limits per category with threshold monitoring.
  4. **Compliance & Auditing:** Immutable audit trail capturing sensitive data modifications via automated triggers and JSONB logs.
- **Non-Functional Requirements:**
  - **Data Security:** Strict data isolation between users enforced via PostgreSQL Row-Level Security (RLS).
  - **Performance:** Optimized query indexes on foreign keys and date ranges to ensure rapid analytical reporting.
  - **Scalability:** Integration of a NoSQL (Redis) caching layer to handle session state and transaction buffering.

---

### 2. Entity-Relationship (ER) Design

#### Entities & Attributes

1. **`users`**
   - `id` (PK, SERIAL)
   - `email` (VARCHAR, Unique)
   - `password_hash` (VARCHAR)
   - `full_name` (VARCHAR)
   - `role` (VARCHAR)
   - `created_at` (TIMESTAMP)

2. **`accounts`**
   - `id` (PK, SERIAL)
   - `user_id` (FK referencing `users.id`)
   - `account_name` (VARCHAR)
   - `account_type` (VARCHAR)
   - `balance` (DECIMAL)
   - `created_at` (TIMESTAMP)

3. **`categories`**
   - `id` (PK, SERIAL)
   - `user_id` (FK referencing `users.id`, Nullable for global categories)
   - `category_name` (VARCHAR)
   - `icon` (VARCHAR)

4. **`transactions`**
   - `id` (PK, SERIAL)
   - `account_id` (FK referencing `accounts.id`)
   - `category_id` (FK referencing `categories.id`)
   - `amount` (DECIMAL)
   - `transaction_date` (TIMESTAMP)
   - `merchant` (VARCHAR)
   - `notes` (TEXT)

5. **`budgets`**
   - `id` (PK, SERIAL)
   - `user_id` (FK referencing `users.id`)
   - `category_id` (FK referencing `categories.id`)
   - `monthly_limit` (DECIMAL)
   - `month_year` (VARCHAR)

6. **`audit_logs`**
   - `id` (PK, SERIAL)
   - `user_id` (FK referencing `users.id`)
   - `action` (VARCHAR)
   - `table_name` (VARCHAR)
   - `old_data` (JSONB)
   - `new_data` (JSONB)
   - `performed_at` (TIMESTAMP)

#### Relationships & Cardinalities

- **`users` 1 : N `accounts`** — One user can own multiple financial accounts.
- **`accounts` 1 : N `transactions`** — One account holds many financial transaction records.
- **`categories` 1 : N `transactions`** — A category classifies multiple transactions.
- **`users` 1 : N `budgets`** — One user can define multiple monthly category budgets.
- **`categories` 1 : N `budgets`** — A category can have associated budget rules across periods.
- **`users` 1 : N `audit_logs`** — User actions trigger logged records for compliance auditing.

---

## Step 2: Schema as Migrations

Database evolution is managed via ordered, repeatable Flyway scripts located in `migrations/`:

1. **`V1__core_tables.sql`** – Establishes core entities (`users`, `accounts`, `categories`, `transactions`, `budgets`, `audit_logs`).
2. **`V2__indexes.sql`** – Creates performance indexes on foreign keys and date filters.
3. **`V3__audit_and_triggers.sql`** – Implements automated JSONB change-tracking triggers.
4. **`V4__row_level_security.sql`** – Enforces tenant-level data isolation policies.
5. **`V5__seed_demo_data.sql`** – Populates initial test data for verification.

To build the database schema from scratch:

```bash
flyway clean migrate
```
