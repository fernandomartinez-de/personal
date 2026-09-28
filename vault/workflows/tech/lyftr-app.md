---
type: workflow
category: tech
status: active
last_updated: 2026-09-27
related: [[workflows/tech/README]], [[workflows/tech/infrastructure]], [[workflows/finances/finances-automation]], [[workflows/health/dashboards]], [[life-admin/investments]], [[life-admin/retirement]], [[life-admin/expenses]]
---

# Lyftr — v2 React Dashboard

The **Lyftr** app is the v2 React front-end for the personal-life dashboards.
It lives inside the repo at `exercise-app/` and coexists with
the v1 **Overload** static HTML dashboards. Both read from the same Supabase
tables; they are two different presentation layers on top of one data plane.

## Stack

- **React 18** + **Vite** + **react-router-dom** (SPA)
- **Supabase JS anon client** (`@supabase/supabase-js`), configured in
  `src/supabaseClient.js` from `VITE_SUPABASE_URL` / `VITE_SUPABASE_ANON_KEY`
- Inline SVG charts + a few React Bits micro-components:
  - **Galaxy** background across all non-hub routes
  - **WebThreads** hero background on the hub only
  - **RubberSegment** — bottom nav on every section
  - **SquishSwitch** — binary toggles (e.g., abnormal-only)
  - **CodeSlots** — 4-digit PIN gate for sensitive values
- `motion` (Framer Motion 11) drives the React Bits interactions
- `ogl` powers the WebGL Galaxy + Threads shaders
- `@hugeicons/react` provides the CodeSlots success glyph

## Routing structure (`src/App.jsx`)

The hub at `/` is a landing page that fans out to three sections. Every
non-hub route sits on top of the Galaxy fixed background; the hub layers a
WebThreads canvas over it.

| Route | Component | Section |
| --- | --- | --- |
| `/` | `HubPage` | Hub (Finances / Fitness / Medical cards) |
| `/fitness` | `HomePage` | Fitness home |
| `/exercises`, `/exercise/:id` | `ExerciseListPage`, `ExerciseDetailPage` | Fitness |
| `/workouts`, `/workout/:id` | `WorkoutsPage`, `WorkoutDetailPage` | Fitness |
| `/programs` | `ProgramsPage` | Fitness |
| `/food` | `FoodPage` | Fitness |
| `/weight` | `WeightPage` | Fitness |
| `/finances` | `FinancesExpensesPage` | Finances → Expenses |
| `/finances/investments` | `FinancesInvestmentsPage` | Finances → Investments |
| `/medical`, `/medical/oncologist` | `MedicalPage dashboard="oncologist"` | Medical |
| `/medical/nutritionist` | `MedicalPage dashboard="nutritionist"` | Medical |

Legacy files `FinancesOverviewPage.jsx`, `FinancesDashboardPage.jsx`, and
`HomePageNew.jsx` are still in the tree but are no longer routed.

## Bottom navigation

A single **RubberSegment** at the bottom of the viewport shows different
items depending on which section you're in. Each variant always includes a
**Menu** item that jumps back to the hub `/`.

- **Fitness routes** — Home / Exercises / Workouts / Programs / Food /
  Weight / Menu
- **Finances routes** — Expenses / Investments / Menu
- **Medical routes** — Oncologist / Nutritionist / Menu

## Reads (Supabase tables)

- Hub: `stocks_crypto_history`, `real_estate_history`, `whoop_cycles`,
  `whoop_recovery`, `lab_results` (latest TSH + Thyroglobulin for the
  Medical card)
- Finances → Expenses: `expense_transactions`,
  `vw_dashboard_summary`, `vw_fixed_costs_summary`,
  `vw_discretionary_summary`, RPC `get_dashboard_stats`
- Finances → Investments: `stocks_crypto_history`, `real_estate_history`
  (Zillow + Redfin averaged for Condo)
- Medical → Oncologist: `lab_results` (grouped by 11 canonical panels;
  see [[workflows/finances/finances-automation]] neighbours),
  `whoop_recovery`, `body_composition`
- Medical → Nutritionist: `nutrition_log`, `body_composition` (Renpho
  scale), `inbody_results`, `lab_results` (nutrition-relevant markers)

## Writes (on demand)

The Investments tab has a manual **↻ Refresh Prices** button that pulls
live prices from Finnhub (stocks), CoinGecko (crypto), and Zillow via
RapidAPI (property), then upserts a fresh snapshot into
`stocks_crypto_history` / `real_estate_history`. The scheduled Fidelity
Plaid job (see [[workflows/finances/finances-automation]]) writes
`Retirement` / `Brokerage` rows independently — the two never overwrite
each other's asset classes.

## PIN-gated values

Two values are hidden behind a 4-digit code (`3221`) using the CodeSlots
micro-interaction:

- Hub → Finances card → Portfolio total
- Finances → Expenses → Monthly Payroll row (and derived Net Remaining)

Entering the correct code flips the tile from `••••` to the live value;
"lock again" restores it.

## Medical dashboards

Previously the Medical section rendered the v1 static HTML dashboards
(`martinez_oncologist_dashboard.html`, `martinez_nutritionist_dashboard.html`)
inside an iframe. In the 2026-09-27 rebuild those were unmounted and
replaced with native React views:

- **Oncologist** — Thyroid Panel tiles → Reference Range Meters
  (thyroid-relevant) → Marker Trend chart → Recovery & Resilience (WHOOP) →
  Body Composition trend → Panel Health rings (11 canonical categories,
  each clickable to a table modal) → Lab Master table (latest-per-marker
  master with abnormal-only toggle and per-visit date filter).
- **Nutritionist** — Renpho Scale (weight + BF % + composition ring, own
  date filter) → InBody Scan Comparison (baseline vs current pickers) →
  Calorie / Macro trend charts (rolling averages) → Meal Distribution
  donut → Composition Over Time (per-metric small multiples) → InBody
  Composition (own scan-date filter) → Nutrition Labs reference-range
  meters (vitamins, minerals, lipids, metabolic markers).

Panel names are normalized to 11 canonical categories both client-side
(React) and server-side (see the panel normalizer in
`health/medical/ingest_labs_gdrive.py`) so raw SQL and the app agree.

## Relationship to v1 Overload

Both apps ship in the same repo and are served together via GitHub Pages.

| | v1 Overload (static) | v2 Lyftr (React) |
| --- | --- | --- |
| Location | `finances/finances.html`, `health/fitness/overload.html` (built weekly from `template.html` + `app.js`), `health/medical/medical.html` | `exercise-app/` (Vite build) |
| Data | Reads Supabase directly via the JS anon client | Same tables, wrapped in a routed SPA |
| Charts | Chart.js CDN + vanilla JS | Inline SVG (custom) + a handful of React Bits |
| Refresh loop | User clicks buttons on the page | Same buttons, plus scheduled GitHub Actions writing to Supabase |
| Landing | Repo root `index.html` fans out to the three v1 HTML pages | Own hub at `/` with three routed cards |

The v1 pages are still live and are the fallback if the v2 build breaks;
the v2 hub is the daily driver.

## Deploying

```
cd exercise-app
npm install
npm run build        # verify locally
```

The v2 build is not on a GitHub Actions schedule — deployment currently
happens manually or via GitHub Pages when the `dist/` output is committed.

## Cross-links

- Data plane: [[workflows/tech/infrastructure]] (Supabase overview)
- Automated writes: [[workflows/finances/finances-automation]]
- Ingest-side helpers: `health/medical/ingest_labs_gdrive.py` (panel
  normalizer keeps the v2 category rings honest)
- Life-admin usage: [[life-admin/expenses]], [[life-admin/investments]],
  [[life-admin/retirement]]
