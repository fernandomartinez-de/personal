---
tags: [finances, scripts, python, budgeting, automation, plaid]
category: finances
last_updated: 2026-09-21
status: active
---

# Finances Scripts

Python scripts for expense tracking, property value monitoring, and investment dashboard.

**Location:** `C:\Users\fmartine\Personal\repos\personal\finances\`

**Status:** 🟢 **Active** - Plaid daily auto-pull is the current routine; manual scripts kept for backfills

---

## Active Scripts

### plaid_link.py

**Purpose:** One time Plaid Hosted Link auth to connect Chase and obtain the
long-lived access token used by the daily sync.

**Location:** `finances/plaid_link.py`

**Status:** 🟢 **Active** (added 2026-09-21) - Run once locally

**Usage:**
```bash
cd finances
cp .env.example .env      # add PLAID_CLIENT_ID / PLAID_SECRET
pip install -r requirements.txt
python plaid_link.py
```

**What it does:**
1. Creates a Plaid Hosted Link URL and waits for the Chase OAuth flow to finish
2. Exchanges the public_token for a long-lived access_token + item_id
3. Records the masked account map (last 4 only) in Supabase `plaid_accounts`
4. Initializes a row in `plaid_sync_state` for the daily cursor
5. Writes `PLAID_ACCESS_TOKEN` and `PLAID_ITEM_ID` to `.plaid_secrets.local` (gitignored)

**GitHub secrets to set after running:** `PLAID_CLIENT_ID`, `PLAID_SECRET`,
`PLAID_ACCESS_TOKEN`, `PLAID_ITEM_ID`.

---

### plaid_sync.py

**Purpose:** Daily incremental pull of Chase transactions via Plaid
`/transactions/sync` into Supabase `expense_transactions`.

**Location:** `finances/plaid_sync.py`

**Status:** 🟢 **Active** (added 2026-09-21) - Driven by GitHub Actions

**Driver:** `.github/workflows/pull-finances.yml` runs daily at 13:00 UTC
(~09:00 America/New_York EDT), plus `workflow_dispatch` for manual triggers.

**What it does:**
1. Loads categorization rules from `category_mapping` (lowest `priority` wins)
2. Self-heals `plaid_accounts` from Plaid `/accounts/get` (mask -> source)
3. Loads the last cursor from `plaid_sync_state`
4. Pages through `/transactions/sync` until `has_more` is false
5. Per source, gates on the manual watermark (last non-Plaid `transaction_date`)
   so Plaid never double-counts the manually imported history
6. Flips sign (Plaid: out positive; `expense_transactions`: out negative) and upserts
   on `plaid_transaction_id`
7. Deletes rows for any Plaid transactions Plaid reports as removed
8. Persists the new cursor and `last_synced_at`

**Idempotency:** Upserts on the unique `plaid_transaction_id` index; re-runs are safe.

---

### plaid_investments_link.py

**Purpose:** One time Plaid Hosted Link auth to connect Fidelity (Investments
product) as a separate Plaid item and obtain the long-lived access token used
by the daily holdings pull.

**Location:** `finances/plaid_investments_link.py`

**Status:** 🟢 **Active** (added 2026-09-21) - Run once locally after Fidelity
shows Enabled at https://dashboard.plaid.com/activity/status/oauth-institutions

**Usage:**
```bash
cd finances
python plaid_investments_link.py
```

**What it does:**
1. Creates a Plaid Hosted Link URL for the `investments` product
2. Waits for the Fidelity OAuth flow to finish and picks up the public_token
3. Exchanges it for a long-lived access_token + item_id
4. Writes `PLAID_FIDELITY_ACCESS_TOKEN` and `PLAID_FIDELITY_ITEM_ID` to
   `.plaid_investments_secrets.local` (gitignored)

**GitHub secret to set after running:** `PLAID_FIDELITY_ACCESS_TOKEN`.

---

### plaid_investments_sync.py

**Purpose:** Daily weekday pull of Fidelity retirement holdings via Plaid
`/investments/holdings/get` into Supabase `stocks_crypto_history` as
asset_type `Retirement` (or `Brokerage`).

**Location:** `finances/plaid_investments_sync.py`

**Status:** 🟢 **Active** (added 2026-09-21) - Driven by GitHub Actions

**Driver:** `.github/workflows/pull-investments.yml` runs weekdays at 22:00
UTC (~18:00 America/New_York EDT), plus `workflow_dispatch` for manual triggers.

**What it does:**
1. Calls `/investments/holdings/get`, with retry for `PRODUCT_NOT_READY`
2. Classifies each account by Plaid subtype (401k, IRA, Roth, etc. -> `Retirement`;
   anything else investment -> `Brokerage`)
3. Builds one row per holding with quantity, price, value, and cost basis
   (falls back to institution_value when cost_basis is missing so gain/loss is 0)
4. Falls back to the account `balances.current` for accounts that return no
   per-fund holdings (typical for a NetBenefits 401k), tagged
   `<name> (balance)`
5. Deletes and reinserts only that day's Retirement/Brokerage rows in
   `stocks_crypto_history`, leaving manual Stock/Crypto rows untouched

**Idempotency:** Daily delete-then-insert scoped to `snapshot_date` and
`asset_type IN ('Retirement', 'Brokerage')`; re-runs are safe.

---

## Other Scripts (still active for property value + dashboard, plus manual backfill)

### process_personal_inbox.py

**Purpose:** Auto-classify and file all incoming documents (Chase statements, bills, medical, tax, etc.)

**Location:** `personal/docs/process_personal_inbox.py`

**Status:** 🟢 **Active** (part of docs workflow, not finances repo)

**Usage:**
```bash
cd personal/docs
python process_personal_inbox.py
```

**Or via batch file:**
```bash
PROCESS_INBOX.bat
```

**What it does:**
1. Scans `C:\Users\fmartine\Personal\repos\personal\vault\ops\incoming\` for all files
2. Classifies by type: financial (Chase), medical (labs), tax (W-2, 1099), ID (passports), employment
3. Extracts dates and metadata from filenames and content
4. Renames to standard format: `YYYY-MM-DD_category_source_detail.ext`
5. Moves financial files to Google Drive: `G:\My Drive\Personal\Finances\{vendor}\{year}\`
6. Updates vault nodes with metadata

**Example output:**
```
Processing: Activity6813.xlsx
  → Classified: Financial - Chase Checking
  → Renamed: 2026-09-13_statement_chase-checking.xlsx
  → Moved to: G:\My Drive\Personal\Finances\Chase\2026\
  → Updated: workflows/finances/credit-banking
```

**Integration:** Run manually via PROCESS_INBOX.bat after dropping files in ops/incoming/

**Note:** This script lives in `personal/docs/` but is used for finance workflows

---

### load_bronze.py

**Purpose:** Load Chase Excel statements into Supabase expense_transactions table with auto-categorization

**Location:** `finances/scripts/load_bronze.py`

**Status:** 🟡 **Optional** - Useful for bulk loading statements to Supabase

**Usage:**
```bash
cd finances/scripts
python load_bronze.py
```

**What it does:**
1. Reads raw Excel files from a specified folder (e.g., Downloads/chase-bronze/)
2. Applies categorization rules from Supabase category_mapping table
3. Loads transactions into expense_transactions table (auto-deduplicates)
4. Reports success/failure stats

**Use case:** 
- Bulk load multiple months of Chase statements at once
- Re-process statements after updating category mapping rules
- Initial data backfill

**Requirements:**
- SUPABASE_URL and SUPABASE_KEY environment variables
- Chase Excel files in source folder

**Note:** Most users will use finances.html dashboard directly; this is for advanced bulk operations

---

### serve_dashboard.py

**Purpose:** Run local HTTP server to serve finances.html dashboard

**Location:** `finances/serve_dashboard.py`

**Status:** 🟡 **Optional** - Alternative to opening HTML directly

**Usage:**
```bash
cd finances
python serve_dashboard.py
```

**What it does:**
1. Starts HTTP server on port 8000
2. Serves finances.html and static assets
3. Enables CORS for local API calls (Finnhub, CoinGecko)
4. Keeps running until manually stopped (Ctrl+C)

**Access:**
```
http://localhost:8000/
```

**Use case:**
- Prefer browser-based access over opening file directly
- Avoid CORS issues when testing dashboard changes
- Share dashboard on local network

**Alternative:** Just open `finances.html` directly in browser (simpler, no server needed)

---

### fetch_property_value_combined.py ⭐ DEPRECATED (Sep 17, 2026)

**Purpose:** Fetch property values from BOTH Zillow AND Redfin, compare estimates, and store both in Supabase

**Location:** `finances/scripts/fetch_property_value_combined.py`

**Status:** 🟡 **Deprecated - Dashboard automation is easier** (Sep 17, 2026)

**New workflow (recommended):**
1. Run `fetch_redfin_property_value.py` monthly (Redfin only - still manual due to CORS)
2. Click "Refresh Prices" button in dashboard (auto-fetches Zillow + calculates average)

This combined script still works but is no longer needed since dashboard handles Zillow automatically.

**Usage:**
```bash
cd finances/scripts
python fetch_property_value_combined.py
```

**What it does:**
1. Fetches Zillow Zestimate (via API or web scraping)
2. Fetches Redfin Estimate (via web scraping)
3. Stores BOTH estimates in Supabase `real_estate_history` table with separate `data_source` values
4. Compares the two estimates and shows analysis:
   - Difference amount and percentage
   - Average of both
   - Recommendation (use average if close, investigate if far apart)
5. Calculates current mortgage balance based on amortization
6. Computes net equity and unrealized gain/loss for each source

**Example output:**
```
🏠 Zillow Zestimate:    $1,019,300
   Gain since purchase: $124,300 (+13.9%)

🏠 Redfin Estimate:     $1,015,000
   Gain since purchase: $120,000 (+13.4%)

📊 Analysis:
   Difference:          $4,300 (0.4%)
   Average estimate:    $1,017,150
   
💡 Recommendation:
   ✓ Estimates are close (within 0.4%) - both are reliable
   → Use average: $1,017,150
```

**Why use both sources:**
- Cross-validation: If close, estimates are trustworthy
- Accuracy: Average of both is more accurate than either alone
- Spot errors: Large discrepancy flags potential data issues
- Historical comparison: Track how each service's estimate changes over time

**Execution:** Run manually on 1st of each month (takes ~60 seconds)

---

### fetch_zillow_property_value.py

**Purpose:** Fetch Zillow Zestimate and update Supabase

**Location:** `finances/scripts/fetch_zillow_property_value.py`

**Status:** 🟢 **DEPRECATED - Now automated via dashboard** (Sep 17, 2026)

**New method:** Click "Refresh Prices" button in `finances.html` dashboard
- Zillow API integrated directly in dashboard
- Auto-fetches + saves to Supabase
- Averages with Redfin estimate
- No script needed!

**Script still works** if you need to run it separately, but dashboard button is easier.

**API Setup (already configured in dashboard):**
- RapidAPI "Zillow Scraper - 1000 Free Calls"
- API key stored in dashboard code
- Property ID: 444738887 (66 S 6th St #4A)

---

### fetch_redfin_property_value.py

**Purpose:** Fetch Redfin Estimate and update Supabase

**Location:** `finances/scripts/fetch_redfin_property_value.py`

**Status:** 🟢 **ACTIVE - Monthly manual run** (Sep 17, 2026)

**What it does:**
1. Scrapes Redfin property page for estimated home value (66 S 6th St, Unit 4A, Brooklyn)
2. Stores in Supabase with `data_source = 'Redfin'`
3. Calculates mortgage balance and equity

**Why still manual:** Redfin doesn't allow direct browser API calls (CORS restrictions)

**Workflow:** Run this script monthly, then click dashboard "Refresh Prices" to fetch Zillow + recalculate average

**Environment variables (all scripts):**
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_KEY` - Supabase anon key
- `ZILLOW_API_KEY` - (Optional) RapidAPI key for faster Zillow fetching
- `REDFIN_COOKIE` - (Optional) Session cookie for Redfin owner dashboard access

**Configuration (all scripts):**
```python
PROPERTY_NAME = "66 S 6th St, Unit 4A, Brooklyn, NY"
COST_BASIS = Decimal("895000.00")  # April 2025 purchase price
INITIAL_MORTGAGE = Decimal("475000.00")  # Initial loan amount
MONTHLY_PAYMENT_TO_PRINCIPAL = Decimal("798.00")  # ~$798/month at 6.49%
MORTGAGE_START_DATE = date(2025, 4, 1)  # April 2025 closing
```

**Dashboard integration:** finances.html automatically displays both Zillow and Redfin estimates in Investments tab → Real Estate card

---

## Dashboard

### finances.html

**Purpose:** Full expense tracking + investment portfolio dashboard

**Location:** `finances/finances.html`

**Status:** 🟢 **Implemented and active**

**Access:** Open directly in browser (standalone HTML file)

**Features:**

**Expenses Tab:**
- Monthly Payroll (biweekly deposits)
- Fixed Costs donut chart (Mortgage, HOA, Utilities, Insurance, etc.)
- Discretionary Spending line + bar charts (by category)
- Net Remaining: Income - Expenses with 6-month trend
- Category Breakdown: Pivoted table by month (Fixed Costs + Discretionary)
- Clickable categories show transaction details modal

**Investments Tab:**
- Total Net Worth: $1,294,721 (as of Sep 13, 2026)
- Total Gain (All Time): +$350,241 (+37.08%)
- 5 Cards (3 top row, 2 bottom row):
  1. Total Stocks: $30,075 (AAPL, NVDA, TSLA) - Live prices via Finnhub
  2. Total Crypto: $4,758 (Bitcoin) - Live price via CoinGecko
  3. Retirement (401k): $2,480.30 - Clickable for contribution explanation
  4. Real Estate: $1,257,410 (Condo + Storage) - Clickable for 13-month equity trend
  5. Net Gain/Loss: +$350,241 (+37.08%)
- Asset Table: All holdings with gain/loss color-coded (green/red)
- Visualizations: Treemap, Radial, Portfolio Composition, Gauges, Bubble Chart
- Filters: All Assets / Stocks / Crypto / Real Estate

**Theme:**
- Complete dark mode with conditional formatting
- Backgrounds: #1f2937, #2d3748, #374151, #4b5563
- Text: #f3f4f6 (primary), #d1d5db (secondary)
- Gains: #34d399 / #6ee7b7 (green)
- Losses: #f87171 / #fca5a5 (red)

**Data Sources:**
- Supabase: expense_transactions, stocks_crypto_history, real_estate_history
- Live APIs (automated via dashboard "Refresh Prices" button): Finnhub (stocks), CoinGecko (crypto), Zillow (real estate)
- Manual: Redfin (real estate - script), Retirement balance (hardcoded)

**Chart Library:** Chart.js

---

## Monthly Workflow

**Monthly Process (10 minutes total):**

1. **Download statements (5 min)** from chase.com:
   - Total Checking (...6813) → Excel → All transactions
   - Freedom Unlimited (...5113) → Excel → All transactions
   - Sapphire Preferred (...4433) → Excel → All transactions

2. **Drop files in incoming (30 sec):**
   ```
   C:\Users\fmartine\Personal\repos\personal\vault\ops\incoming\
   ```

3. **Run automation (30 sec):**
   Double-click: `C:\Users\fmartine\Personal\repos\personal\docs\PROCESS_INBOX.bat`

4. **Verify filing:**
   Check Google Drive: `G:\My Drive\Personal\Finances\Chase\2026\`

5. **Fetch Redfin property value (30 sec):**
   ```bash
   cd C:\Users\fmartine\Personal\repos\personal\finances\scripts
   python fetch_redfin_property_value.py
   ```

6. **Review dashboard (5 min):**
   Open `finances.html` in browser
   - Click "Refresh Prices" button (fetches Zillow + stocks + crypto, calculates average with Redfin)
   - Check Net Remaining
   - Review Fixed Costs
   - Check Discretionary Spending trends
   - Look for Miscellaneous items needing new rules
   - Review Investment tab for gains/losses and updated property value
   - Click Real Estate card to see Zillow vs Redfin comparison

**Data Flow:**
```
Chase Excel files (ops/incoming/)
  ↓ (process_personal_inbox.py)
Google Drive Finances/Chase/2026/ (renamed & organized)
  ↓ (manual or automated sync to Supabase)
Supabase expense_transactions table
  ↓ (finances.html + Chart.js)
Dashboard (standalone HTML)

Zillow + Redfin property pages
  ↓ (fetch_property_value_combined.py)
Supabase real_estate_history table (separate rows for Zillow & Redfin)
  ↓ (finances.html)
Dashboard Investments tab (shows both estimates + average)
```

---

## Dashboard

### finances.html

**Purpose:** Full expense tracking + investment portfolio dashboard

**Location:** `finances/finances.html`

**Status:** 🟢 **Implemented and active**

**Features:**

**Expenses Tab:**
- Monthly Payroll (biweekly deposits)
- Fixed Costs donut chart (Mortgage, HOA, Utilities, Insurance, etc.)
- Discretionary Spending line + bar charts (by category)
- Net Remaining: Income - Expenses with 6-month trend
- Category Breakdown: Pivoted table by month (Fixed Costs + Discretionary)
- Clickable categories show transaction details modal

**Investments Tab:**
- Total Net Worth: $1,294,721 (as of Sep 13, 2026)
- Total Gain (All Time): +$350,241 (+37.08%)
- 5 Cards (3 top row, 2 bottom row):
  1. Total Stocks: $30,075 (AAPL, NVDA, TSLA) - Live prices via Finnhub
  2. Total Crypto: $4,758 (Bitcoin) - Live price via CoinGecko
  3. Retirement (401k): $2,480.30 - Clickable for contribution explanation
  4. Real Estate: $1,257,410 (Condo + Storage) - Clickable for 13-month equity trend
  5. Net Gain/Loss: +$350,241 (+37.08%)
- Asset Table: All holdings with gain/loss color-coded (green/red)
- Visualizations: Treemap, Radial, Portfolio Composition, Gauges, Bubble Chart
- Filters: All Assets / Stocks / Crypto / Real Estate

**Theme:**
- Complete dark mode with conditional formatting
- Backgrounds: #1f2937, #2d3748, #374151, #4b5563
- Text: #f3f4f6 (primary), #d1d5db (secondary)
- Gains: #34d399 / #6ee7b7 (green)
- Losses: #f87171 / #fca5a5 (red)

**Data Sources:**
- Supabase: expense_transactions, stocks_crypto_history, real_estate_history
- Live APIs (automated via dashboard "Refresh Prices" button): Finnhub (stocks), CoinGecko (crypto), Zillow (real estate)
- Manual: Redfin (real estate - script), Retirement balance (hardcoded)

**Chart Library:** Chart.js

---

## Data Management

### Adding Category Rules

If new merchants appear as "Miscellaneous", add pattern to Supabase:

```sql
INSERT INTO category_mapping (pattern, category, pattern_type, priority)
VALUES ('MERCHANT NAME', 'Category', 'contains', 90);
```

Then re-run `load_bronze.py` to reprocess transactions.

**Common patterns:**
```sql
('WHOLEFDS', 'Groceries', 'contains', 90)
('UBER', 'Transportation', 'contains', 90)
('GRINDHOUSE', 'Gym', 'contains', 90)
('MTA*NYCT', 'Transportation', 'contains', 95)
('VERIZON', 'Utilities', 'contains', 90)
('CON EDISON', 'Utilities', 'contains', 90)
('CHASE MORTGAGE', 'Fixed Costs', 'contains', 95)
```

---

## Dependencies

**Python 3.10+**

**For scripts:**
- `supabase` - Supabase client library for Python
- `requests` - HTTP requests (for Redfin scraping)
- `beautifulsoup4` - HTML parsing (for Redfin scraping)
- `pandas` - Data manipulation and Excel reading (for load_bronze.py)
- `openpyxl` - Excel file processing (for load_bronze.py)

**For dashboard (HTML):**
- Chart.js - Visualizations (donut, line, bar, polar, bubble, treemap)
- Finnhub API - Live stock prices
- CoinGecko API - Live crypto prices

**Installation:**
```bash
cd finances
pip install supabase requests beautifulsoup4 pandas openpyxl
```

---

## Future Enhancement Scripts (Not yet implemented)

### generate_budget_report.py

**Purpose:** Generate monthly budget report with charts and trends

**Status:** 🔴 **TBD** - Future enhancement

**Planned usage:**
```bash
cd finances
python generate_budget_report.py --month 2026-09
```

**What it would do:**
1. Query Supabase for specified month
2. Calculate totals by category
3. Compare to previous months (trends)
4. Generate interactive HTML with Plotly charts
5. Generate PDF version
6. Save to `finances/reports/`

---

### generate_tax_summary.py

**Purpose:** Generate annual tax-deductible expense summary

**Status:** 🔴 **TBD** - Future enhancement

**Planned usage:**
```bash
cd finances
python generate_tax_summary.py --year 2025
```

**What it would do:**
1. Query expenses for full year
2. Filter to tax-relevant categories (mortgage interest, property taxes, medical, etc.)
3. Generate CSV for tax preparer
4. Generate PDF summary
5. Save to `finances/tax/`

---

## Troubleshooting

**Connection errors:**
- Verify Supabase connection string is correct
- Check Supabase project is not paused
- Test connection: `psql $SUPABASE_DB_URL`

**File processing errors:**
- Verify files are in correct inbox folder
- Check file format is Excel (.xlsx)
- Ensure account numbers are in filename or content

**Category mapping errors:**
- Check category_mapping table has patterns
- Verify pattern_type is valid: `contains`, `starts_with`, `ends_with`, `exact`
- Higher priority patterns override lower priority

**Dashboard not loading:**
- Check server.py is running on port 8000
- Verify Supabase tables have data
- Check browser console for JavaScript errors
- Verify API keys for Finnhub and CoinGecko

**Port conflict:**
- If port 8000 is in use, kill existing process or use different port
- Windows: `netstat -ano | findstr :8000` then `taskkill /PID <pid> /F`

---

## Related Files

**Workflow documentation:** [[finances/finances-automation]]

**Tables documentation:** [[finances/supabase-tables]]

**Statement storage:** `G:\My Drive\Personal\Finances\{vendor}\{YEAR}\`

**Dashboard location:** `C:\Users\fmartine\Personal\repos\personal\finances\finances.html`

---

## Automated Scripts

### fetch_redfin_property_value.py

**Purpose:** Automatically fetch property value from Redfin and update Supabase

**Location:** `finances/scripts/fetch_redfin_property_value.py`

**Status:** 🟢 **Implemented and active** (automated via GitHub Actions)

**Schedule:** Monthly on 1st at midnight UTC (via GitHub Actions)

**What it does:**
1. Scrapes Redfin public listing page for estimated home value
2. Calculates current mortgage balance (based on amortization formula)
3. Calculates net equity and unrealized gain/loss
4. Inserts snapshot into Supabase `real_estate_history` table
5. Updates finances.html dashboard Real Estate card automatically

**Manual execution:**
```bash
cd C:\Users\fmartine\Personal\repos\personal\vault\ops\outgoing\docs
python fetch_redfin_property_value.py
```

**Or via batch file:**
```bash
FETCH_REDFIN.bat
```

**Environment variables required:**
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_KEY` - Supabase anon key
- `REDFIN_COOKIE` - Optional, for owner dashboard access

**GitHub Actions workflow:** `.github/workflows/redfin-property-sync.yml`

**Example output:**
```
======================================================================
Redfin Property Value Fetcher
======================================================================

[1/3] Fetching property value from Redfin...
  ✓ Found value with selector {'class': 'statsValue'}: $1,129,827.00

[2/3] Calculating mortgage balance...
  Estimated balance: $557,600.00
  (Based on 1200.00/month since 2024-06-01)

[3/3] Updating Supabase...
  ✓ Inserted new snapshot for 2026-09-14

📊 Property Snapshot Summary:
  Date:               2026-09-14
  Home Value:         $1,129,827.00
  Mortgage Balance:   $557,600.00
  Net Equity:         $572,227.00
  Cost Basis:         $600,000.00
  Unrealized G/L:     $-27,773.00 (-4.63%)

✅ SUCCESS: Property value updated in Supabase!
```

**Setup documentation:** [[ops/outgoing/docs/REDFIN_SETUP]]

---

## GitHub Actions Workflows

**Pull Finances (Plaid):**
- Workflow: `.github/workflows/pull-finances.yml`
- Schedule: Daily at 13:00 UTC (~09:00 America/New_York EDT)
- Manual trigger: Available via GitHub Actions UI (`workflow_dispatch`)
- Runs: `finances/plaid_sync.py`
- Secrets required: `PLAID_CLIENT_ID`, `PLAID_SECRET`, `PLAID_ACCESS_TOKEN`, `PLAID_ITEM_ID`, `SUPABASE_URL`, `SUPABASE_KEY`

**Pull Investments (Plaid):**
- Workflow: `.github/workflows/pull-investments.yml`
- Schedule: Weekdays at 22:00 UTC (~18:00 America/New_York EDT)
- Manual trigger: Available via GitHub Actions UI (`workflow_dispatch`)
- Runs: `finances/plaid_investments_sync.py`
- Secrets required: `PLAID_CLIENT_ID`, `PLAID_SECRET`, `PLAID_FIDELITY_ACCESS_TOKEN`, `SUPABASE_URL`, `SUPABASE_KEY`

**Redfin Property Sync:**
- Workflow: `.github/workflows/redfin-property-sync.yml`
- Schedule: Monthly on 1st at 00:00 UTC
- Manual trigger: Available via GitHub Actions UI
- Secrets required: `SUPABASE_URL`, `SUPABASE_KEY`, `REDFIN_COOKIE`
