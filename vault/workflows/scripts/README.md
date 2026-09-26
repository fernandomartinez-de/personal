# Scripts Documentation

Central index for all automation scripts in Fernando's personal infrastructure.

**Scripts live in:** `C:\Users\fmartine\Personal\repos\personal\` (GitHub repo)  
**Detailed docs in:** `vault/workflows/{domain}/scripts.md`

---

## Overview

This folder serves as a navigation hub. Each workflow domain (health, docs, finances, travel) has its own comprehensive `scripts.md` file documenting:

- Script purpose and location
- Input/output data flows
- Dependencies and secrets
- Execution methods (manual, GitHub Actions)
- Failure modes and troubleshooting

**For script-level details, see the domain-specific documentation below.**

---

## Quick Script Lookup

### Health Automation
**Location:** `personal/health/`  
**Documentation:** [[workflows/health/scripts]]

| Script | Purpose | Schedule |
|--------|---------|----------|
| `whoop/sync.py` | Sync Whoop fitness data to Supabase | Daily 8 AM UTC (GH Actions) |
| `whoop/bootstrap.py` | Refresh Whoop OAuth token | Weekly Sunday (GH Actions) |
| `medical/ingest_labs_gdrive.py` | Ingest lab PDFs from Google Drive | Weekly Monday 9 AM (GH Actions) |
| `medical/build_dashboards.py` | Generate medical HTML dashboards | Weekly Monday 10 AM (GH Actions) |
| `medical/clean_medical_drive.py` | Cleanup Google Drive medical folder | Monthly 1st midnight (GH Actions) |

**Secrets required:**
- `WHOOP_CLIENT_ID`, `WHOOP_CLIENT_SECRET`, `WHOOP_REFRESH_TOKEN`
- `GOOGLE_CREDENTIALS` (service account JSON)
- `SUPABASE_DB_URL`

---

### Personal Docs Processing
**Location:** `personal/docs/`  
**Documentation:** [[workflows/docs/scripts]]

| Script | Purpose | Schedule |
|--------|---------|----------|
| `process_personal_inbox.py` | Classify and file personal documents to Google Drive | Manual on-demand |
| `scan_expirations.py` | Scan documents for expiration dates | Manual on-demand |
| `PROCESS_INBOX.bat` | Launcher for inbox processing | Manual (double-click) |
| `SCAN_EXPIRATIONS.bat` | Launcher for expiration scanning | Manual (double-click) |

**Requirements:**
- Google Drive for Desktop mounted at `G:\My Drive\Personal\`
- Python packages: PyPDF2, python-docx, pandas

**No secrets required** (direct filesystem access)

---

### Finance Tracking
**Location:** `personal/docs/` (inbox processor) + `personal/finances/` (scripts, dashboard)  
**Documentation:** [[workflows/finances/scripts]]

| Script | Purpose | Schedule | Status |
|--------|---------|----------|--------|
| `finances/plaid_link.py` | One time: connect Chase via Plaid Hosted Link | Manual once | 🟢 Active |
| `finances/plaid_sync.py` | Daily Plaid Chase transactions -> Supabase `expense_transactions` | Daily 13:00 UTC (GH Actions) | 🟢 Active |
| `finances/plaid_investments_link.py` | One time: connect Fidelity (Investments product) via Plaid Hosted Link | Manual once | 🟢 Active |
| `finances/plaid_investments_sync.py` | Daily weekday Plaid holdings -> Supabase `stocks_crypto_history` (Retirement/Brokerage) | Weekdays 22:00 UTC (GH Actions) | 🟢 Active |
| `docs/process_personal_inbox.py` | Classify and file Chase statements to Google Drive | Manual backfill | 🟢 Active |
| `docs/PROCESS_INBOX.bat` | Launcher for inbox processing | Manual (double-click) | 🟢 Active |
| `finances/scripts/fetch_redfin_property_value.py` | Fetch property value from Redfin, update Supabase | Manual monthly | 🟢 Active |
| `vault/ops/outgoing/docs/FETCH_REDFIN.bat` | Launcher for Redfin property sync | Manual (double-click) | 🟢 Active |
| `finances/scripts/load_bronze.py` | Bulk load Chase statements to Supabase | As needed | 🟡 Optional |
| `finances/serve_dashboard.py` | Run local HTTP server for dashboard | As needed | 🟡 Optional |
| `finances/finances.html` | Standalone dashboard (expenses + investments) | Manual review | 🟢 Active |

**Requirements:**
- Google Drive for Desktop mounted at `G:\My Drive\Personal\`
- Supabase for expense_transactions and investment data
- Live APIs: Finnhub (stocks), CoinGecko (crypto)
- Python with supabase, requests, beautifulsoup4, pandas, openpyxl

**Secrets required:**
- `SUPABASE_URL`, `SUPABASE_KEY` (environment variables)
- `PLAID_CLIENT_ID`, `PLAID_SECRET`, `PLAID_ACCESS_TOKEN`, `PLAID_ITEM_ID` (Chase transactions)
- `PLAID_FIDELITY_ACCESS_TOKEN` (Fidelity investments)
- `REDFIN_COOKIE` (environment variable, optional)

**Status:** Core workflow active - Chase statements filed via inbox processor, Redfin property values fetched monthly, optional scripts available for bulk operations

---

### Travel Planning
**Location:** `personal/travel/`  
**Documentation:** [[workflows/travel/scripts]]

| Script | Purpose | Schedule |
|--------|---------|----------|
| `create_trip.py` | Generate single-file trip HTML from template | Manual on-demand |
| `deploy.sh` | Deploy trip site to GitHub Pages | Manual (git push) |

**Requirements:**
- Supabase project with `trips`, `trip_days`, `activities` tables
- GitHub Pages enabled on personal repo

**No automation** - fully manual trip creation and updates

---

## Execution Environments

### GitHub Actions (Automated)
- **Platform:** `ubuntu-latest` runners
- **Python:** 3.11+
- **Schedules:** Cron expressions in `.github/workflows/`
- **Secrets:** GitHub repository secrets
- **Logs:** Available in GitHub Actions tab

**Active workflows:**
```
.github/workflows/
├── whoop-daily-sync.yml           # Daily 8 AM UTC
├── whoop-bootstrap-token.yml      # Weekly Sunday midnight
├── medical-ingest-labs.yml        # Weekly Monday 9 AM
├── medical-rebuild-dashboards.yml # Weekly Monday 10 AM
├── medical-clean-drive.yml        # Monthly 1st midnight
├── pull-finances.yml              # Daily 13:00 UTC - Chase transactions
└── pull-investments.yml           # Weekdays 22:00 UTC - Fidelity holdings
```

### Local Windows (Manual)
- **Platform:** Windows 11 (Fernando's machine)
- **Python:** Installed locally
- **Google Drive:** Mounted via Google Drive for Desktop at `G:\`
- **Launchers:** Batch files (`.bat`) for convenience

**Manual scripts:**
```
personal/docs/
├── PROCESS_INBOX.bat               # Double-click to run
├── SCAN_EXPIRATIONS.bat            # Double-click to run
├── process_personal_inbox.py
└── scan_expirations.py

vault/ops/outgoing/docs/
└── FETCH_REDFIN.bat                # Double-click to run (monthly)
```

**Note:** Redfin blocks cloud IPs (GitHub Actions fails with 405 error), so the property value script must run locally

---

## Repository Structure

```
C:\Users\fmartine\Personal\repos\personal\
├── .github\workflows\          # GitHub Actions schedules
├── health\
│   ├── whoop\                 # Whoop fitness automation
│   │   ├── sync.py
│   │   ├── bootstrap.py
│   │   └── requirements.txt
│   └── medical\               # Medical data automation
│       ├── ingest_labs_gdrive.py
│       ├── build_dashboards.py
│       ├── clean_medical_drive.py
│       └── requirements.txt
├── docs\
│   ├── process_personal_inbox.py
│   ├── scan_expirations.py
│   ├── PROCESS_INBOX.bat
│   └── SCAN_EXPIRATIONS.bat
├── finances\
│   ├── finances.html          # Standalone dashboard (expenses + investments)
│   ├── scripts\
│   │   ├── fetch_redfin_property_value.py  # Redfin property value automation (monthly)
│   │   └── load_bronze.py                   # Bulk load Chase statements to Supabase (optional)
│   ├── serve_dashboard.py     # Local HTTP server for dashboard (optional)
│   └── requirements.txt       # Python dependencies
├── travel\
│   ├── README.md
│   ├── SETUP.md
│   ├── index.html             # Landing page
│   ├── create_trip.py         # TBD
│   └── japan\                 # Current trip (manual)
│       ├── index.html
│       └── assets\
└── vault\                     # This vault (version controlled)
    └── ops\
        └── incoming\          # Drop zone for all incoming documents
```

---

## Detailed Documentation

Each workflow domain has comprehensive script-level documentation:

- **[[workflows/health/scripts]]** - Health automation scripts
  - Whoop OAuth flow
  - Medical PDF parsing logic
  - Dashboard HTML generation
  - Google Drive API interaction
  
- **[[workflows/docs/scripts]]** - Personal docs processing scripts
  - Pattern matching logic
  - File classification rules
  - Expiration date extraction
  - Naming convention enforcement
  
- **[[workflows/finances/scripts]]** - Finance tracking scripts
  - Chase statement filing (via process_personal_inbox.py)
  - Dashboard HTML structure (finances.html)
  - Supabase data integration
  - Live API integration (Finnhub, CoinGecko)
  
- **[[workflows/travel/scripts]]** - Travel planning scripts
  - Trip HTML template structure
  - Supabase real-time integration
  - GitHub Pages deployment

---

## Secrets Management

All secrets stored as GitHub repository secrets (Settings → Secrets → Actions).

**Current secrets:**
- `GH_PAT` - GitHub personal access token (for updating secrets)
- `SUPABASE_DB_URL` - PostgreSQL connection string
- `WHOOP_CLIENT_ID` - Whoop OAuth app ID
- `WHOOP_CLIENT_SECRET` - Whoop OAuth secret
- `WHOOP_REFRESH_TOKEN` - Whoop refresh token (auto-updated weekly)
- `GOOGLE_CREDENTIALS` - Google Drive service account JSON

**Access:** Fernando only (private repo)

---

## Troubleshooting

### GitHub Actions Failures
1. Check workflow run logs: [GitHub Actions tab](https://github.com/fernandomartinez-de/personal/actions)
2. Verify secrets are current in repository settings
3. Check external service availability (Whoop API, Google Drive, Supabase)
4. Review "Failure Modes" section in workflow-specific docs

### Local Script Failures
1. Verify Python dependencies installed: `pip install -r requirements.txt`
2. Check Google Drive mounted at `G:\My Drive\Personal\`
3. Ensure no file locks (close Excel, Acrobat, etc.)
4. Review script output for error messages

### Common Issues

**"Workspace still starting"** (Bash tool)
- Linux VM booting in background
- Wait 3-5 seconds and retry

**"Permission denied"** (File operations)
- File locked by another process
- Close applications accessing the file

**"Module not found"** (Python)
- Dependencies not installed
- Run: `pip install -r requirements.txt --break-system-packages`

**"G: drive not accessible"** (Google Drive)
- Google Drive for Desktop not running
- Open Google Drive app and wait for sync

---

## Adding New Scripts

When creating a new automation script:

1. **Choose domain:** health, docs, finances, or travel
2. **Add script** to appropriate folder in `personal/` repo
3. **Document** in domain's `workflows/{domain}/scripts.md`
4. **Add secrets** to GitHub repository settings if needed
5. **Create GitHub Actions workflow** if scheduled (`.github/workflows/`)
6. **Update** this README with quick lookup entry
7. **Test locally** before deploying to GitHub Actions

---

## Related Vault Documentation

**Workflow overviews:**
- [[workflows/README]] - Workflow status dashboard
- [[workflows/health/health-data-pipeline]] - Health automation overview
- [[workflows/docs/docs-automation]] - Personal docs overview
- [[workflows/finances/finances-automation]] - Finance automation overview

**Data storage:**
- [[workflows/health/supabase-tables]] - Health data schemas
- [[workflows/finances/supabase-tables]] - Finance data schemas
- [[workflows/tables/gdrive-folders]] - Google Drive structure

---

**Last updated:** 2026-09-21  
**Maintained by:** Fernando Martinez
