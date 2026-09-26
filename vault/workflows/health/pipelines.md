# Health Data Pipelines

Overview of automated health data workflows.

**For comprehensive details:** See [[health-data-pipeline]]

---

## What Runs Automatically

### Daily: Whoop Fitness Data Sync
**Schedule:** 8 AM UTC (3 AM EST) daily  
**Script:** `personal/health/whoop/sync.py`  
**Workflow:** `.github/workflows/whoop-daily-sync.yml`
**What it does:**
- Fetches previous day's fitness data from Whoop API
- Stores recovery, sleep, cycles, and workouts in Supabase
- Powers Overload dashboard training tab

---

### Daily: Renpho Body Composition Pull
**Schedule:** Daily  
**Workflow:** `.github/workflows/pull-body.yml`  
**What it does:**
- Pulls Renpho scale readings into Supabase `body_composition`
- Feeds the Overload dashboard body-comp overlay + Trends tab

---

### Daily: Overload Dashboard Build
**Schedule:** Daily  
**Workflow:** `.github/workflows/build-fitness.yml`  
**What it does:**
- Rebuilds the health/fitness "Overload" training + nutrition dashboard
  (GitHub Pages) from Supabase (`body_composition`, `whoop_*`, `strength_*`,
  `nutrition_log`)
- Publishes to https://fernandomartinez-de.github.io/personal/health/fitness/
- Top-level Training | Nutrition segmented control; Nutrition tab surfaces
  `nutrition_log` (Cronometer-style Today view + Trends with rolling deficit
  and body-comp overlay)

**Data collected:**
- Recovery score
- HRV (heart rate variability)
- Resting heart rate
- Sleep stages and performance
- Workout strain and calories

---

### Weekly: Medical Labs Ingestion
**Schedule:** Monday 9 AM UTC  
**Script:** `personal/health/medical/ingest_labs_gdrive.py`  
**What it does:**
- Scans `G:\My Drive\Personal\Medical\{YEAR}\labs\` for new PDFs
- Extracts key values: thyroglobulin, TSH, free T4
- Inserts into Supabase `labs` table
- Enables dashboard to show trends

**How to add new labs:**
1. Drop PDF into Google Drive labs folder
2. Wait for Monday 9 AM (or run script manually)
3. Results appear in dashboard

---

### Weekly: Medical Dashboard Rebuild
**Schedule:** Monday 10 AM UTC (after labs ingestion)  
**Script:** `personal/health/medical/build_dashboards.py`  
**What it does:**
- Queries latest data from Supabase `labs` table
- Generates HTML dashboards with charts
- Deploys to GitHub Pages

**Dashboards generated:**
- martinez_oncologist_dashboard.html (for Dra. Escobar)
- martinez_nutritionist_dashboard.html (for Javier)
- Combined medical overview

---

### Monthly: Google Drive Cleanup
**Schedule:** 1st day of month, midnight UTC  
**Script:** `personal/health/medical/clean_medical_drive.py`  
**What it does:**
- Scans `G:\My Drive\Personal\Medical\_REVISAR\`
- Suggests year/category for unfiled PDFs
- Moves confirmed files to proper folders
- Standardizes file naming

**Mom's role:**
- Checks `_REVISAR` folder when notified
- Confirms suggested filing locations
- Ensures all medical files are properly categorized

---

## Data Flow Diagram

```
┌─────────────────────┐
│   Data Sources      │
├─────────────────────┤
│ Whoop API           │──────┐
│ Google Drive PDFs   │──────┤
└─────────────────────┘      │
                             v
                  ┌──────────────────┐
                  │  GitHub Actions  │
                  │  (Automation)    │
                  └──────────────────┘
                             │
                             v
                  ┌──────────────────┐
                  │    Supabase      │
                  │  (PostgreSQL)    │
                  ├──────────────────┤
                  │ whoop_recovery   │
                  │ whoop_sleep      │
                  │ whoop_cycles     │
                  │ whoop_workouts   │
                  │ labs             │
                  └──────────────────┘
                             │
                             v
                  ┌──────────────────┐
                  │ HTML Dashboards  │
                  │ (GitHub Pages)   │
                  └──────────────────┘
```

---

## Manual Processes

**No automation yet:**
- InBody composition data (Javier provides manually)
- Imaging reports (PET, ultrasound) - stored in Google Drive only
- Medication tracking - not automated

---

## Monitoring

**Check workflow status:**
https://github.com/fernandomartinez-de/personal/actions

**If a workflow fails:**
1. Check GitHub Actions logs
2. Verify secrets are current (Settings → Secrets)
3. Check external service availability (Whoop, Google Drive, Supabase)
4. Review [[workflows/tech/troubleshooting]] for common issues

---

## Secrets Required

Stored in GitHub repository secrets:
- `WHOOP_CLIENT_ID` - Whoop OAuth app ID
- `WHOOP_CLIENT_SECRET` - Whoop OAuth secret
- `WHOOP_REFRESH_TOKEN` - Auto-updated weekly
- `GOOGLE_CREDENTIALS` - Service account JSON
- `SUPABASE_DB_URL` - PostgreSQL connection string
- `GH_PAT` - GitHub personal access token

---

**Full documentation:** [[health-data-pipeline]]  
**Script details:** [[health/scripts]]  
**Database schemas:** [[supabase-tables]]
