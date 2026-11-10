-- =====================================================
-- V2__indexes.sql: SpendWise Enterprise Performance Indexes
-- =====================================================

-- 1. Index on user_id for accounts lookup optimization
CREATE INDEX idx_accounts_user_id ON accounts(user_id);

-- 2. Index on account_id and transaction_date for fast transaction filtering and pagination
CREATE INDEX idx_transactions_account_date ON transactions(account_id, transaction_date DESC);

-- 3. Index on category_id for category-based spending reports
CREATE INDEX idx_transactions_category_id ON transactions(category_id);

-- 4. Index on merchant name for quick search functionality
CREATE INDEX idx_transactions_merchant ON transactions(merchant);

-- 5. Composite index for budgets lookup by user and period
CREATE INDEX idx_budgets_user_month ON budgets(user_id, month_year);

-- 6. Index on audit_logs user and timestamp for security compliance tracking
CREATE INDEX idx_audit_logs_user_time ON audit_logs(user_id, performed_at DESC);