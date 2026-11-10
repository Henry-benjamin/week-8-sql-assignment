-- =====================================================
-- V5__seed_demo_data.sql: Demo Seed Data
-- =====================================================

-- 1. Insert a default demo user
INSERT INTO users (id, email, password_hash, full_name, role) VALUES 
(1, 'demo.user@spendwise.com', '$2b$12$eXampleHashedPasswordString123456789', 'Henry Benjamin', 'user');

-- 2. Insert global system categories (user_id IS NULL) and custom user categories
INSERT INTO categories (id, user_id, category_name, icon) VALUES 
(1, NULL, 'Salary & Income', 'briefcase'),
(2, NULL, 'Housing & Rent', 'home'),
(3, NULL, 'Groceries & Food', 'shopping-cart'),
(4, NULL, 'Utilities & Bills', 'zap'),
(5, 1, 'Freelance Projects', 'code');

-- 3. Insert sample financial accounts for our demo user
INSERT INTO accounts (id, user_id, account_name, account_type, balance) VALUES 
(1, 1, 'Primary Checking', 'checking', 3450.00),
(2, 1, 'Savings Vault', 'savings', 8200.00),
(3, 1, 'Credit Card', 'credit', -450.00);

-- 4. Insert monthly budgets for the demo user
INSERT INTO budgets (user_id, category_id, monthly_limit, month_year) VALUES 
(1, 2, 1200.00, '2026-11'),
(1, 3, 500.00, '2026-11'),
(1, 4, 250.00, '2026-11');

-- 5. Insert sample transactions
INSERT INTO transactions (account_id, category_id, amount, merchant, notes) VALUES 
(1, 1, 3000.00, 'Tech Corp', 'Monthly salary deposit'),
(1, 3, -85.50, 'Supermarket', 'Weekly groceries'),
(1, 4, -120.00, 'Power Utility', 'Electricity bill'),
(3, 3, -45.00, 'Coffee Shop', 'Client meetings');