---
type: life-admin
last_updated: 2026-09-27
related: [[life-admin/credit-banking]], [[life-admin/real-estate]], [[workflows/finances/finances-automation]], [[workflows/tech/lyftr-app]]
---

# Expenses

Day-to-day spending is captured in Supabase `expense_transactions`. There are
two ways rows land in that table:

## 1. Automated: Plaid Chase Pull (routine)

**Status:** LIVE since 2026-09-21.

- Daily GitHub Action `.github/workflows/pull-finances.yml`, cron
  `0 13 * * *` (09:00 ET).
- Script: `finances/scripts/plaid_chase_sync.py`.
- Calls Plaid `/transactions/sync`, upserts into `expense_transactions`,
  categorized against `category_mapping`.
- Cursor state kept in `plaid_sync_state`; account map in `plaid_accounts`.
- Three Chase accounts wired up: Total Checking (…6813), Freedom Unlimited
  (…5113), Sapphire Preferred (…4433).

Details in [[workflows/finances/finances-automation]].

## 2. Manual: Chase Excel Drop (fallback)

If the Plaid pull is broken or something needs backfilling, the old manual
flow still works:

1. Download the three Chase account exports (Excel) from `chase.com`.
2. Drop them in `vault/ops/incoming/`.
3. Double-click `docs/PROCESS_INBOX.bat` (a.k.a. START.bat) — runs
   `process_personal_inbox.py`, classifies, renames, files into Google
   Drive, and hands off to `load_bronze.py` for the Supabase upsert.

## Consumers

- **v1 (Overload / static):** `finances/finances.html` reads Supabase
  directly, categorized fixed costs + discretionary trends.
- **v2 (Lyftr / React):** [[workflows/tech/lyftr-app]] Finances → Expenses
  page (route `/finances`) with income & expenses list, category
  distribution heatmap, net-remaining trend, and a PIN-gated Monthly
  Payroll row. Sensitive values (payroll) are hidden behind a 4-digit
  reveal (`3221`).

## Recent changes

- **2026-09-21:** Chase OAuth cleared Plaid review; first daily run
  reconciled clean with 64 transactions.
- **2026-09-27:** `finances/scripts/plaid_chase_sync.py` is now the canonical
  path (root-level copies removed). `pull-finances.yml` updated.
