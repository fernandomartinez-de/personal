# Vault Index

Complete inventory of all vault files organized by folder.

## /workflows/ - Automation & Technical Documentation

### workflows/health/ (10 files)
- [[workflows/health/health-data-pipeline]] - Whoop + Renpho body-comp + nutrition + Overload dashboard + medical labs overview
- [[workflows/health/thyroid-cancer]] - Diagnosis, treatment history, current surveillance status
- [[workflows/health/surveillance-schedule]] - What test when, next due dates, provider locations
- [[workflows/health/test-results-tracker]] - Thyroglobulin trending, imaging findings, lab history
- [[workflows/health/providers]] - Dra. Escobar, Javier, facilities US and Mexico, contacts
- [[workflows/health/pipelines]] - Whoop / Renpho body pull / Overload dashboard build automations
- [[workflows/health/dashboards]] - GitHub Pages access, what each dashboard shows, update schedule
- [[workflows/health/insurance]] - Coverage both countries, claims process, contacts
- [[workflows/health/scripts]] - Health automation scripts documentation
- [[workflows/health/supabase-tables]] - Health schemas incl. `body_composition`, `nutrition_log`, `strength_*`, Whoop tables, labs

### workflows/finances/ (5 files)
- [[workflows/finances/finances-automation]] - Chase transactions pull LIVE (2026-09-21) + weekday Fidelity investments pull + expense tracking + budgets
- [[workflows/finances/scripts]] - `plaid_link.py`, `plaid_sync.py`, `plaid_investments_link.py`, `plaid_investments_sync.py`, plus property value + backfill scripts
- [[workflows/finances/supabase-tables]] - Finance schemas incl. `plaid_sync_state`, `plaid_accounts`, `expense_transactions.plaid_transaction_id` unique index, `stocks_crypto_history` now also carries Plaid Retirement/Brokerage holdings, `category_mapping` gained `Fees` category
- [[workflows/finances/credit-banking]] - Chase Freedom/Unlimited, Amex extension, banking
- [[workflows/finances/report]] - Budget rules and notification configuration (TBD)

### workflows/docs/ (2 files)
- [[workflows/docs/docs-automation]] - Inbox processing + expiration scanning
- [[workflows/docs/scripts]] - Document processing scripts documentation

### workflows/travel/ (3 files)
- [[workflows/travel/travel-automation]] - Trip planning sites
- [[workflows/travel/scripts]] - Travel scripts documentation
- [[workflows/travel/supabase-tables]] - Travel data database schemas

### workflows/tech/ (4 files)
- [[workflows/tech/README]] - Tech infrastructure overview
- [[workflows/tech/infrastructure]] - System architecture and services
- [[workflows/tech/services]] - Service credentials and endpoints
- [[workflows/tech/troubleshooting]] - Common issues and fixes

### workflows/scripts/ (1 file)
- [[workflows/scripts/README]] - Central script documentation index

### workflows/tables/ (1 file)
- [[workflows/tables/gdrive-folders]] - Complete Google Drive folder structure

### workflows/ root (1 file)
- [[workflows/README]] - Workflow status dashboard

---

## /identity/ - Personal Identity Documents (4 files)
- [[identity/citizenship]] - Spain, Mexico, Canada passports (numbers, expiry, consulates)
- [[identity/visas]] - TN status, I-94, renewal timeline, attorney contact
- [[identity/licenses]] - NY drivers license, expiry, DMV
- [[identity/ssn]] - Number location, use restrictions

---

## /life-admin/ - Administrative & Financial (12 files)
- [[life-admin/real-estate]] - 66 S 6th Street purchase, mortgage, insurance, HOA, tax
- [[life-admin/property-deed]] - Official deed details (TBD - to extract from ACRIS)
- [[life-admin/taxes]] - Cross-border situation, preparer, deadlines, return locations
- [[life-admin/employment]] - SS&C current, NYDIS/Kyriba history, retirement accounts
- [[life-admin/retirement]] - Fidelity 401(k), contributions, beneficiary status
- [[life-admin/investments]] - Morgan Stanley, Coinbase, statement locations
- [[life-admin/expenses]] - Tracking file location, categories
- [[life-admin/credit-banking]] - Chase account details and credit cards
- [[life-admin/travel]] - TSA PreCheck eligibility, loyalty programs, travel docs
- [[life-admin/digital-life]] - Email, Apple Keychain, subscriptions, 2FA status
- [[life-admin/will]] - Last will and testament, POA, healthcare proxy planning
- [[life-admin/property-deed]] - NYC condo deed (download from ACRIS)
- [[life-admin/will]] - Will creation checklist (TBD)

---

## /family/ - Family & Emergency Contacts (5 files)
- [[family/mom]] - Ana Irene - Role in medical file management, access, contacts
- [[family/dad]] - Ramon - Contact information
- [[family/diego]] - Brother - Contact information
- [[family/mariana]] - Sister - Contact information
- [[family/emergency-contacts]] - Who to call, in what order, for what

---

## /ops/ - Operations & Task Management (3 folders)

### ops/incoming/ (1 file)
- [[ops/incoming/README]] - Inbox for document processing

### ops/outgoing/ (3 folders + 1 file)
- [[ops/outgoing/README]] - Generated reports and outputs
- ops/outgoing/docs/ - Document processing logs
- ops/outgoing/travel/ - Trip planning documents
- ops/outgoing/docs/REDFIN_SETUP.md - Redfin automation setup guide

### ops/outstanding/ (1 file)
- [[ops/outstanding/README]] - Action items and incomplete vault entries (31 items)

---

## /quick-ref/ - Quick Reference Sheets (4 files)
- [[quick-ref/emergency]] - What ER needs to know (thyroid history, medication, contacts)
- [[quick-ref/renewals]] - Everything that expires with dates
- [[quick-ref/documents-index]] - Where is X - quick lookup
- [[quick-ref/key-dates]] - Next PET scan, thyroglobulin, visa renewal, tax deadlines

---

## /root/ - Top-Level Documentation (3 files)
- [[README]] - Vault overview and structure
- [[SUMMARY]] - Executive summary and vault status (100% complete)
- [[VAULT_INDEX]] - Master navigation index for agents

---

**Total:** 60+ files across 7 main folders
**Last updated:** 2026-09-21

**Security note (2026-09-21):** This vault was removed from the public repo and
scrubbed from git history. It is now local only and gitignored; do not commit
anything under `vault/`.
