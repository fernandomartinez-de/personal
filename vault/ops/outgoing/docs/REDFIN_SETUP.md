# Redfin Property Value Automation - Setup Guide

Automatically fetch your property's estimated value from Redfin and update Supabase monthly.

## What This Does

- **Fetches** estimated home value from your Redfin owner dashboard
- **Calculates** current mortgage balance based on amortization
- **Stores** snapshot in Supabase `real_estate_history` table
- **Updates** your finances.html dashboard automatically
- **Runs** monthly on the 1st (or on-demand)

## Files Created

1. `fetch_redfin_property_value.py` - Python script to scrape Redfin and update Supabase
2. `FETCH_REDFIN.bat` - Windows batch file for easy manual execution
3. `redfin-property-sync.yml` - GitHub Actions workflow for automatic monthly execution
4. `REDFIN_SETUP.md` - This file (setup instructions)

---

## Prerequisites

**Required:**
- Python 3.10+ installed
- Supabase account with connection string
- Redfin account (owner dashboard access)
- GitHub repository (for automated execution)

**Python packages:**
```bash
pip install requests beautifulsoup4 psycopg2-binary
```

---

## Setup Instructions

### Step 1: Get Your Redfin Cookie (for authentication)

The owner dashboard requires you to be logged in. Here's how to get your session cookie:

1. **Open Chrome/Edge** and go to: https://www.redfin.com/myredfin/owner-dashboard/36948925
2. **Log in** to your Redfin account
3. **Open Developer Tools** (F12 or right-click → Inspect)
4. **Go to Application tab** → Cookies → https://www.redfin.com
5. **Find cookie named `RF_AUTH`** or similar (look for session cookie)
6. **Copy the cookie value**

**Note:** Session cookies expire after ~30 days, so you may need to update this periodically.

---

### Step 2: Set Environment Variables

**Windows (PowerShell - Persistent):**
```powershell
# Supabase connection string
[System.Environment]::SetEnvironmentVariable('SUPABASE_DB_URL', 'postgresql://user:pass@host/db', 'User')

# Redfin session cookie
[System.Environment]::SetEnvironmentVariable('REDFIN_COOKIE', 'your_cookie_value_here', 'User')
```

**Restart your terminal** after setting environment variables.

**To verify:**
```powershell
echo $env:SUPABASE_DB_URL
echo $env:REDFIN_COOKIE
```

---

### Step 3: Test Manually First

Before automating, test the script manually to make sure it works:

**Option A: Using batch file (easiest)**
```bash
# Double-click FETCH_REDFIN.bat
# or from command prompt:
cd C:\Users\fmartine\Personal\repos\personal\vault\ops\outgoing\docs
FETCH_REDFIN.bat
```

**Option B: Using Python directly**
```bash
cd C:\Users\fmartine\Personal\repos\personal\vault\ops\outgoing\docs
python fetch_redfin_property_value.py
```

**Expected output:**
```
======================================================================
Redfin Property Value Fetcher
======================================================================

[1/3] Fetching property value from Redfin...
Fetching: https://www.redfin.com/myredfin/owner-dashboard/36948925
  Using authentication cookie
  ✓ Found value: $1,242,410.00

[2/3] Calculating mortgage balance...
  Estimated balance: $590,000.00
  (Based on $1200.00/month since 2024-06-01)

[3/3] Updating Supabase...
Connecting to Supabase...
  ✓ Inserted new snapshot for 2026-09-14

📊 Property Snapshot Summary:
  Date:             2026-09-14
  Home Value:       $1,242,410.00
  Mortgage Balance: $590,000.00
  Net Equity:       $652,410.00
  Cost Basis:       $600,000.00
  Gain/Loss:        $52,410.00 (+8.74%)

✅ SUCCESS: Property value updated in Supabase!

View in dashboard: finances.html → Investments tab → Real Estate card
```

**Troubleshooting:**

- **"Could not find home value"** → Cookie expired or wrong selectors. Check browser inspector for HTML structure.
- **"SUPABASE_DB_URL not set"** → Environment variable not configured correctly.
- **"Network error"** → Check internet connection or Redfin URL.
- **"Database error"** → Verify Supabase connection string and table schema exists.

---

### Step 4: Automate with GitHub Actions

Once manual testing works, set up automatic monthly execution:

1. **Move workflow file to GitHub repo:**
   ```bash
   # Copy from vault to your personal repo
   mkdir -p C:\Users\fmartine\Personal\repos\personal\.github\workflows
   copy redfin-property-sync.yml C:\Users\fmartine\Personal\repos\personal\.github\workflows\
   ```

2. **Add GitHub Secrets:**
   - Go to: https://github.com/fernandomartinez-de/personal/settings/secrets/actions
   - Click "New repository secret"
   - Add `SUPABASE_DB_URL` with your connection string
   - Add `REDFIN_COOKIE` with your session cookie

3. **Commit and push:**
   ```bash
   cd C:\Users\fmartine\Personal\repos\personal
   git add .github/workflows/redfin-property-sync.yml
   git add vault/ops/outgoing/docs/fetch_redfin_property_value.py
   git commit -m "Add Redfin property value automation"
   git push
   ```

4. **Verify workflow is active:**
   - Go to: https://github.com/fernandomartinez-de/personal/actions
   - Check "Redfin Property Value Sync" workflow appears
   - Click "Run workflow" to test manual trigger

---

### Step 5: Update Vault Documentation

Remove this from your manual workflow checklist:

**Before:**
```markdown
**Monthly finance tasks:**
- [ ] Monthly: Fetch property estimated value and equity from Redfin (66 S 6th Street)
```

**After:** (Task automated - remove from outstanding list)

Update `ops/outstanding/README.md`:
```markdown
**Remaining Manual Steps - Finance Workflow:**
- ✅ Property value tracking: **AUTOMATED** (monthly via GitHub Actions)
- [ ] Monthly: Download Chase statements and upload to ops/incoming/
- [ ] Monthly: Run PROCESS_INBOX.bat
- [ ] As needed: Add category mapping rules
- [ ] Monthly: Review finances.html dashboard
```

---

## How It Works

### Manual Execution Flow
```
You run FETCH_REDFIN.bat
  ↓
Script fetches Redfin owner dashboard (with cookie auth)
  ↓
Parses HTML for estimated home value
  ↓
Calculates current mortgage balance (amortization formula)
  ↓
Inserts snapshot into Supabase real_estate_history
  ↓
finances.html dashboard shows updated values
```

### Automated Execution Flow (GitHub Actions)
```
1st of month at midnight UTC
  ↓
GitHub Actions runner starts
  ↓
Checks out your repo
  ↓
Installs Python + dependencies
  ↓
Runs fetch_redfin_property_value.py
  ↓
Uses GitHub Secrets for SUPABASE_DB_URL and REDFIN_COOKIE
  ↓
Updates Supabase
  ↓
Dashboard automatically reflects new data
```

---

## Maintenance

### Update Mortgage Details (in script)

If mortgage parameters change, edit `fetch_redfin_property_value.py`:

```python
# Line ~28
INITIAL_MORTGAGE = Decimal("590000.00")  # Your initial loan
MONTHLY_PAYMENT_TO_PRINCIPAL = Decimal("1200.00")  # Avg principal per month
MORTGAGE_START_DATE = date(2024, 6, 1)  # Your closing date
```

### Refresh Redfin Cookie (every ~30 days)

1. Log in to Redfin in browser
2. Get new `RF_AUTH` cookie (see Step 1)
3. Update environment variable (local) and GitHub Secret

### Change Schedule

Edit `redfin-property-sync.yml`:

```yaml
# Daily at 9 AM UTC (4/5 AM ET)
- cron: '0 9 * * *'

# Weekly on Mondays
- cron: '0 0 * * 1'

# Monthly on 15th
- cron: '0 0 15 * *'
```

---

## Alternative: Windows Task Scheduler

If you prefer local execution instead of GitHub Actions:

1. **Open Task Scheduler** (Windows key → "Task Scheduler")
2. **Create Basic Task**
3. **Name:** "Redfin Property Value Sync"
4. **Trigger:** Monthly, 1st day, 9:00 AM
5. **Action:** Start a program
6. **Program:** `C:\Users\fmartine\Personal\repos\personal\vault\ops\outgoing\docs\FETCH_REDFIN.bat`
7. **Finish**

---

## Data Schema

Updates this table in Supabase:

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
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

**Sample inserted row:**
```sql
INSERT INTO real_estate_history 
  (snapshot_date, asset_name, asset_type, home_value, mortgage_balance, cost_basis)
VALUES
  ('2026-09-14', '66 S 6th St, Unit 4A, Brooklyn, NY', 'Condo', 1242410.00, 590000.00, 600000.00);
```

---

## Dashboard Integration

Your `finances.html` dashboard automatically shows this data in:

**Investments Tab → Real Estate Card:**
- Current home value
- Mortgage balance
- Net equity
- Gain/loss since purchase
- 13-month equity trend chart

No changes needed to dashboard - it queries `real_estate_history` table automatically.

---

## Related Files

**Script documentation:** [[workflows/finances/scripts]]

**Workflow documentation:** [[workflows/finances/finances-automation]]

**Supabase tables:** [[workflows/finances/supabase-tables]]

**Outstanding tasks:** [[ops/outstanding/README]]

**Tech infrastructure:** [[workflows/tech/infrastructure]]

---

## Next Steps

1. ✅ Test script manually (FETCH_REDFIN.bat)
2. ✅ Verify Supabase update works
3. ✅ Check dashboard shows new data
4. ✅ Set up GitHub Actions workflow
5. ✅ Update outstanding tasks list
6. ✅ Wait for monthly run or trigger manually

**Questions or issues?** Check script output for specific error messages and update selectors if Redfin changes their HTML structure.
