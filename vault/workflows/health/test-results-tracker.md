# Test Results Tracker

Recent lab results and trends for thyroid cancer surveillance.

**For real-time dashboard:** https://fernandomartinez-de.github.io/vital-signal-reports/

---

## Most Recent Thyroglobulin

**Date:** March 5, 2026  
**Value:** 9.96 ng/mL (stimulated)  
**Status:** Within normal range for stimulated test  
**Next test due:** September 2026

**Trend:** (Review dashboard for historical trend)

---

## Key Markers

### Thyroglobulin (Tumor Marker)
**Target:** < 1.0 ng/mL unstimulated, < 10 ng/mL stimulated  
**Frequency:** Every 6 months  
**Critical:** Must trend toward zero and remain stable

### TSH (Thyroid Stimulating Hormone)
**Target:** 0.5 - 4.5 mIU/L (may be suppressed intentionally)  
**Frequency:** Every 6 months  
**Purpose:** Monitor thyroid hormone replacement dosing

### Free T4
**Target:** 0.8 - 1.8 ng/dL  
**Frequency:** Every 6 months  
**Purpose:** Verify adequate thyroid hormone replacement

---

## Where Results Are Stored

**Supabase database:**  
- Table: `labs`
- Automated ingestion from Google Drive PDFs
- Powering HTML dashboards

**Google Drive:**  
`G:\My Drive\Personal\Medical\{YEAR}\labs\`

**Dashboard:**  
https://fernandomartinez-de.github.io/vital-signal-reports/

---

## How to Add New Results

### Automated (Preferred)
1. Drop lab PDF into: `G:\My Drive\Personal\Medical\{YEAR}\labs\`
2. GitHub Actions runs weekly ingestion (Monday 9 AM UTC)
3. Results appear in dashboard automatically

### Manual
Run: `C:\Users\fmartine\Personal\repos\personal\health\medical\ingest_labs_gdrive.py`

---

## Historical Data

**Complete lab history:** 2018-2026  
**Source PDFs:** G:\My Drive\Personal\Medical\{2018-2026}\labs\  
**Database:** Supabase `labs` table  
**Backup:** GitHub Actions exports (if enabled)

---

**Related:**
- [[surveillance-schedule]] - When next tests are due
- [[dashboards]] - Dashboard URLs and access
- [[health-data-pipeline]] - How data flows from PDFs to dashboards
