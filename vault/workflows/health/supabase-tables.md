---
tags: [health, supabase, tables, schema]
category: health
last_updated: 2026-09-21
---

# Health Supabase Tables

Database tables in Supabase for health data automation workflows.

**Database:** Supabase PostgreSQL  
**Connection:** `SUPABASE_DB_URL` secret  
**Access:** GitHub Actions workflows (write), Dashboards (read)

---

## whoop_recovery

Daily recovery metrics from Whoop API.

**Grain:** One row per calendar day

**Purpose:** Track daily recovery scores, HRV, resting heart rate, and sleep quality indicators

| Column | Type | Description |
|--------|------|-------------|
| `cycle_id` | bigint | Primary key, Whoop cycle identifier |
| `user_id` | int | User identifier |
| `created_at` | timestamptz | When record was synced to Supabase |
| `score` | int | Recovery score 0-100 |
| `user_calibrating` | boolean | Whether user is in calibration phase |
| `recovery_score` | decimal | Detailed recovery percentage |
| `resting_heart_rate` | int | Resting heart rate in bpm |
| `hrv_rmssd_milli` | decimal | Heart rate variability in milliseconds |
| `spo2_percentage` | decimal | Blood oxygen saturation percentage |
| `skin_temp_celsius` | decimal | Skin temperature in Celsius |

**Updated by:** `health/whoop/sync.py` (daily 8 AM UTC)

**Used by:** Future Whoop dashboards (currently ingested only)

---

## whoop_cycles

Physiological cycles (24-48 hour periods of strain and recovery).

**Grain:** One row per cycle

**Purpose:** Track strain scores, heart rate data, and energy expenditure per cycle

| Column | Type | Description |
|--------|------|-------------|
| `id` | bigint | Primary key, Whoop cycle identifier |
| `user_id` | int | User identifier |
| `created_at` | timestamptz | When record was synced to Supabase |
| `start` | timestamptz | Cycle start time |
| `end` | timestamptz | Cycle end time |
| `timezone_offset` | varchar | Timezone offset |
| `score_state` | varchar | Scoring status (scored, pending) |
| `score` | int | Cycle strain score 0-21 |
| `strain` | decimal | Detailed strain metric |
| `kilojoule` | decimal | Energy expenditure in kilojoules |
| `average_heart_rate` | int | Average heart rate during cycle (bpm) |
| `max_heart_rate` | int | Peak heart rate during cycle (bpm) |

**Updated by:** `health/whoop/sync.py` (daily 8 AM UTC)

**Used by:** Future Whoop dashboards

---

## whoop_sleep

Sleep sessions with stage breakdown.

**Grain:** One row per sleep session (naps and primary sleep)

**Purpose:** Track sleep quality, stages, disturbances, and sleep debt

| Column | Type | Description |
|--------|------|-------------|
| `id` | bigint | Primary key, sleep session identifier |
| `user_id` | int | User identifier |
| `created_at` | timestamptz | When record was synced to Supabase |
| `start` | timestamptz | Sleep start time |
| `end` | timestamptz | Sleep end time |
| `timezone_offset` | varchar | Timezone offset |
| `nap` | boolean | True if nap, false if primary sleep |
| `score_state` | varchar | Scoring status |
| `score` | int | Sleep performance score 0-100 |
| `stage_summary_total_in_bed_time_milli` | bigint | Total time in bed (milliseconds) |
| `stage_summary_total_awake_time_milli` | bigint | Time awake (milliseconds) |
| `stage_summary_total_no_data_time_milli` | bigint | Missing data time (milliseconds) |
| `stage_summary_total_light_sleep_time_milli` | bigint | Light sleep duration (milliseconds) |
| `stage_summary_total_slow_wave_sleep_time_milli` | bigint | Deep sleep duration (milliseconds) |
| `stage_summary_total_rem_sleep_time_milli` | bigint | REM sleep duration (milliseconds) |
| `stage_summary_sleep_cycle_count` | int | Number of complete sleep cycles |
| `stage_summary_disturbance_count` | int | Number of disturbances/awakenings |
| `sleep_needed_baseline_milli` | bigint | Baseline sleep need (milliseconds) |
| `sleep_needed_need_from_sleep_debt_milli` | bigint | Additional need from sleep debt (ms) |
| `sleep_needed_need_from_recent_strain_milli` | bigint | Additional need from strain (ms) |
| `sleep_needed_need_from_recent_nap_milli` | bigint | Adjustment from recent naps (ms) |

**Updated by:** `health/whoop/sync.py` (daily 8 AM UTC)

**Used by:** Future Whoop dashboards

---

## whoop_workouts

Workout sessions with heart rate zones and metrics.

**Grain:** One row per workout

**Purpose:** Track workout strain, heart rate zones, distance, and elevation

| Column | Type | Description |
|--------|------|-------------|
| `id` | bigint | Primary key, workout identifier |
| `user_id` | int | User identifier |
| `created_at` | timestamptz | When record was synced to Supabase |
| `start` | timestamptz | Workout start time |
| `end` | timestamptz | Workout end time |
| `timezone_offset` | varchar | Timezone offset |
| `sport_id` | int | Sport/activity type code |
| `score_state` | varchar | Scoring status |
| `score` | int | Workout strain score |
| `strain` | decimal | Detailed strain metric |
| `average_heart_rate` | int | Average heart rate during workout (bpm) |
| `max_heart_rate` | int | Peak heart rate during workout (bpm) |
| `kilojoule` | decimal | Energy expenditure in kilojoules |
| `percent_recorded` | decimal | Percentage of workout captured by device |
| `distance_meter` | decimal | Distance covered in meters |
| `altitude_gain_meter` | decimal | Total elevation gain in meters |
| `altitude_change_meter` | decimal | Net elevation change in meters |
| `zone_duration_zone_zero_milli` | bigint | Time in HR zone 0 (milliseconds) |
| `zone_duration_zone_one_milli` | bigint | Time in HR zone 1 (milliseconds) |
| `zone_duration_zone_two_milli` | bigint | Time in HR zone 2 (milliseconds) |
| `zone_duration_zone_three_milli` | bigint | Time in HR zone 3 (milliseconds) |
| `zone_duration_zone_four_milli` | bigint | Time in HR zone 4 (milliseconds) |
| `zone_duration_zone_five_milli` | bigint | Time in HR zone 5 (milliseconds) |

**Heart Rate Zones:**
- Zone 0: < 50% max HR (very light)
- Zone 1: 50-60% max HR (light)
- Zone 2: 60-70% max HR (moderate)
- Zone 3: 70-80% max HR (hard)
- Zone 4: 80-90% max HR (very hard)
- Zone 5: 90-100% max HR (max effort)

**Updated by:** `health/whoop/sync.py` (daily 8 AM UTC)

**Used by:** Future Whoop dashboards

---

## body_composition

Daily Renpho scale readings.

**Grain:** One row per measurement (typically one per day)

**Purpose:** Track weight and body composition trends; feeds the Overload
dashboard Trends body-comp overlay.

| Column | Type | Description |
|--------|------|-------------|
| `measured_at` | timestamptz | When the reading was taken |
| `weight_kg` | decimal | Total body weight (kg) |
| `body_fat_pct` | decimal | Body fat percentage |
| `lean_mass_kg` | decimal | Lean body mass (kg) |
| `bmi` | decimal | Body Mass Index |
| `visceral_fat` | int | Visceral fat rating |
| `bone_mass_kg` | decimal | Estimated bone mass (kg) |
| `water_pct` | decimal | Body water percentage |
| `metabolic_age` | int | Renpho metabolic age estimate |
| `created_at` | timestamptz | When record was inserted |

**Updated by:** `.github/workflows/pull-body.yml` (daily)

**Used by:** `health/fitness/build_overload.py` (Trends tab body-comp overlay)

---

## nutrition_log

Nutrition entries (meals and macros) surfaced in the Overload Nutrition tab.

**Grain:** One row per logged food entry

**Purpose:** Daily energy in vs out and macros vs target; rolling deficit trend
with body-composition overlay.

| Column | Type | Description |
|--------|------|-------------|
| `id` | serial | Primary key |
| `logged_at` | timestamptz | When the entry was logged |
| `meal` | varchar | Meal label (breakfast / lunch / dinner / snack) |
| `food` | text | Food description |
| `calories` | decimal | kcal |
| `protein_g` | decimal | Protein (g) |
| `carbs_g` | decimal | Carbohydrates (g) |
| `fat_g` | decimal | Fat (g) |
| `fiber_g` | decimal | Fiber (g) |
| `source` | varchar | Entry source (manual, Cronometer, etc.) |
| `created_at` | timestamptz | When record was inserted |

**Used by:** `health/fitness/build_overload.py` - Nutrition tab (Today +
Trends views).

---

## strength_*

Strength training tables backing the Overload Training tab.
Includes program/plan definitions, session logs, block structure, and method
metadata used to render Plan / Session / Block / Method views.

**Grain:** varies by table (plan-level, session-level, set-level).

**Used by:** `health/fitness/build_overload.py` - Training tab.

See `health/fitness/README.md` and the build script for the current schema of
each `strength_*` table.

---

## labs

Medical lab results extracted from PDF reports.

**Grain:** One row per lab test date

**Purpose:** Track thyroid markers, lipid panel, glucose, and other biomarkers over time

| Column | Type | Description |
|--------|------|-------------|
| `id` | serial | Primary key, auto-increment |
| `test_date` | date | Date lab sample was taken |
| `provider` | varchar | Lab provider (e.g. "quest-mx", "labcorp", "hospital-angeles-lomas") |
| `test_type` | varchar | Type of test (e.g. "general", "perfil-lipidico", "tiroglobulina") |
| `tsh` | decimal | Thyroid Stimulating Hormone (mIU/L) |
| `glucose` | decimal | Fasting glucose (mg/dL) |
| `cholesterol_total` | decimal | Total cholesterol (mg/dL) |
| `hdl` | decimal | HDL cholesterol (mg/dL) |
| `ldl` | decimal | LDL cholesterol (mg/dL) |
| `triglycerides` | decimal | Triglycerides (mg/dL) |
| `thyroglobulin` | decimal | Thyroglobulin cancer marker (ng/mL) |
| `created_at` | timestamptz | When record was inserted into Supabase |
| `file_path` | varchar | Google Drive path to source PDF |

**Normal Ranges:**
- TSH: 0.4-4.0 mIU/L
- Glucose: 70-100 mg/dL (fasting)
- Total cholesterol: < 200 mg/dL
- HDL: > 40 mg/dL (men), > 50 mg/dL (women)
- LDL: < 100 mg/dL
- Triglycerides: < 150 mg/dL
- Thyroglobulin: < 1 ng/mL (post-thyroidectomy)

**Updated by:** `health/medical/ingest_labs_gdrive.py` (weekly Monday 9 AM UTC)

**Used by:** `health/medical/build_dashboards.py` (weekly Monday 10 AM UTC)

**Dashboards generated:**
- `health/medical/labs_dashboard.html` - All lab results over time
- `health/medical/thyroid_dashboard.html` - TSH + thyroglobulin surveillance
- `health/medical/lipids_dashboard.html` - Cholesterol trends

---

## Data Retention

All tables retain full history - no automated purging or archiving.

**Storage estimates:**
- Whoop tables: ~365 rows/year per table (daily data)
- Labs table: ~12-24 rows/year (surveillance schedule)

---

## Access Control

**Write access:**
- GitHub Actions workflows with `SUPABASE_DB_URL` secret
- Service accounts only (no direct user writes)

**Read access:**
- Dashboards (public HTML files, query via Supabase client)
- Future: Mobile app or web interface

**No Row Level Security:**
- Single user system
- No multi-tenant access
- Connection string is secret, not publishable key

---

## Backup

Supabase provides automatic backups for paid plans.

**Current backup strategy:**
- Supabase automatic backups (verify plan)
- Consider: Periodic export to CSV via GitHub Actions
- Source data preserved in: Whoop API (7-day history), Google Drive PDFs (permanent)

---

## Schema Management

**Migrations:** No formal migration system (single user, evolving schema)

**Schema changes:**
1. Add column with ALTER TABLE
2. Update Python scripts to populate new column
3. Backfill if needed via one-time script

**No ORMs:** Direct SQL via psycopg2

---

## Related Files

**Workflow documentation:** [[health/health-data-pipeline]]

**Scripts that write to these tables:**
- `health/whoop/sync.py`
- `health/medical/ingest_labs_gdrive.py`

**Scripts that read from these tables:**
- `health/medical/build_dashboards.py`
