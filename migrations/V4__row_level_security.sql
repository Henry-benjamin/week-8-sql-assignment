-- =====================================================
-- V4__row_level_security.sql: Row-Level Security (RLS)
-- =====================================================

-- 1. Enable RLS on multi-tenant tables
ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;

-- 2. Policy for Accounts: Users can only access their own accounts
CREATE POLICY accounts_isolation_policy ON accounts
    FOR ALL
    USING (user_id = NULLIF(current_setting('app.current_user_id', true), '')::INT)
    WITH CHECK (user_id = NULLIF(current_setting('app.current_user_id', true), '')::INT);

-- 3. Policy for Categories: Users can access global categories (user_id IS NULL) or their own custom categories
CREATE POLICY categories_isolation_policy ON categories
    FOR ALL
    USING (
        user_id IS NULL 
        OR user_id = NULLIF(current_setting('app.current_user_id', true), '')::INT
    )
    WITH CHECK (
        user_id = NULLIF(current_setting('app.current_user_id', true), '')::INT
    );

-- 4. Policy for Transactions: Users can only access transactions belonging to their own accounts
CREATE POLICY transactions_isolation_policy ON transactions
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM accounts 
            WHERE accounts.id = transactions.account_id 
              AND accounts.user_id = NULLIF(current_setting('app.current_user_id', true), '')::INT
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM accounts 
            WHERE accounts.id = transactions.account_id 
              AND accounts.user_id = NULLIF(current_setting('app.current_user_id', true), '')::INT
        )
    );

-- 5. Policy for Budgets: Users can only access their own budgets
CREATE POLICY budgets_isolation_policy ON budgets
    FOR ALL
    USING (user_id = NULLIF(current_setting('app.current_user_id', true), '')::INT)
    WITH CHECK (user_id = NULLIF(current_setting('app.current_user_id', true), '')::INT);