---
type: family
last_updated: 2026-09-14
related: [[workflows/health/pipelines]], [[family/emergency-contacts]]
---

# Mom

**Name:** Ana Irene Rangel Blanco
**Location:** Mexico City, Mexico
**Phone:** +52 55 4899 1470
**Email:** anarb123@hotmail.com
**Preferred contact method:** WhatsApp / Phone

## Role in Medical File Management

Mom actively helps manage medical documents in Google Drive.

**Workflow:**
1. Fernando or Mom drops medical files (labs, scans, reports) into G:\My Drive\Personal\Medical\
2. Sort by hand into correct `{year}/{category}/` folder (labs, radiologia, ultrasonidos, inbody)
3. Cleaner pipeline runs nightly (7am UTC), renames files to standard format `YYYY-MM-DD_category_provider_detail.ext`
4. Cleaner moves unclear files to `Medical/_REVISAR` with `REVISAR_` prefix
5. **Mom checks `_REVISAR` folder daily**, sorts those files manually into correct year/category folders
6. Once a file is out of `_REVISAR` and properly named, ingest pipeline picks it up next run

**Why this matters:**
- Thyroid surveillance depends on complete lab history (especially thyroglobulin trending)
- Files left in `_REVISAR` never get ingested into dashboards
- Dra. Escobar's dashboard won't show lab trends unless files are properly processed

**Access:**
- Mom has Google Drive access to Medical folder (G:\My Drive\Personal\Medical)
- Service account also has Editor access (for cleaner automation)

**Communication:**
- Fernando sends WhatsApp when new medical files need sorting
- Mom replies when `_REVISAR` folder is clear

## Emergency Contact

Mom is primary emergency contact if Fernando is hospitalized or unreachable.

**What she needs to know:**
- Thyroid cancer history (see [[quick-ref/emergency]])
- Current providers: Dra. Escobar (oncóloga), Javier (nutriólogo)
- Dashboard URLs (for sharing updated data with doctors)
- Insurance info (see [[workflows/health/insurance]])

**Emergency brief:** See [[quick-ref/emergency]] for full medical summary to share with ER/providers

## Travel Coordination

**When Fernando travels to Mexico for medical care:**
- Mom may coordinate appointments
- Mom may accompany to Hospital Angeles for major procedures
- Mom helps with translation if needed (though providers speak Spanish)

## Document Locations

Mom knows where to find:
- Medical files: G:\My Drive\Personal\Medical
- Insurance: G:\My Drive\Personal\Insurance
- Key IDs: G:\My Drive\Personal\ID
- Dashboards: https://fernandomartinez-de.github.io/vital-signal-reports/
