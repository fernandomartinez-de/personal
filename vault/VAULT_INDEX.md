# Vault Index

Master index for Fernando's personal vault - a brain for agents and digital workers.

## What This Vault Is

A structured knowledge base covering:
- Personal health data and medical history
- Identity documents and visa/citizenship tracking
- Life admin (taxes, employment, retirement, real estate)
- Family and emergency contacts
- Automation workflows and data pipelines
- Technical infrastructure (Whoop, medical dashboards, document filing)

## For Agents: Start Here

**Building or debugging automation?** → [[workflows/README]] - Four comprehensive workflow domains (health, docs, finances, travel) with data flows, tables, scripts, and failure modes

**Working with personal documents?** → [[workflows/tables/gdrive-folders]] - Complete Google Drive structure and naming conventions

**Technical troubleshooting?** → [[workflows/tech/README]] - Infrastructure, services, troubleshooting guides, disaster recovery

**Health information?** → [[workflows/health/health-data-pipeline]] - Medical history, surveillance, providers, insurance, dashboards

**Looking up personal context?** → [[identity/citizenship]], [[life-admin/employment]], [[family/mom]] - domain knowledge

**Emergency information?** → [[quick-ref/emergency]] - ER brief to print and save

**Quick reference?** → [[quick-ref/key-dates]] - emergency brief, renewals, key dates, document index

## Vault Structure

```
vault/
├── VAULT_INDEX.md         # This file - master entry point
├── README.md              # Vault overview
├── index.md               # Original index (keep for Obsidian)
├── SUMMARY.md             # Executive summary
├── workflows/             # Comprehensive automation documentation
│   ├── README.md          # Workflow status dashboard
│   ├── health/
│   │   ├── health-data-pipeline.md      # Whoop + medical labs + dashboards
│   │   ├── thyroid-cancer.md            # Detailed medical history
│   │   ├── surveillance-schedule.md     # Test schedules
│   │   ├── test-results-tracker.md      # Lab results and trends
│   │   ├── insurance.md                 # Insurance details
│   │   ├── providers.md                 # Healthcare providers
│   │   ├── pipelines.md                 # Automation overview
│   │   ├── dashboards.md                # Dashboard URLs
│   │   ├── scripts.md                   # Script documentation
│   │   └── supabase-tables.md           # Database schemas
│   ├── docs/
│   │   ├── docs-automation.md           # Inbox processing + expiration scanning
│   │   └── scripts.md                   # Script documentation
│   ├── finances/
│   │   ├── finances-automation.md       # Statements + expense tracking + budgets
│   │   ├── scripts.md                   # Script documentation
│   │   ├── supabase-tables.md           # Database schemas
│   │   └── credit-banking.md            # Credit cards and banking
│   ├── travel/
│   │   ├── travel-automation.md         # Trip planning sites
│   │   ├── scripts.md                   # Script documentation
│   │   └── supabase-tables.md           # Database schemas
│   ├── scripts/           # Central script documentation index
│   │   └── README.md      # Links to all domain scripts
│   ├── tables/            # Reference tables
│   │   └── gdrive-folders.md            # Google Drive structure
│   └── tech/              # Technical infrastructure
│       ├── README.md                    # Tech overview
│       ├── infrastructure.md            # System architecture
│       ├── services.md                  # Service credentials and endpoints
│       ├── troubleshooting.md           # Common issues and fixes
│       └── recovery.md                  # Disaster recovery procedures
├── identity/              # Citizenship, visas, licenses
│   ├── citizenship.md
│   ├── visas.md
│   ├── licenses.md
│   └── ssn.md
├── life-admin/            # Taxes, employment, finances
│   ├── taxes.md
│   ├── employment.md
│   ├── retirement.md
│   ├── investments.md
│   ├── credit-banking.md
│   ├── expenses.md
│   ├── real-estate.md
│   ├── will.md
│   ├── property-deed.md
│   ├── travel.md
│   └── digital-life.md
├── family/                # Emergency contacts and family
│   ├── mom.md
│   ├── dad.md
│   ├── diego.md
│   ├── mariana.md
│   └── emergency-contacts.md
├── ops/                   # Operational workflows
│   ├── incoming/          # Input: files you drop for processing
│   │   └── README.md
│   ├── outgoing/          # Output: generated reports and documents
│   │   ├── docs/          # Processing logs, expiration reports
│   │   └── travel/        # Trip planning documents
│   └── outstanding/       # Action items tracker
│       └── README.md
└── quick-ref/             # Quick lookup references
    ├── renewals.md
    ├── emergency.md       # ER brief (print and save)
    ├── key-dates.md
    └── documents-index.md
```

## Data Flow Overview

```
┌─────────────────────┐
│   Data Sources      │
├─────────────────────┤
│ Whoop API           │──┐
│ Google Drive PDFs   │──┼──> GitHub Actions
│ Personal Docs Inbox │──┘     Workflows
└─────────────────────┘            │
                                   v
                        ┌────────────────────┐
                        │   Storage          │
                        ├────────────────────┤
                        │ Supabase (tables)  │
                        │ Google Drive       │
                        │ GitHub (vault)     │
                        └────────────────────┘
                                   │
                                   v
                        ┌────────────────────┐
                        │   Outputs          │
                        ├────────────────────┤
                        │ HTML Dashboards    │
                        │ CSV Trackers       │
                        │ Filed Documents    │
                        └────────────────────┘
```

## Active Automations

- **Daily 13:00 UTC (~09:00 EDT):** Plaid Chase transaction auto-pull -> Supabase `expense_transactions` (`pull-finances.yml`) - LIVE since 2026-09-21
- **Weekdays 22:00 UTC (~18:00 EDT):** Plaid Fidelity retirement holdings -> Supabase `stocks_crypto_history` (`pull-investments.yml`) - awaiting Plaid review as of 2026-09-21
- **Daily:** Renpho body composition pull -> `body_composition` (`pull-body.yml`)
- **Daily:** Overload dashboard rebuild (Training + Nutrition) -> GitHub Pages (`build-fitness.yml`)
- **Daily 8 AM UTC:** Whoop fitness data sync (`whoop-daily-sync.yml`)
- **Weekly Sunday midnight:** Whoop OAuth token refresh
- **Weekly Monday 9 AM:** Medical labs ingestion from Google Drive
- **Weekly Monday 10 AM:** Medical dashboard HTML generation
- **Monthly 1st day midnight:** Google Drive medical folder cleanup + Redfin property value refresh

All via GitHub Actions in the `personal` repo.

## Manual Workflows

- Personal document inbox processing (on-demand)
- Expiration date scanning (on-demand)
- Finance backfills only (Excel Chase downloads no longer routine now that Plaid pulls daily)
- Bill statement filing (monthly)

## Relationship to Google Drive

The vault mirrors key metadata and workflows, but does NOT store actual documents.

Documents live in: `G:\My Drive\Personal\` (see [workflows/tables/gdrive-folders.md](workflows/tables/gdrive-folders.md))

The vault tracks:
- What documents exist and where
- Expiration dates and renewal schedules
- Automation workflows that process them
- Medical test history and surveillance schedules

## Relationship to Personal Repo

This vault lives at: `C:\Users\fmartine\Personal\repos\personal\vault\`

**Security change (2026-09-21):** The vault was removed from the public repo
and scrubbed from git history. It is now local only and gitignored. Do NOT
commit or stage anything under `vault/`; the personal repo at
`https://github.com/fernandomartinez-de/personal` no longer carries a copy.
Backups are the responsibility of local disk / OneDrive sync only.

## For New Agents

1. **Read this file first** (you're doing it!)
2. **Understand file organization:** [workflows/tables/gdrive-folders.md](workflows/tables/gdrive-folders.md) - Complete Google Drive structure
3. **Review what's automated:** [workflows/README.md](workflows/README.md) - Workflow status dashboard
4. **Check infrastructure:** [workflows/tech/infrastructure.md](workflows/tech/infrastructure.md) - System architecture and services
5. **Browse domain knowledge:** [[workflows/health/health-data-pipeline]], [[identity/citizenship]], [[life-admin/employment]] for personal context
6. **When troubleshooting:** [[workflows/tech/troubleshooting]] - Common issues and fixes
7. **When writing code:** Read relevant workflow docs in [[workflows/README]] - Complete data flows and failure modes

## Maintenance

**Update frequency:** As needed when workflows change or new domain knowledge is added

**Owner:** Fernando Martinez

**Last major update:** 2026-09-21 (Chase transactions pull LIVE; Fidelity investments pull added and awaiting Plaid review; vault removed from public repo and scrubbed from git history)
