---
tags: [finances, supabase, database, schema, plaid]
category: finances
last_updated: 2026-09-21
status: active
---

# Supabase Tables

Database schema for automated finance tracking system.

**Database:** Supabase PostgreSQL  
**Connection:** `SUPABASE_DB_URL` environment variable

**Status:** 🟢 **Active and in use** (Sep 2026)

---

## expense_transactions

**Purpose:** All categorized expenses from Chase accounts

**Status:** 🟢 **Active**

**Schema:**

```sql
CREATE TABLE expense_transactions (
  id SERIAL PRIMARY KEY,
  transaction_date DATE NOT NULL,
  posting_date DATE,
  description TEXT NOT NULL,
  category VARCHAR(100) NOT NULL,
  type VARCHAR(50),
  amount DECIMAL(10, 2) NOT NULL,
  balance DECIMAL(10, 2),
  account VARCHAR(20) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Composite unique constraint to prevent duplicates
CREATE UNIQUE INDEX idx_expense_unique 
  ON expense_transactions(account, transaction_date, amount, description);

-- Unique index on Plaid transaction id (added 2026-09-21 for Plaid auto-pull).
-- Manual rows keep NULL plaid_transaction_id; Plaid rows upsert on this key.
CREATE UNIQUE INDEX idx_expense_plaid_transaction_id
  ON expense_transactions(plaid_transaction_id)
  WHERE plaid_transaction_id IS NOT NULL;

-- Index for faster queries by date and category
CREATE INDEX idx_expense_date ON expense_transactions(transaction_date);
CREATE INDEX idx_expense_category ON expense_transactions(category);
CREATE INDEX idx_expense_account ON expense_transactions(account);
```

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `id` | SERIAL | Auto-incrementing primary key |
| `transaction_date` | DATE | Date transaction occurred |
| `posting_date` | DATE | Date transaction posted to account |
| `description` | TEXT | Transaction description from bank |
| `category` | VARCHAR(100) | Categorized expense type (via pattern matching) |
| `type` | VARCHAR(50) | Transaction type (Sale, Payment, Adjustment, etc.) |
| `amount` | DECIMAL(10,2) | Transaction amount (negative for expenses, positive for income) |
| `balance` | DECIMAL(10,2) | Account balance after transaction |
| `account` | VARCHAR(20) | Chase account number (6813, 5113, 4433) |
| `created_at` | TIMESTAMPTZ | Timestamp when record was inserted |

**Common Categories:**
- Fixed Costs: Mortgage, HOA, Utilities (Electric, Internet), Insurance, MTA
- Discretionary: Groceries, Dining, Transportation (Uber), Shopping, Entertainment, Gym
- Income: Payroll, Transfers
- Miscellaneous: Uncategorized transactions

**Sample Data:**

```sql
INSERT INTO expense_transactions 
  (transaction_date, description, category, amount, account)
VALUES
  ('2026-09-01', 'CHASE MORTGAGE', 'Fixed Costs', -3683.44, '6813'),
  ('2026-09-01', 'HOA PAYMENT', 'Fixed Costs', -505.00, '6813'),
  ('2026-09-05', 'WHOLEFDS BKN', 'Groceries', -45.23, '5113'),
  ('2026-09-10', 'UBER *TRIP', 'Transportation', -18.50, '5113'),
  ('2026-09-15', 'PAYROLL DEPOSIT', 'Income', 2683.31, '6813');
```

**Queries:**

**Monthly summary by category:**
```sql
SELECT 
  category,
  SUM(amount) as total_amount,
  COUNT(*) as transaction_count
FROM expense_transactions
WHERE transaction_date >= '2026-09-01' 
  AND transaction_date < '2026-10-01'
  AND amount < 0  -- expenses only
GROUP BY category
ORDER BY total_amount;
```

**Net remaining for a month:**
```sql
SELECT 
  SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) as income,
  SUM(CASE WHEN amount < 0 THEN ABS(amount) ELSE 0 END) as expenses,
  SUM(amount) as net_remaining
FROM expense_transactions
WHERE transaction_date >= '2026-09-01' 
  AND transaction_date < '2026-10-01';
```

**Uncategorized transactions needing rules:**
```sql
SELECT DISTINCT description
FROM expense_transactions
WHERE category = 'Miscellaneous'
ORDER BY description;
```

---

## plaid_sync_state

**Purpose:** Cursor for Plaid `/transactions/sync`, one row per Plaid Item.
Stored server-side because the GitHub Actions runner is stateless.

**Status:** 🟢 **Active** (added 2026-09-21)

**Schema:**

```sql
CREATE TABLE plaid_sync_state (
  item_id TEXT PRIMARY KEY,
  cursor TEXT,
  institution_name TEXT,
  last_synced_at TIMESTAMPTZ
);
```

| Column | Type | Description |
|--------|------|-------------|
| `item_id` | TEXT | Plaid Item id (PK) |
| `cursor` | TEXT | `/transactions/sync` cursor, advances each run |
| `institution_name` | TEXT | e.g. "Chase" |
| `last_synced_at` | TIMESTAMPTZ | Timestamp of most recent successful sync |

**Written by:** `finances/plaid_sync.py` (daily) and `finances/plaid_link.py` (initial row).

---

## plaid_accounts

**Purpose:** Map Plaid `account_id` -> the `source` code used in
`expense_transactions` (checking / cc_5113 / cc_4433), plus masked metadata.
Full account numbers are never stored - only the last 4 (`mask`).

**Status:** 🟢 **Active** (added 2026-09-21)

**Schema:**

```sql
CREATE TABLE plaid_accounts (
  account_id TEXT PRIMARY KEY,
  item_id TEXT,
  name TEXT,
  official_name TEXT,
  mask TEXT,
  type TEXT,
  subtype TEXT,
  source_code TEXT,
  updated_at TIMESTAMPTZ
);
```

| Column | Type | Description |
|--------|------|-------------|
| `account_id` | TEXT | Plaid account id (PK) |
| `item_id` | TEXT | Parent Plaid Item |
| `name` | TEXT | Chase display name |
| `official_name` | TEXT | Chase official name |
| `mask` | TEXT | Last 4 of account number only |
| `type` | TEXT | Plaid account type (e.g. depository, credit) |
| `subtype` | TEXT | Plaid account subtype (e.g. checking, credit card) |
| `source_code` | TEXT | Maps to `expense_transactions.source`: `checking`, `cc_5113`, `cc_4433` |
| `updated_at` | TIMESTAMPTZ | Last self-heal from `/accounts/get` |

**Written by:** `finances/plaid_sync.py` (self-heals on every daily run) and
`finances/plaid_link.py` (initial rows on link).

---

## category_mapping

**Purpose:** Pattern matching rules for auto-categorizing transactions

**Status:** 🟢 **Active**

**Recent additions (2026-09-21):** `TST*` and `AWESOME DELI` -> `Dining`,
`AMAZON` -> `Shopping`, `INTEREST CHARGE` -> new `Fees` category.

**Schema:**

```sql
CREATE TABLE category_mapping (
  id SERIAL PRIMARY KEY,
  pattern VARCHAR(255) NOT NULL,
  category VARCHAR(100) NOT NULL,
  pattern_type VARCHAR(20) NOT NULL CHECK (pattern_type IN ('contains', 'starts_with', 'ends_with', 'exact')),
  priority INT NOT NULL DEFAULT 50,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for faster pattern matching
CREATE INDEX idx_category_pattern ON category_mapping(pattern);
CREATE INDEX idx_category_priority ON category_mapping(priority DESC);
```

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `id` | SERIAL | Auto-incrementing primary key |
| `pattern` | VARCHAR(255) | Text pattern to match in transaction description |
| `category` | VARCHAR(100) | Category to assign if pattern matches |
| `pattern_type` | VARCHAR(20) | How to match: `contains`, `starts_with`, `ends_with`, `exact` |
| `priority` | INT | Priority when multiple patterns match (higher wins) |
| `created_at` | TIMESTAMPTZ | Timestamp when rule was created |

**Pattern Types:**

- `contains`: Pattern appears anywhere in description (most common)
- `starts_with`: Description starts with pattern
- `ends_with`: Description ends with pattern
- `exact`: Description exactly matches pattern (case-sensitive)

**Priority System:**
- 1-49: Low priority (broad catch-all patterns)
- 50-79: Medium priority (standard merchant patterns)
- 80-100: High priority (specific overrides)

**Sample Data:**

```sql
INSERT INTO category_mapping (pattern, category, pattern_type, priority)
VALUES
  -- Fixed Costs (high priority)
  ('CHASE MORTGAGE', 'Fixed Costs', 'contains', 95),
  ('HOA', 'Fixed Costs', 'contains', 90),
  ('CON EDISON', 'Fixed Costs', 'contains', 90),
  ('VERIZON', 'Fixed Costs', 'contains', 90),
  ('MTA*NYCT', 'Fixed Costs', 'contains', 95),
  
  -- Groceries
  ('WHOLEFDS', 'Groceries', 'contains', 90),
  ('TRADER JOE', 'Groceries', 'contains', 90),
  ('FAIRWAY', 'Groceries', 'contains', 90),
  ('KEY FOOD', 'Groceries', 'contains', 90),
  
  -- Dining
  ('RESTAURANT', 'Dining', 'contains', 70),
  ('CAFE', 'Dining', 'contains', 70),
  ('DOORDASH', 'Dining', 'contains', 85),
  ('UBEREATS', 'Dining', 'contains', 85),
  ('GRUBHUB', 'Dining', 'contains', 85),
  
  -- Transportation
  ('UBER', 'Transportation', 'contains', 90),
  ('LYFT', 'Transportation', 'contains', 90),
  ('MTA*NYCT', 'Transportation', 'contains', 95),
  
  -- Gym
  ('GRINDHOUSE', 'Gym', 'contains', 90),
  
  -- Subscriptions
  ('NETFLIX', 'Subscriptions', 'contains', 90),
  ('SPOTIFY', 'Subscriptions', 'contains', 90),
  ('CHATGPT', 'Subscriptions', 'contains', 90),
  
  -- Income
  ('PAYROLL', 'Income', 'contains', 95),
  ('DIRECT DEP', 'Income', 'contains', 90);
```

**Adding New Rules:**

```sql
-- Add a new pattern
INSERT INTO category_mapping (pattern, category, pattern_type, priority)
VALUES ('NEW MERCHANT', 'Category Name', 'contains', 90);
```

**Updating Priority:**

```sql
-- Increase priority to override another pattern
UPDATE category_mapping 
SET priority = 95 
WHERE pattern = 'SPECIFIC MERCHANT';
```

**Viewing All Rules:**

```sql
SELECT pattern, category, pattern_type, priority
FROM category_mapping
ORDER BY priority DESC, category, pattern;
```

---

## stocks_crypto_history

**Purpose:** Investment snapshot history for stocks and cryptocurrency, plus
Plaid-pulled retirement/brokerage holdings (asset_type `Retirement` /
`Brokerage`, written daily on weekdays by `pull-investments.yml`).
Manual `Stock` / `Crypto` rows and Plaid `Retirement` / `Brokerage` rows share
the table; the investments sync deletes and reinserts only that day's
Retirement/Brokerage rows and never touches the manual rows.

**Status:** 🟢 **Active**

**Schema:**

```sql
CREATE TABLE stocks_crypto_history (
  id SERIAL PRIMARY KEY,
  snapshot_date DATE NOT NULL,
  asset_type VARCHAR(20) NOT NULL CHECK (asset_type IN ('stock', 'crypto')),
  symbol VARCHAR(20) NOT NULL,
  quantity DECIMAL(18, 8) NOT NULL,
  price_per_unit DECIMAL(18, 2) NOT NULL,
  total_value DECIMAL(18, 2) NOT NULL,
  cost_basis DECIMAL(18, 2) NOT NULL,
  gain_loss DECIMAL(18, 2) GENERATED ALWAYS AS (total_value - cost_basis) STORED,
  gain_loss_percent DECIMAL(10, 4) GENERATED ALWAYS AS ((total_value - cost_basis) / NULLIF(cost_basis, 0) * 100) STORED,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Composite unique constraint
CREATE UNIQUE INDEX idx_stock_crypto_unique 
  ON stocks_crypto_history(snapshot_date, asset_type, symbol);

-- Indexes for queries
CREATE INDEX idx_stock_crypto_date ON stocks_crypto_history(snapshot_date);
CREATE INDEX idx_stock_crypto_symbol ON stocks_crypto_history(symbol);
```

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `id` | SERIAL | Auto-incrementing primary key |
| `snapshot_date` | DATE | Date of snapshot |
| `asset_type` | VARCHAR(20) | `'stock'` or `'crypto'` |
| `symbol` | VARCHAR(20) | Ticker symbol (AAPL, NVDA, TSLA, BTC) |
| `quantity` | DECIMAL(18,8) | Number of shares/coins owned (8 decimals for crypto) |
| `price_per_unit` | DECIMAL(18,2) | Current price per share/coin |
| `total_value` | DECIMAL(18,2) | Current total value (quantity × price) |
| `cost_basis` | DECIMAL(18,2) | Original purchase cost |
| `gain_loss` | DECIMAL(18,2) | Computed: total_value - cost_basis |
| `gain_loss_percent` | DECIMAL(10,4) | Computed: (gain_loss / cost_basis) × 100 |
| `created_at` | TIMESTAMPTZ | Timestamp when record was inserted |

**Sample Data:**

```sql
INSERT INTO stocks_crypto_history 
  (snapshot_date, asset_type, symbol, quantity, price_per_unit, total_value, cost_basis)
VALUES
  ('2026-09-13', 'stock', 'AAPL', 28.00, 332.28, 9304.00, 6000.00),
  ('2026-09-13', 'stock', 'NVDA', 60.00, 218.28, 13097.00, 8000.00),
  ('2026-09-13', 'stock', 'TSLA', 21.00, 365.43, 7674.00, 14500.00),
  ('2026-09-13', 'crypto', 'BTC', 0.06116791, 77787.00, 4758.00, 3500.00);
```

**Queries:**

**Latest snapshot for each asset:**
```sql
SELECT 
  asset_type,
  symbol,
  quantity,
  price_per_unit,
  total_value,
  cost_basis,
  gain_loss,
  gain_loss_percent
FROM stocks_crypto_history
WHERE snapshot_date = (SELECT MAX(snapshot_date) FROM stocks_crypto_history)
ORDER BY total_value DESC;
```

**Portfolio performance over time:**
```sql
SELECT 
  snapshot_date,
  SUM(total_value) as total_portfolio_value,
  SUM(cost_basis) as total_cost_basis,
  SUM(gain_loss) as total_gain_loss,
  (SUM(gain_loss) / SUM(cost_basis) * 100) as portfolio_gain_percent
FROM stocks_crypto_history
GROUP BY snapshot_date
ORDER BY snapshot_date;
```

**Individual asset history:**
```sql
SELECT 
  snapshot_date,
  price_per_unit,
  total_value,
  gain_loss,
  gain_loss_percent
FROM stocks_crypto_history
WHERE symbol = 'AAPL'
ORDER BY snapshot_date;
```

---

## real_estate_history

**Purpose:** Real estate property values and equity tracking over time

**Status:** 🟢 **Active**

**Schema:**

```sql
CREATE TABLE real_estate_history (
  id SERIAL PRIMARY KEY,
  snapshot_date DATE NOT NULL,
  asset_name VARCHAR(255) NOT NULL,
  asset_type VARCHAR(50) NOT NULL,
  home_value DECIMAL(18, 2) NOT NULL,
  mortgage_balance DECIMAL(18, 2) NOT NULL DEFAULT 0,
  net_equity DECIMAL(18, 2) GENERATED ALWAYS AS (home_value - mortgage_balance) STORED,
  cost_basis DECIMAL(18, 2) NOT NULL,
  gain_loss DECIMAL(18, 2) GENERATED ALWAYS AS (net_equity - cost_basis) STORED,
  gain_loss_percent DECIMAL(10, 4) GENERATED ALWAYS AS ((net_equity - cost_basis) / NULLIF(cost_basis, 0) * 100) STORED,
  data_source VARCHAR(20) DEFAULT 'Redfin',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Composite unique constraint (allows same property on same date from different sources)
CREATE UNIQUE INDEX idx_real_estate_unique 
  ON real_estate_history(snapshot_date, asset_name, data_source);

-- Indexes
CREATE INDEX idx_real_estate_date ON real_estate_history(snapshot_date);
CREATE INDEX idx_real_estate_name ON real_estate_history(asset_name);
```

**Columns:**

| Column | Type | Description |
|--------|------|-------------|
| `id` | SERIAL | Auto-incrementing primary key |
| `snapshot_date` | DATE | Date of snapshot |
| `asset_name` | VARCHAR(255) | Property name/address |
| `asset_type` | VARCHAR(50) | Property type (Condo, House, Storage Unit, etc.) |
| `home_value` | DECIMAL(18,2) | Current estimated market value |
| `mortgage_balance` | DECIMAL(18,2) | Remaining mortgage balance |
| `net_equity` | DECIMAL(18,2) | Computed: home_value - mortgage_balance |
| `cost_basis` | DECIMAL(18,2) | Original purchase price |
| `gain_loss` | DECIMAL(18,2) | Computed: net_equity - cost_basis |
| `gain_loss_percent` | DECIMAL(10,4) | Computed: (gain_loss / cost_basis) × 100 |
| `data_source` | VARCHAR(20) | Source of estimate: 'Zillow', 'Redfin', or 'Manual' |
| `created_at` | TIMESTAMPTZ | Timestamp when record was inserted |

**Sample Data:**

```sql
INSERT INTO real_estate_history 
  (snapshot_date, asset_name, asset_type, home_value, mortgage_balance, cost_basis, data_source)
VALUES
  -- Dual tracking: same property, same date, different sources
  ('2026-09-17', '66 S 6th St, Unit 4A, Brooklyn, NY', 'Condo', 1019300.00, 474204.00, 895000.00, 'Zillow'),
  ('2026-09-17', '66 S 6th St, Unit 4A, Brooklyn, NY', 'Condo', 1015000.00, 474204.00, 895000.00, 'Redfin'),
  
  -- Other properties
  ('2026-09-17', 'Storage Unit', 'Storage', 15000.00, 0.00, 15000.00, 'Manual');
```

**13-Month Equity Trend Data (for dashboard chart):**

```sql
-- Last 13 months of condo equity
SELECT 
  snapshot_date,
  home_value,
  mortgage_balance,
  net_equity
FROM real_estate_history
WHERE asset_name = '66 S 6th St, Unit 4A, Brooklyn, NY'
  AND snapshot_date >= CURRENT_DATE - INTERVAL '13 months'
ORDER BY snapshot_date;
```

**Queries:**

**Latest real estate portfolio (all sources):**
```sql
SELECT 
  asset_name,
  asset_type,
  data_source,
  home_value,
  mortgage_balance,
  net_equity,
  cost_basis,
  gain_loss,
  gain_loss_percent
FROM real_estate_history
WHERE snapshot_date = (SELECT MAX(snapshot_date) FROM real_estate_history)
ORDER BY asset_name, data_source;
```

**Compare Zillow vs Redfin for same property:**
```sql
SELECT 
  snapshot_date,
  MAX(CASE WHEN data_source = 'Zillow' THEN home_value END) as zillow_value,
  MAX(CASE WHEN data_source = 'Redfin' THEN home_value END) as redfin_value,
  (MAX(CASE WHEN data_source = 'Zillow' THEN home_value END) + 
   MAX(CASE WHEN data_source = 'Redfin' THEN home_value END)) / 2 as average_value,
  ABS(MAX(CASE WHEN data_source = 'Zillow' THEN home_value END) - 
      MAX(CASE WHEN data_source = 'Redfin' THEN home_value END)) as difference
FROM real_estate_history
WHERE asset_name = '66 S 6th St, Unit 4A, Brooklyn, NY'
  AND snapshot_date = (SELECT MAX(snapshot_date) FROM real_estate_history)
GROUP BY snapshot_date;
```

**Equity trend for specific property:**
```sql
SELECT 
  snapshot_date,
  home_value,
  mortgage_balance,
  net_equity,
  (net_equity - LAG(net_equity) OVER (ORDER BY snapshot_date)) as equity_change_mom
FROM real_estate_history
WHERE asset_name = '66 S 6th St, Unit 4A, Brooklyn, NY'
ORDER BY snapshot_date;
```

**Total real estate value over time:**
```sql
SELECT 
  snapshot_date,
  SUM(home_value) as total_home_value,
  SUM(mortgage_balance) as total_mortgage,
  SUM(net_equity) as total_equity,
  SUM(gain_loss) as total_gain_loss
FROM real_estate_history
GROUP BY snapshot_date
ORDER BY snapshot_date;
```

---

## Data Relationships

```
category_mapping (pattern matching rules)
    ↓ (used by load_bronze.py)
expense_transactions (categorized expenses)
    ↓ (aggregated by finances.html)
Dashboard Expenses Tab

stocks_crypto_history (investment snapshots)
    ↓ (queried by finances.html)
Dashboard Investments Tab → Stocks/Crypto cards

real_estate_history (property equity)
    ↓ (queried by finances.html)
Dashboard Investments Tab → Real Estate card
```

---

## Maintenance

**Adding New Categories:**

1. Insert pattern into `category_mapping`:
   ```sql
   INSERT INTO category_mapping (pattern, category, pattern_type, priority)
   VALUES ('NEW MERCHANT', 'New Category', 'contains', 90);
   ```

2. Re-run `load_bronze.py` to reprocess uncategorized transactions

**Updating Investment Snapshots:**

Manually add new snapshot rows as market values change (monthly):

```sql
INSERT INTO stocks_crypto_history 
  (snapshot_date, asset_type, symbol, quantity, price_per_unit, total_value, cost_basis)
VALUES
  (CURRENT_DATE, 'stock', 'AAPL', 28.00, 335.50, 9394.00, 6000.00);
```

**Updating Real Estate Values:**

**Automated (recommended):** Run `fetch_property_value_combined.py` monthly (fetches from Zillow + Redfin automatically)

**Manual:** Add new snapshot if adding property value from other source:

```sql
INSERT INTO real_estate_history 
  (snapshot_date, asset_name, asset_type, home_value, mortgage_balance, cost_basis, data_source)
VALUES
  (CURRENT_DATE, '66 S 6th St, Unit 4A, Brooklyn, NY', 'Condo', 1250000.00, 470000.00, 895000.00, 'Manual');
```

---

## Backup & Recovery

**Export all data:**
```bash
pg_dump $SUPABASE_DB_URL > finances_backup_$(date +%Y%m%d).sql
```

**Export specific table:**
```bash
psql $SUPABASE_DB_URL -c "\COPY expense_transactions TO 'expense_transactions.csv' CSV HEADER"
```

**Restore from backup:**
```bash
psql $SUPABASE_DB_URL < finances_backup_20260913.sql
```

---

## Related Files

**Script documentation:** [[finances/scripts]]

**Workflow documentation:** [[finances/finances-automation]]

**Dashboard:** `C:\Users\fmartine\Personal\repos\personal\finances\finances.html`
