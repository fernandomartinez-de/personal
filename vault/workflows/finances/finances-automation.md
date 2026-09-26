---
tags: [finance, automation, monthly, fully-automated, plaid]
category: finance
status: active
last_updated: 2026-09-21
repo: finance (separate)
automation: plaid
---

# Finance Automation

**Status:** Chase transactions LIVE via Plaid daily pull (since 2026-09-21); Fidelity retirement holdings pull added and awaiting Plaid review; investment/property tracking + dashboard unchanged.

Daily automated Chase transaction pull via Plaid, categorized against `category_mapping`, weekday Fidelity retirement holdings pull via Plaid Investments, plus investment portfolio tracking and the finances dashboard.

## Plaid Chase Transactions Pull (LIVE)

Chase statement downloads are automated via Plaid. A daily GitHub Action
(`.github/workflows/pull-finances.yml`) calls Plaid `/transactions/sync` and
upserts into Supabase `expense_transactions`, categorized via `category_mapping`.
Cursor state lives in `plaid_sync_state`; the account map in `plaid_accounts`.

**Accounts:**
- Chase Total Checking ...6813 -> source `checking`
- Chase Freedom Unlimited ...5113 -> source `cc_5113`
- Chase Sapphire Preferred ...4433 -> source `cc_4433`

**One time auth:** `finances/plaid_link.py` (Plaid Hosted Link).
**GitHub secrets:** `PLAID_CLIENT_ID`, `PLAID_SECRET`, `PLAID_ACCESS_TOKEN`, `PLAID_ITEM_ID`
(plus the shared `SUPABASE_URL` / `SUPABASE_KEY`).

**Status:** LIVE since 2026-09-21. Chase OAuth cleared Plaid review on
2026-09-21; first run pulled 64 transactions and reconciled clean with no
duplicates.

## Plaid Fidelity Investments Pull

Second finance pipeline. Weekday GitHub Action
(`.github/workflows/pull-investments.yml`, 22:00 UTC) calls Plaid
`/investments/holdings/get` for the linked Fidelity item and writes daily
holdings snapshots into Supabase `stocks_crypto_history` with asset_type
`Retirement` (or `Brokerage`). Each run deletes and reinserts only that
day's Retirement/Brokerage rows so the hand-tracked Stock/Crypto rows are
untouched. A NetBenefits 401k that returns only the account balance (no
per-fund holdings) is recorded as a single balance row.

**One time auth:** `finances/plaid_investments_link.py` (separate Plaid item
with the Investments product; separate access token from Chase).
**GitHub secret:** `PLAID_FIDELITY_ACCESS_TOKEN` (plus the existing
`PLAID_CLIENT_ID`, `PLAID_SECRET`, `SUPABASE_URL`, `SUPABASE_KEY`).

**Status:** Submitted to Plaid review 2026-09-21. The retirement card in
`finances.html` is still hardcoded pending a wire-up to
`stocks_crypto_history` where asset_type = 'Retirement'.

The old manual pipeline (`process_personal_inbox.py` / `load_bronze.py`, manual
Chase Excel download) is retained for backfills but is no longer routine.

## Repository

`C:\Users\fmartine\Personal\repos\personal\finances\`

GitHub: `https://github.com/fernandomartinez-de/personal` (finances/ folder)

## Tables

**→ [[finances/supabase-tables]]**

Complete Supabase table schema for:
- expense_transactions (categorized expenses)
- category_mapping (pattern matching rules)
- stocks_crypto_history (investment snapshots)
- real_estate_history (property values over time)

## Scripts

**→ [[finances/scripts]]**

**Fully implemented (Sep 2026):**
- `process_personal_inbox.py` - Auto-classify and file all documents (from personal/docs/)
- `PROCESS_INBOX.bat` - One-click automation for inbox processing
- `finances.html` - Full expense + investment tracking dashboard

## Overview

```
Chase statements (3 accounts) → Drop in ops/incoming/ → PROCESS_INBOX.bat
                                                                  ↓
                                           process_personal_inbox.py classifies
                                                                  ↓
                                     Google Drive: Finances/Chase/2026/ (organized)
                                                                  ↓
                                                     Vault nodes updated
                                                                  ↓
                                              (Sync to Supabase if needed)
                                                                  ↓
                                              Dashboard: finances.html
                                         Expenses Tab + Investments Tab
```

**Automation level:** 90% automated
- Manual: 5 min download from Chase + drop in ops/incoming/
- Automated: File classification, renaming, Google Drive filing, vault updates

---

## Workflows

### 1. Finance Statement Filing

**Schedule:** Manual (monthly when statements arrive)  
**Process:** Manual download and file to Google Drive

**Data Flow:**
```
Vendor website/email
  ↓
Download PDF statement
  ↓
Rename to standard format
  ↓
G:\My Drive\Personal\Finances\{vendor}\{YEAR}\
```

**Folder Structure:**
```
Finances/
├── Chase/               # Mortgage statements, credit cards
├── ConEd/              # Electricity bills
│   ├── 2025/
│   └── 2026/
└── Verizon/            # Phone/internet bills
    ├── 2024/
    ├── 2025/
    └── 2026/
```

**Naming Convention:** `YYYY-MM_{vendor}_{type}.pdf`

Examples:
- `2026-09_chase_mortgage.pdf`
- `2026-09_chase_freedom.pdf`
- `2026-09_coned_electric.pdf`
- `2026-09_verizon_mobile.pdf`

**Vendors:**

**Chase:**
- Mortgage payment: ~$X,XXX/month (principal + interest + escrow)
- Freedom credit card: Variable
- Account: `chase.com`

**Con Edison:**
- Electric: ~$XX-XXX/month (varies by season)
- Account #: 62302-57147-6
- Website: `coned.com`

**Verizon Fios:**
- Internet + phone: $138/month
- Website: `verizon.com/fios`

**Manual Process:**
1. Download statement from vendor website or email
2. Rename to `YYYY-MM_{vendor}_{type}.pdf`
3. File in `G:\My Drive\Personal\Finances\{vendor}\{YEAR}\`
4. Delete from Downloads
5. Log in expense tracker (see Expense Tracking workflow)

---

### 2. Expense Tracking (AUTOMATED)

**Schedule:** Monthly (first week of month)  
**Total time:** ~10 minutes (5 min download + 5 min review)  
**Scripts:** Fully automated

**Workflow:**

**Step 1: Download Chase statements (5 min)**
```
chase.com → Login
  ↓
Total Checking (...6813) → Download → Excel → All transactions
  ↓
Freedom Unlimited (...5113) → Download → Excel → All transactions
  ↓
Sapphire Preferred (...4433) → Download → Excel → All transactions
  ↓
Save 3 Excel files
```

**Step 2: Drop in incoming (30 sec)**
```
Move 3 files to: C:\Users\fmartine\Personal\repos\personal\vault\ops\incoming\
```

**Step 3: Run automation (30 sec)**
```
Double-click: C:\Users\fmartine\Personal\repos\personal\docs\PROCESS_INBOX.bat
```
This automatically:
1. Scans ops/incoming/ for all files
2. Classifies Chase files as financial (by account number: 6813, 5113, 4433)
3. Extracts dates and metadata
4. Renames to standard format: `YYYY-MM-DD_statement_chase-{account}.xlsx`
5. Moves to Google Drive: `G:\My Drive\Personal\Finances\Chase\2026\`
6. Updates vault nodes with metadata

**Step 4: Verify filing (1 min)**
Check Google Drive folder to confirm files were moved correctly

**Step 5: Review dashboard (5 min)**
Open `finances.html` in browser
- Check Net Remaining looks right
- Review Fixed Costs (mortgage, utilities, etc.)
- Check for any "Miscellaneous" categories
- Review Discretionary Spending trends

**Data Flow:**
```
Chase Excel files (ops/incoming/)
  ↓
process_personal_inbox.py (classifies by pattern matching)
  ↓
Google Drive: Finances/Chase/2026/ (renamed & organized)
  ↓
Vault nodes updated with metadata
  ↓
(Sync to Supabase if configured)
  ↓
Dashboard: finances.html
```

**expenses Table (Supabase):**
- `id` (serial, PK)
- `expense_date` (date)
- `vendor` (varchar: "Chase", "ConEd", "Verizon", "Misc")
- `category` (varchar: "Housing", "Utilities", "Food", "Transport", "Health", "Personal")
- `subcategory` (varchar: "Mortgage", "Electric", "Internet", "Groceries", etc.)
- `amount` (decimal)
- `description` (text)
- `payment_method` (varchar: "Chase Freedom", "Chase checking", "Cash")
- `recurring` (boolean)
- `created_at` (timestamptz)

**Budget Categories:**

| Category | Monthly Budget | Typical Vendors |
|----------|----------------|-----------------|
| **Housing** | $X,XXX | Chase mortgage, HOA |
| **Utilities** | $XXX | Con Edison, Verizon |
| **Food** | $XXX | Groceries, restaurants |
| **Transport** | $XXX | Gas, parking, transit |
| **Health** | $XXX | Insurance premiums, copays |
| **Personal** | $XXX | Shopping, entertainment |
| **Savings** | $XXX | Investment contributions |

**Manual Entry:**
```bash
cd finance
python add_expense.py --date 2026-09-01 --vendor "ConEd" --category "Utilities" --amount 85.43 --description "Electric bill September"
```

**CSV Upload:**
```bash
cd finance
python upload_expenses.py --csv expenses_september.csv
```

**CSV Format:**
```csv
expense_date,vendor,category,subcategory,amount,description,payment_method,recurring
2026-09-01,Chase,Housing,Mortgage,2850.00,Monthly mortgage payment,Chase checking,true
2026-09-05,ConEd,Utilities,Electric,85.43,Electric bill,Chase Freedom,true
2026-09-10,Verizon,Utilities,Internet,138.00,Fios internet,Chase Freedom,true
```

**Budget Report Generation:**
```bash
cd finance
python generate_budget_report.py --month 2026-09
```

**Output:**
- `finance/reports/2026-09_budget_report.html` - Interactive HTML with charts
- `finance/reports/2026-09_budget_report.pdf` - PDF for records

**Report Contents:**
- Month-over-month expense comparison
- Budget vs actual by category
- Spending trends (3-month rolling average)
- Largest expenses breakdown
- Savings rate
- Year-to-date totals

---

### 3. Annual Tax Prep

**Schedule:** Annually (January-April)  
**Script:** `finance/generate_tax_summary.py` (TBD)

**Purpose:** Generate tax-relevant expense summary for Schedule A (itemized deductions)

**Data Flow:**
```
Supabase SELECT * FROM expenses WHERE expense_date BETWEEN '2025-01-01' AND '2025-12-31'
  ↓
generate_tax_summary.py
  ↓
Tax-deductible expenses summary (CSV + PDF)
```

**Tax-Relevant Categories:**
- **Mortgage interest:** From Chase 1098 (G:\My Drive\Personal\Tax\Tax 2025\Chase (Mortgage)\)
- **Property taxes:** NYC property tax payments
- **Charitable donations:** If tracked in expenses
- **Medical expenses:** Over 7.5% AGI threshold
- **State/local taxes:** From W2 + property tax

**Output:**
- `finance/tax/2025_tax_summary.csv`
- `finance/tax/2025_tax_summary.pdf`

---

## Dashboard Features

**Location:** `finances.html`  
**Access:** http://localhost:8000/ (after running START.bat)

### Expenses Tab

**Monthly Payroll:**
- Tracks biweekly direct deposits
- Shows monthly total

**Fixed Costs:**
- Mortgage Payment: $3,683.44
- HOA: $505
- Electricity: Variable (~$100)
- Verizon: $138
- Insurance: Variable
- Grindhouse: Variable
- MTA: $132
- Subscriptions: Variable

**Discretionary Spending:**
- By category with line/bar charts
- Shows monthly trends
- Clickable categories for transaction details

**Net Remaining:**
- Monthly income - all expenses
- 6-month trend chart

**Category Breakdown:**
- Pivoted table by month
- Fixed Costs section
- Discretionary section
- Clickable cells show transaction details

### Investments Tab

**Total Net Worth:** $1,294,721 (as of Sep 13, 2026)
**Total Gain (All Time):** +$350,241 (+37.08%)

**Cards (3 top row, 2 bottom row):**

1. **Total Stocks:** $30,075
   - AAPL (Apple): 28 shares | Cost: $6,000 | Value: $9,304 | Gain: +$3,304
   - NVDA (Nvidia): 60 shares | Cost: $8,000 | Value: $13,097 | Gain: +$5,097
   - TSLA (Tesla): 21 shares | Cost: $14,500 | Value: $7,674 | Loss: -$6,826
   - Live prices via Finnhub API

2. **Total Crypto:** $4,758
   - Bitcoin: 0.06116791 BTC | Cost: $3,500 | Gain: +$1,258 (+35.94%)
   - Live price via CoinGecko API

3. **Retirement (401k):** $2,480.30 (as of Sep 11, 2026)
   - Clickable card shows explanation modal
   - Explains 6% contribution + 6% employer match
   - Fidelity NetBenefits account

4. **Real Estate:** $1,257,410
   - Condo: $1,242,410 (66 S 6th St, Brooklyn)
   - Storage Unit: $15,000
   - Clickable card shows 13-month equity trend
   - Tracks home value, mortgage balance, net equity

5. **Net Gain/Loss:** +$350,241 (+37.08%)
   - Total lifetime gain across all assets
   - Includes stocks, crypto, retirement, real estate

**Asset Table:**
- All holdings with current values
- Gain/Loss columns (green for positive, red for negative)
- Type badges (Stock, Crypto, Retirement, Real Estate)
- Shows quantity, price, total value, cost basis, % change

**Visualizations:**
- **Treemap:** Asset allocation by value
- **Radial Distribution:** Polar area chart
- **Portfolio Composition:** Horizontal stacked bar
- **Asset Class Performance:** Gauges for stocks/crypto/real estate
- **Bubble Chart:** Performance vs. size (x-axis: asset type, y-axis: gain %, size: value)

**Filters:**
- All Assets / Stocks / Crypto / Real Estate
- Date filter (current or historical snapshots)

**Theme:** Complete dark mode with conditional formatting throughout

---

## Adding Category Rules

If new merchants appear as "Miscellaneous":

```sql
INSERT INTO category_mapping (pattern, category, pattern_type, priority)
VALUES ('MERCHANT NAME', 'Category', 'contains', 90);
```

Then re-run `load_bronze.py` to reprocess.

**Common patterns:**
- `'WHOLEFDS'` → `'Groceries'`
- `'UBER'` → `'Transportation'`
- `'GRINDHOUSE'` → `'Gym'`
- `'MTA*NYCT'` → `'Transportation'`

---

## Statement Sources

### Chase (Mortgage + Credit Cards)

**Login:** `chase.com`

**Mortgage:**
- Account: (Add account number)
- Monthly payment: (Add amount)
- Includes: Principal, interest, property tax escrow, insurance escrow
- Auto-pay from: Chase checking

**Freedom Credit Card:**
- Account: (Add last 4 digits)
- Rewards: (Cash back structure)
- Auto-pay: Full balance from checking

**Where to find statements:**
- Login → Accounts → Select account → Statements & Documents
- Download PDF
- File as: `YYYY-MM_chase_mortgage.pdf` or `YYYY-MM_chase_freedom.pdf`

### Con Edison (Electric)

**Login:** `coned.com`  
**Account #:** 62302-57147-6

**Service address:** 66 S 6th Street, Unit 4A, Brooklyn, NY

**Billing:**
- Cycle: Monthly
- Average: $XX-XXX (varies seasonally)
- Auto-pay: (Check if enabled)

**Where to find statements:**
- Login → My Account → Billing & Payments → View Bills
- Download PDF
- File as: `YYYY-MM_coned_electric.pdf`

### Verizon Fios (Internet)

**Login:** `verizon.com/fios`

**Service:** Internet + phone  
**Monthly cost:** $138

**Service address:** 66 S 6th Street, Unit 4A, Brooklyn, NY

**Billing:**
- Cycle: Monthly
- Auto-pay: (Check if enabled)

**Where to find statements:**
- Login → My Bill → View Bill Details
- Download PDF
- File as: `YYYY-MM_verizon_mobile.pdf`

---

## Dependencies

**Python Packages** (`finance/requirements.txt`):
```
pandas>=2.0.0
psycopg2-binary>=2.9.0
plotly>=5.14.0
reportlab>=4.0.0
```

**External Services:**
- Supabase PostgreSQL: Connection string in `SUPABASE_DB_URL`
- Google Drive: For statement storage (no API required, direct file access)

---

## Secrets Required

- `SUPABASE_DB_URL` (for expense table writes)

No GitHub Actions currently - all manual execution.

---

## Failure Modes

**Missing statement:**
- Vendor didn't send statement or email filtered to spam
- Action: Login to vendor website and download manually

**Duplicate entry:**
- Same expense added twice
- Action: Check Supabase for existing entry before INSERT

**Budget exceeded:**
- Overspending in category
- Action: Report highlights red flag, adjust spending or budget

---

## Vault Cross-References

**Domain knowledge:**
- [[life-admin/expenses]] - Budget planning and tracking notes
- [[life-admin/credit-banking]] - Card details and payment methods
- [[life-admin/real-estate]] - Mortgage and property details
- [[life-admin/taxes]] - Tax filing workflow

**Quick references:**
- [[quick-ref/key-dates]] - Bill due dates

**Google Drive:**
- Statement storage: `G:\My Drive\Personal\Finances\`
- See [[workflows/tables/gdrive-folders]] for complete structure

---

## Recent Improvements (September 17, 2026)

### Dashboard Automation Enhancements

**Zillow API Integration:**
- Integrated Zillow API directly into dashboard "Refresh Prices" button
- Auto-fetches latest Zestimate via RapidAPI (1000 free calls/month)
- Automatically saves to Supabase with `data_source='Zillow'`
- Eliminates need to run separate Zillow script

**Property Value Averaging:**
- Dashboard now calculates average of Zillow + Redfin estimates
- Real Estate card shows average value for portfolio calculations
- Click card to see detailed breakdown: Zillow, Redfin, Average, Variance
- More accurate property valuation using both sources

**Database Cleanup:**
- Merged `categorization_rules` table into `category_mapping` (single source of truth)
- Added missing patterns for convenience stores, Amazon variations, UPS
- Re-categorized 20+ transactions from Miscellaneous to proper categories
- Dropped 11 redundant files from finance repo

**Current Automation Status:**
- ✅ Stocks: Finnhub API (dashboard button)
- ✅ Crypto: CoinGecko API (dashboard button)
- ✅ Real Estate (Zillow): RapidAPI (dashboard button)
- ⚠️ Real Estate (Redfin): Manual script (CORS restrictions)
- ⚠️ Retirement: Hardcoded value (no API available)

**Manual Steps Remaining:**
1. Monthly: Run `fetch_redfin_property_value.py` script
2. Monthly: Update retirement 401(k) balance in code
3. As needed: Add new category mapping rules for unknown merchants

---

## Future Enhancements

1. **Automated downloads:** Use Plaid or vendor APIs to auto-download statements
2. **Receipt scanning:** OCR receipts and auto-categorize
3. **Budget alerts:** Email/SMS when approaching category limits
4. **Investment tracking:** Integrate Morgan Stanley/Coinbase for portfolio view
5. **Retirement planning:** 401k contribution tracking and projections (semi-automated with Supabase storage)
6. **Net worth dashboard:** Assets (property, stocks, cash) - liabilities (mortgage)
7. **GitHub Actions:** Automate monthly budget report generation
