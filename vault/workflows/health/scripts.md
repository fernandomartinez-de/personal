---
tags: [health, scripts, automation, python]
category: health
last_updated: 2026-09-13
---

# Health Scripts

Python scripts for health data automation workflows.

**Location:** `C:\Users\fmartine\Personal\repos\personal\health\`

---

## Whoop Scripts

### sync.py

**Purpose:** Daily Whoop fitness data sync to Supabase

**Location:** `health/whoop/sync.py`

**Schedule:** Daily at 8 AM UTC via GitHub Actions (`.github/workflows/whoop-daily-sync.yml`)

**What it does:**
1. Refreshes access token using refresh token
2. Fetches last 7 days of data from Whoop API:
   - Recovery (GET `/v1/recovery`)
   - Cycles (GET `/v1/cycle`)
   - Sleep (GET `/v1/sleep`)
   - Workouts (GET `/v1/workout`)
3. Upserts data into Supabase tables (INSERT ON CONFLICT UPDATE)

**Environment variables:**
- `WHOOP_CLIENT_ID` - OAuth app client ID
- `WHOOP_CLIENT_SECRET` - OAuth app secret
- `WHOOP_REFRESH_TOKEN` - OAuth refresh token
- `SUPABASE_DB_URL` - PostgreSQL connection string
- `GH_PAT` - GitHub personal access token (for updating refresh token secret)

**Dependencies:** (`health/whoop/requirements.txt`)
```
requests>=2.28.0
psycopg2-binary>=2.9.0
PyNaCl>=1.5.0
```

**Manual execution:**
```bash
cd health/whoop
export WHOOP_CLIENT_ID=...
export WHOOP_CLIENT_SECRET=...
export WHOOP_REFRESH_TOKEN=...
export SUPABASE_DB_URL=...
export GH_PAT=...
python sync.py
```

**Output:**
- Console log of records synced
- Updated rows in: whoop_recovery, whoop_cycles, whoop_sleep, whoop_workouts

**Error handling:**
- 401 Unauthorized → Attempts token refresh, logs error if fails
- Connection timeout → Logs error, will retry next run
- Rate limit → Backoff and retry logic built-in

---

### bootstrap.py

**Purpose:** Refresh Whoop OAuth access token

**Location:** `health/whoop/bootstrap.py`

**Schedule:** Weekly Sunday at midnight UTC via GitHub Actions (`.github/workflows/whoop-bootstrap-token.yml`)

**What it does:**
1. Uses current refresh token to get new access token + refresh token
2. Encrypts new refresh token
3. Updates GitHub repository secret `WHOOP_REFRESH_TOKEN` via GitHub API

**Why weekly:** Whoop access tokens expire, refresh tokens rotate with each use

**Environment variables:**
- `WHOOP_CLIENT_ID`
- `WHOOP_CLIENT_SECRET`
- `WHOOP_REFRESH_TOKEN`
- `GH_PAT` (needs write:secrets permission)
- `GITHUB_REPOSITORY` (format: "owner/repo")

**Dependencies:** (`health/whoop/requirements.txt`)
```
requests>=2.28.0
PyNaCl>=1.5.0
```

**Manual execution:**
```bash
cd health/whoop
export WHOOP_CLIENT_ID=...
export WHOOP_CLIENT_SECRET=...
export WHOOP_REFRESH_TOKEN=...
export GH_PAT=...
export GITHUB_REPOSITORY=fernandomartinez-de/personal
python bootstrap.py
```

**Output:**
- Console log of token refresh status
- Updated `WHOOP_REFRESH_TOKEN` GitHub secret

**Error handling:**
- Invalid refresh token → Logs error, requires manual OAuth reauthorization
- GitHub API failure → Logs error, token not updated (will retry next week)

---

## Medical Scripts

### ingest_labs_gdrive.py

**Purpose:** Weekly ingestion of lab results PDFs from Google Drive

**Location:** `health/medical/ingest_labs_gdrive.py`

**Schedule:** Weekly Monday at 9 AM UTC via GitHub Actions (`.github/workflows/medical-ingest-labs.yml`)

**What it does:**
1. Authenticates to Google Drive API via service account
2. Scans `G:\My Drive\Personal\Medical\{YEAR}\labs\` for PDFs
3. Extracts text from PDFs using PyPDF2
4. Parses lab values using regex patterns:
   - TSH, glucose, cholesterol, HDL, LDL, triglycerides, thyroglobulin
5. Inserts structured data into Supabase `labs` table
6. Skips duplicates (same test_date already exists)

**Source folder structure:**
```
Medical/
├── 2018/labs/
├── 2019/labs/
...
└── 2026/labs/
    ├── 2026-04-17_labs_quest-mx_general.pdf
    └── 2026-03-05_labs_hospital-angeles-lomas_general.pdf
```

**Naming convention:** `YYYY-MM-DD_labs_{provider}_{test-type}.pdf`

**Environment variables:**
- `GOOGLE_CREDENTIALS` - Service account JSON (entire JSON as string)
- `SUPABASE_DB_URL` - PostgreSQL connection string

**Dependencies:** (`health/medical/requirements.txt`)
```
PyPDF2>=3.0.0
psycopg2-binary>=2.9.0
google-api-python-client>=2.0.0
```

**Manual execution:**
```bash
cd health/medical
export GOOGLE_CREDENTIALS='{"type":"service_account",...}'
export SUPABASE_DB_URL=...
python ingest_labs_gdrive.py
```

**Output:**
- Console log of files processed
- Inserted rows in `labs` table

**Error handling:**
- 403 Forbidden → Service account lacks Drive access, reshare folder
- Parse errors → Logs unrecognized format, skips file, continues
- Duplicate test_date → Skips insert, logs duplicate

---

### build_dashboards.py

**Purpose:** Generate HTML dashboards from lab data

**Location:** `health/medical/build_dashboards.py`

**Schedule:** Weekly Monday at 10 AM UTC (after ingest) via GitHub Actions (`.github/workflows/medical-rebuild-dashboards.yml`)

**What it does:**
1. Queries Supabase `labs` table for all test results
2. Creates interactive Plotly charts:
   - Line charts for each biomarker over time
   - Reference ranges shaded
   - Hover tooltips with exact values
3. Generates standalone HTML files with embedded charts
4. Commits and pushes HTML files to repo

**Output files:**
- `health/medical/labs_dashboard.html` - All lab results over time
- `health/medical/thyroid_dashboard.html` - TSH + thyroglobulin surveillance
- `health/medical/lipids_dashboard.html` - Cholesterol trends

**Environment variables:**
- `SUPABASE_DB_URL` (read-only)
- `GOOGLE_CREDENTIALS` (optional, for additional context)

**Dependencies:** (`health/medical/requirements.txt`)
```
pandas>=2.0.0
plotly>=5.14.0
psycopg2-binary>=2.9.0
```

**Manual execution:**
```bash
cd health/medical
export SUPABASE_DB_URL=...
python build_dashboards.py
git add *.html
git commit -m "Update medical dashboards"
git push
```

**Output:**
- 3 HTML dashboard files
- Console log of charts generated
- Git commit with updated dashboards

**Error handling:**
- No data → Generates empty dashboard with message
- Query failure → Logs error, exits

---

### clean_medical_drive.py

**Purpose:** Monthly cleanup and archival of medical files in Google Drive

**Location:** `health/medical/clean_medical_drive.py`

**Schedule:** Monthly on 1st at midnight UTC via GitHub Actions (`.github/workflows/medical-clean-drive.yml`)

**What it does:**
1. Scans `G:\My Drive\Personal\Medical\_REVISAR\` (inbox folder)
2. Identifies properly named files (follow naming convention)
3. Moves them to appropriate year/type folders
4. Archives files >90 days old
5. Flags unrecognized files for manual review

**Naming patterns recognized:**
- `YYYY-MM-DD_labs_*.pdf` → `Medical/{YEAR}/labs/`
- `YYYY-MM-DD_radiologia_*.pdf` → `Medical/{YEAR}/radiologia/`
- `YYYY-MM-DD_ultrasonidos_*.pdf` → `Medical/{YEAR}/ultrasonidos/`
- `YYYY-MM-DD_patologia_*.pdf` → `Medical/{YEAR}/patologia/`

**Environment variables:**
- `GOOGLE_CREDENTIALS` - Service account JSON

**Dependencies:** (`health/medical/requirements.txt`)
```
google-api-python-client>=2.0.0
```

**Manual execution:**
```bash
cd health/medical
export GOOGLE_CREDENTIALS='...'
python clean_medical_drive.py
```

**Output:**
- Console log of files moved/archived
- Organized Google Drive folders

**Error handling:**
- Unrecognized files → Logs warning, leaves in _REVISAR
- Move failure → Logs error, continues with next file
- Permission denied → Logs error, skips file

---

## Common Dependencies

All health scripts share these core dependencies:

**Python 3.10+** (installed in GitHub Actions runner)

**PyPDF2** - PDF text extraction  
**psycopg2-binary** - PostgreSQL/Supabase connection  
**requests** - HTTP requests (Whoop API)  
**PyNaCl** - Encryption for GitHub secrets  
**google-api-python-client** - Google Drive API  
**pandas** - Data manipulation  
**plotly** - Interactive charts  

**Installation:**
```bash
cd health/whoop
pip install -r requirements.txt

cd health/medical
pip install -r requirements.txt
```

---

## Development

**Running locally:**

1. Clone repo
2. Install dependencies
3. Set environment variables
4. Run script

**Testing without Supabase:**
- Use local PostgreSQL with same schema
- Or add dry-run mode to scripts (logs but doesn't write)

**Adding new scripts:**
1. Create script in appropriate folder
2. Add dependencies to requirements.txt
3. Document in this file
4. Create GitHub Actions workflow if scheduled
5. Add secrets to GitHub repository settings

---

## Troubleshooting

**Whoop sync fails:**
- Check `WHOOP_REFRESH_TOKEN` is current (run bootstrap.py)
- Verify Whoop API is accessible (check Whoop status page)
- Review GitHub Actions logs for error details

**Medical ingest fails:**
- Verify service account has Drive access
- Check PDF naming follows convention
- Review parse errors in logs (may need regex updates)

**Dashboards not updating:**
- Check ingest ran successfully first
- Verify Supabase connection
- Review plotly chart generation logs

**Google Drive cleanup fails:**
- Verify service account permissions
- Check file naming patterns
- Review move operation logs

---

## Related Files

**Workflow documentation:** [[health/health-data-pipeline]]

**Tables documentation:** [[health/supabase-tables]]

**GitHub Actions workflows:**
- `.github/workflows/whoop-daily-sync.yml`
- `.github/workflows/whoop-bootstrap-token.yml`
- `.github/workflows/medical-ingest-labs.yml`
- `.github/workflows/medical-rebuild-dashboards.yml`
- `.github/workflows/medical-clean-drive.yml`
