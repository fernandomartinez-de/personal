---
tags: [health, automation, daily, weekly]
category: health
status: active
last_updated: 2026-09-21
repo: personal
---

# Health Data Pipeline

Complete automation for health data ingestion, storage, and visualization.

## Repository

`C:\Users\fmartine\Personal\repos\personal\health\`

GitHub: `https://github.com/fernandomartinez-de/personal` (health/ folder)

## Tables

**→ [[health/supabase-tables]]**

Complete Supabase table schemas for:
- whoop_recovery, whoop_cycles, whoop_sleep, whoop_workouts
- labs
- body_composition (Renpho scale daily pull via `pull-body.yml`)
- nutrition_log (surfaced in the Overload Nutrition tab)
- strength_* (training data feeding the Overload Training tab)

## Scripts

**→ [[health/scripts]]**

Python automation scripts:
- sync.py, bootstrap.py (Whoop)
- ingest_labs_gdrive.py, build_dashboards.py, clean_medical_drive.py (Medical)

## Overview

```
Whoop API ──────────┐
Renpho scale ───────┤
Google Drive PDFs ──┼──> Supabase (PostgreSQL) ──> HTML Dashboards (GH Pages)
Nutrition input ────┘
```

Parallel pipelines:
1. **Whoop fitness data** → Supabase whoop_* tables → Overload Training tab
2. **Renpho body composition** → `body_composition` → Overload Trends body-comp overlay
3. **Nutrition logging** → `nutrition_log` → Overload Nutrition tab (Today + Trends)
4. **Strength training** → `strength_*` → Overload Training tab (Plan / Session / Block / Method)
5. **Medical lab PDFs** → Supabase `labs` → medical HTML dashboards
6. **Medical file management** → Google Drive cleanup

The Overload dashboard at
`https://fernandomartinez-de.github.io/personal/health/fitness/` is rebuilt
daily by `.github/workflows/build-fitness.yml` from these Supabase tables.

## Workflows

### 1. Whoop Daily Sync

**Schedule:** Daily at 8 AM UTC  
**GitHub Action:** `.github/workflows/whoop-daily-sync.yml`  
**Script:** `health/whoop/sync.py`

**Data Flow:**
```
Whoop API
  ↓
GET /v1/recovery (last 7 days)
GET /v1/cycle (last 7 days)
GET /v1/sleep (last 7 days)
GET /v1/workout (last 7 days)
  ↓
health/whoop/sync.py
  ↓
Supabase INSERT (upsert on conflict)
  ↓
Tables: whoop_recovery, whoop_cycles, whoop_sleep, whoop_workouts
```

**Tables Written:**

**whoop_recovery** (one row per day)
- `cycle_id` (bigint, PK)
- `user_id` (int)
- `created_at` (timestamptz)
- `score` (int, 0-100)
- `resting_heart_rate` (int, bpm)
- `hrv_rmssd_milli` (decimal, ms)
- `spo2_percentage` (decimal)
- `skin_temp_celsius` (decimal)

**whoop_cycles** (one row per 24-48hr cycle)
- `id` (bigint, PK)
- `start`, `end` (timestamptz)
- `score` (int, strain score)
- `strain` (decimal)
- `kilojoule` (decimal, energy)
- `average_heart_rate`, `max_heart_rate` (int)

**whoop_sleep** (one row per sleep session)
- `id` (bigint, PK)
- `start`, `end` (timestamptz)
- `nap` (boolean)
- `score` (int, 0-100)
- `stage_summary_total_in_bed_time_milli` (bigint)
- `stage_summary_total_light_sleep_time_milli` (bigint)
- `stage_summary_total_slow_wave_sleep_time_milli` (bigint)
- `stage_summary_total_rem_sleep_time_milli` (bigint)
- `stage_summary_disturbance_count` (int)

**whoop_workouts** (one row per workout)
- `id` (bigint, PK)
- `start`, `end` (timestamptz)
- `sport_id` (int)
- `score`, `strain` (int, decimal)
- `average_heart_rate`, `max_heart_rate` (int)
- `distance_meter`, `altitude_gain_meter` (decimal)
- `zone_duration_zone_zero_milli` through `zone_five_milli` (bigint, HR zones)

**Secrets Required:**
- `WHOOP_CLIENT_ID`
- `WHOOP_CLIENT_SECRET`
- `WHOOP_REFRESH_TOKEN`
- `SUPABASE_DB_URL`
- `GH_PAT` (for updating refresh token)

**Failure Modes:**
- **401 Unauthorized:** Refresh token expired → wait for weekly bootstrap or run manually
- **Connection timeout:** Supabase unreachable → will retry next run
- **Rate limit:** Whoop API throttling → backoff built into sync.py

**Manual Execution:**
```bash
cd health/whoop
export WHOOP_CLIENT_ID=...
export WHOOP_CLIENT_SECRET=...
export WHOOP_REFRESH_TOKEN=...
export SUPABASE_DB_URL=...
python sync.py
```

---

### 2. Whoop Token Refresh

**Schedule:** Weekly Sunday at midnight UTC  
**GitHub Action:** `.github/workflows/whoop-bootstrap-token.yml`  
**Script:** `health/whoop/bootstrap.py`

**Purpose:** Refresh OAuth access token before expiration

**Data Flow:**
```
bootstrap.py
  ↓
POST https://api.prod.whoop.com/oauth/oauth2/token
  (grant_type=refresh_token)
  ↓
New access_token + refresh_token
  ↓
GitHub Secrets API
  (update WHOOP_REFRESH_TOKEN secret via GH_PAT)
```

**Secrets Required:**
- `WHOOP_CLIENT_ID`
- `WHOOP_CLIENT_SECRET`
- `WHOOP_REFRESH_TOKEN` (read + write)
- `GH_PAT` (write:secrets permission)

**Manual Execution:**
```bash
cd health/whoop
export WHOOP_CLIENT_ID=...
export WHOOP_CLIENT_SECRET=...
export WHOOP_REFRESH_TOKEN=...
export GH_PAT=...
export GITHUB_REPOSITORY=fernandomartinez-de/personal
python bootstrap.py
```

---

### 3. Medical Labs Ingest

**Schedule:** Weekly Monday at 9 AM UTC  
**GitHub Action:** `.github/workflows/medical-ingest-labs.yml`  
**Script:** `health/medical/ingest_labs_gdrive.py`

**Data Flow:**
```
Google Drive API
  (G:\My Drive\Personal\Medical\{YEAR}\labs\*.pdf)
  ↓
ingest_labs_gdrive.py
  ↓
PyPDF2 text extraction + regex parsing
  ↓
Supabase INSERT labs table
```

**Source Folder Structure:**
```
Medical/
├── 2018/labs/
├── 2019/labs/
├── 2020/labs/
├── 2021/labs/
├── 2022/labs/
├── 2023/labs/
├── 2024/labs/
├── 2025/labs/
└── 2026/labs/
    ├── 2026-04-17_labs_quest-mx_general.pdf
    └── 2026-03-05_labs_hospital-angeles-lomas_general.pdf
```

**Naming Convention:** `YYYY-MM-DD_labs_{provider}_{test-type}.pdf`

**labs Table:**
- `id` (serial, PK)
- `test_date` (date)
- `provider` (varchar, e.g. "quest-mx", "labcorp", "hospital-angeles-lomas")
- `test_type` (varchar, e.g. "general", "perfil-lipidico", "tiroglobulina")
- `tsh` (decimal, thyroid stimulating hormone)
- `glucose` (decimal)
- `cholesterol_total` (decimal)
- `hdl`, `ldl`, `triglycerides` (decimal)
- `thyroglobulin` (decimal, cancer marker)
- `created_at` (timestamptz)
- `file_path` (varchar, Google Drive path)

**Secrets Required:**
- `GOOGLE_CREDENTIALS` (service account JSON)
- `SUPABASE_DB_URL`

**Failure Modes:**
- **403 Forbidden:** Service account lacks Drive access → reshare folder with service account email
- **Parse errors:** Unrecognized PDF format → manual entry required
- **Duplicate detection:** Same test_date already exists → skips insert

**Manual Execution:**
```bash
cd health/medical
export GOOGLE_CREDENTIALS='{"type":"service_account",...}'
export SUPABASE_DB_URL=...
python ingest_labs_gdrive.py
```

---

### 4. Medical Dashboard Rebuild

**Schedule:** Weekly Monday at 10 AM UTC (after ingest)  
**GitHub Action:** `.github/workflows/medical-rebuild-dashboards.yml`  
**Script:** `health/medical/build_dashboards.py`

**Data Flow:**
```
Supabase SELECT * FROM labs ORDER BY test_date
  ↓
build_dashboards.py (pandas + plotly)
  ↓
HTML files with interactive charts
  ↓
Git commit + push to repo
```

**Output Files:**
- `health/medical/labs_dashboard.html` - All lab results over time
- `health/medical/thyroid_dashboard.html` - TSH + thyroglobulin surveillance
- `health/medical/lipids_dashboard.html` - Cholesterol trends

**Dashboard Features:**
- Line charts for each biomarker over time
- Reference ranges shaded
- Hover tooltips with exact values
- Date range selector
- Standalone HTML (no server required)

**Secrets Required:**
- `GOOGLE_CREDENTIALS`
- `SUPABASE_DB_URL` (read-only query)

**Manual Execution:**
```bash
cd health/medical
export SUPABASE_DB_URL=...
python build_dashboards.py
git add *.html
git commit -m "Update medical dashboards"
git push
```

---

### 5. Renpho Body Composition Daily Pull

**Schedule:** Daily
**GitHub Action:** `.github/workflows/pull-body.yml`
**Target table:** `body_composition`

Daily pull of Renpho scale readings (weight, body-fat %, lean mass, etc.) into
`body_composition`. Feeds the Overload dashboard Trends tab body-comp overlay.

---

### 6. Overload Dashboard Build (Training + Nutrition)

**Schedule:** Daily
**GitHub Action:** `.github/workflows/build-fitness.yml`
**Script:** `health/fitness/build_overload.py`
**Output:** GitHub Pages at
`https://fernandomartinez-de.github.io/personal/health/fitness/`

Rebuilds the Overload static site from Supabase:
- Training tab: Plan / Session / Block / Method views from `strength_*` +
  `whoop_workouts` + `whoop_cycles`
- Nutrition tab: Today (Cronometer-style day view with in vs out and macros
  vs target) and Trends (rolling deficit + `body_composition` overlay), built
  from `nutrition_log`

Data is baked at build time; the page is a static HTML bundle with no runtime
queries.

---

### 7. Medical Drive Cleanup

**Schedule:** Monthly on the 1st at midnight UTC  
**GitHub Action:** `.github/workflows/medical-clean-drive.yml`  
**Script:** `health/medical/clean_medical_drive.py`

**Purpose:** Archive old files from inbox, move finalized labs to year folders

**Data Flow:**
```
Google Drive API scan G:\My Drive\Personal\Medical\_REVISAR\
  ↓
clean_medical_drive.py
  ↓
- Move properly named files to year folders
- Archive files >90 days old
- Flag unrecognized files
```

**Secrets Required:**
- `GOOGLE_CREDENTIALS`

**Manual Execution:**
```bash
cd health/medical
export GOOGLE_CREDENTIALS='...'
python clean_medical_drive.py
```

---

## Dependencies

**Python Packages** (`health/whoop/requirements.txt`, `health/medical/requirements.txt`):
```
requests>=2.28.0
psycopg2-binary>=2.9.0
PyNaCl>=1.5.0
pandas>=2.0.0
plotly>=5.14.0
PyPDF2>=3.0.0
google-api-python-client>=2.0.0
```

**External Services:**
- Whoop API: `https://api.prod.whoop.com`
- Supabase PostgreSQL: Connection string in `SUPABASE_DB_URL`
- Google Drive API: Service account credentials in `GOOGLE_CREDENTIALS`

---

## Vault Cross-References

**Domain knowledge:**
- [[health/thyroid-cancer]] - Medical history and surveillance protocol
- [[health/surveillance-schedule]] - Test frequency and timing
- [[health/test-results-tracker]] - Manual tracking before automation
- [[health/providers]] - Provider contact info
- [[health/insurance]] - Insurance and claims

**Related workflows:**
- [[workflows/tables/gdrive-folders]] - Complete Google Drive structure

**Scripts documentation:**
- All scripts in `health/whoop/` and `health/medical/`
- See repo README for detailed script docs

---

## Future Enhancements

1. **Whoop dashboards:** Create HTML visualization for Whoop data (currently only ingested)
2. **Alerting:** Email/SMS if TSH or thyroglobulin out of range
3. **Mobile access:** Deploy dashboards to static hosting (GitHub Pages)
4. **OCR improvements:** Better PDF parsing for non-standard lab formats
5. **Integration:** Connect medical labs table to personal health vault notes
