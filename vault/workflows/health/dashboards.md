# Medical Dashboards

HTML dashboards for visualizing health data trends.

**Live dashboards:** https://fernandomartinez-de.github.io/vital-signal-reports/

---

## Available Dashboards

### Oncologist Dashboard
**URL:** https://fernandomartinez-de.github.io/vital-signal-reports/martinez_oncologist_dashboard.html

**For:** Dra. Elizabeth Escobar Arriaga (Hospital Angeles Lomas)

**Contains:**
- Thyroglobulin trend (tumor marker)
- TSH, free T4 (thyroid function)
- Historical lab results (2018-2026)
- PET scan dates and outcomes
- Surveillance schedule

**Update frequency:** Weekly (Monday 10 AM UTC after lab ingestion)

---

### Nutritionist Dashboard
**URL:** https://fernandomartinez-de.github.io/vital-signal-reports/martinez_nutritionist_dashboard.html

**For:** Javier Luna Morán (MNC, Mexico City)

**Contains:**
- InBody composition trends (when available)
- Weight, body fat %, muscle mass
- Whoop fitness data (HRV, resting HR, recovery)
- Workout strain and sleep performance
- Nutrition-relevant metrics

**Update frequency:** Weekly (Monday 10 AM UTC)

---

### Combined Medical Overview
**URL:** https://fernandomartinez-de.github.io/vital-signal-reports/

**For:** Personal use, sharing with any provider

**Contains:**
- All lab results in one view
- Fitness data (Whoop)
- Medical history summary
- Upcoming appointments
- Provider contact info

---

## How Dashboards Are Built

**Source data:** Supabase tables (`labs`, `whoop_recovery`, `whoop_sleep`, etc.)  
**Script:** `personal/health/medical/build_dashboards.py`  
**Schedule:** Weekly Monday 10 AM UTC (GitHub Actions)  
**Deployment:** GitHub Pages (fernandomartinez-de.github.io/vital-signal-reports)

**Chart library:** Chart.js (client-side rendering)  
**Data embedded:** JSON in HTML (self-contained, no API calls)

---

## Sharing with Providers

**To share:**
1. Send dashboard URL to provider
2. Or: Print to PDF and bring to appointment
3. Or: Screenshot relevant charts

**No login required:** Dashboards are public (no sensitive identifiers, just data trends)

**Language:** Currently in English (can generate Spanish version if needed)

---

## Updating Dashboards

### Automatic (Weekly)
- GitHub Actions rebuilds every Monday 10 AM UTC
- New lab data from Google Drive appears automatically
- Whoop data refreshes daily

### Manual (Immediate Update)
Run locally:
```bash
cd C:\Users\fmartine\Personal\repos\personal\health\medical
python build_dashboards.py
git add .
git commit -m "Update dashboards"
git push
```

Dashboards update on GitHub Pages within 1-2 minutes.

---

## Data Sources

**Labs table (Supabase):**
- Thyroglobulin, TSH, free T4
- CBC, comprehensive metabolic panel
- Lipid panel
- Source: Google Drive PDFs → automated ingestion

**Whoop tables (Supabase):**
- Recovery, HRV, resting HR
- Sleep stages and performance
- Workout strain and calories
- Source: Whoop API → daily sync

**InBody data:**
- Currently manual (not automated)
- Javier provides reports every 2-3 months
- Future: OCR from PDF reports

---

## Dashboard Storage

**Repository:** https://github.com/fernandomartinez-de/vital-signal-reports  
**Branch:** `gh-pages` (GitHub Pages auto-deployment)  
**Local copy:** (Add path if keeping local backups)

**Backup:**
- GitHub (version controlled)
- Supabase (source data)
- Google Drive (original PDFs)

---

## Troubleshooting

**Dashboard not updating:**
1. Check GitHub Actions status
2. Verify build_dashboards.py ran successfully
3. Check Supabase for recent data
4. Hard refresh browser (Ctrl+Shift+R)

**Missing data on dashboard:**
1. Verify lab PDF is in Google Drive
2. Check ingestion ran (Monday 9 AM)
3. Review Supabase `labs` table
4. Check PDF naming matches expected format

**Charts not rendering:**
1. Check browser console for JS errors
2. Verify Chart.js CDN accessible
3. Confirm JSON data embedded correctly

---

**Related:**
- [[pipelines]] - How data flows to dashboards
- [[test-results-tracker]] - Latest lab results
- [[health-data-pipeline]] - Complete automation docs
- [[health/scripts]] - Script details for build_dashboards.py
