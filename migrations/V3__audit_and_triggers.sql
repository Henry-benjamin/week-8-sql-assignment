-- =====================================================
-- V3__audit_and_triggers.sql: Audit Logging & Triggers
-- =====================================================

-- 1. Create a generic audit function to capture row changes
CREATE OR REPLACE FUNCTION log_audit_event()
RETURNS TRIGGER AS $$
DECLARE
    current_user_id INT;
BEGIN
    -- Attempt to retrieve user_id from session context if available, otherwise null
    BEGIN
        current_user_id := current_setting('app.current_user_id', true)::INT;
    EXCEPTION WHEN OTHERS THEN
        current_user_id := NULL;
    END;

    IF (TG_OP = 'INSERT') THEN
        INSERT INTO audit_logs (user_id, action, table_name, old_data, new_data)
        VALUES (current_user_id, 'INSERT', TG_TABLE_NAME, NULL, to_jsonb(NEW));
        RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO audit_logs (user_id, action, table_name, old_data, new_data)
        VALUES (current_user_id, 'UPDATE', TG_TABLE_NAME, to_jsonb(OLD), to_jsonb(NEW));
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO audit_logs (user_id, action, table_name, old_data, new_data)
        VALUES (current_user_id, 'DELETE', TG_TABLE_NAME, to_jsonb(OLD), NULL);
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 2. Apply audit trigger to the accounts table
CREATE TRIGGER audit_accounts_changes
AFTER INSERT OR UPDATE OR DELETE ON accounts
FOR EACH ROW EXECUTE FUNCTION log_audit_event();

-- 3. Apply audit trigger to the transactions table
CREATE TRIGGER audit_transactions_changes
AFTER INSERT OR UPDATE OR DELETE ON transactions
FOR EACH ROW EXECUTE FUNCTION log_audit_event();