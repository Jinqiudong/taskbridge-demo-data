-- ============================================================
-- TABLE: raw_applications
-- Owner: Data Engineering (Tech Team)
-- Description: Raw application records ingested from upstream
--              lending platform. Each row represents one credit
--              card or loan application submitted by a customer.
-- ============================================================

CREATE TABLE raw_applications (
    app_id          VARCHAR(20)     NOT NULL,   -- Unique application ID
    customer_id     VARCHAR(20)     NOT NULL,   -- Customer identifier
    application_dt  DATE            NOT NULL,   -- Date application was submitted
    product_type    VARCHAR(50),                -- Product line: 'CREDIT_CARD', 'PERSONAL_LOAN', 'AUTO_LOAN'
                                                -- WARNING: This field can be NULL if upstream feed fails
    credit_score    INT,                        -- FICO credit score at time of application
    annual_income   DECIMAL(12,2),              -- Self-reported annual income in USD
    requested_amount DECIMAL(12,2), -- Loan or credit limit amount requested
    state           VARCHAR(2),                 -- US state code of applicant
    channel         VARCHAR(20),                -- Acquisition channel: 'ONLINE', 'BRANCH', 'PARTNER'
    raw_status      VARCHAR(20),                -- Raw decision from underwriting system
    ingested_at     TIMESTAMP       NOT NULL    -- When this record was loaded into the warehouse
);

-- ============================================================
-- KNOWN DATA ISSUES
-- ============================================================
-- 1. product_type can be NULL when upstream feed sends incomplete
--    payloads. This causes downstream join failures in da_approval_metrics.
--    Affected date range: 2026-06-02 to 2026-06-08 (2,847 records)
--
-- 2. credit_score occasionally arrives as 0 instead of NULL
--    for applicants with no credit history. Filter with > 300.
-- ============================================================
