# Infrastructure

Technical architecture for Fernando's personal automation system.

---

## System Overview

**Purpose:** Automate health data tracking, document management, and expense tracking with minimal manual intervention.

**Key principles:**
- Data sovereignty (own the data, not locked into platforms)
- Resilience (multiple backups, version control)
- Portability (standards-based: PostgreSQL, HTML, CSV)
- Observability (logs, dashboards, notifications)

---

## Services Stack

### Data Storage

**Supabase PostgreSQL**
- Purpose: Structured health data, expenses, travel planning
- Location: Cloud (Supabase-hosted)
- Tables: `whoop_recovery`, `whoop_sleep`, `whoop_cycles`, `whoop_workouts`, `labs`, `expense_transactions`, `category_mapping`, `stocks_crypto_history`, `real_estate_history`, `trips`, `trip_days`, `activities`
- Access: Connection string in `SUPABASE_DB_URL` secret
- Backup: Supabase automatic backups (verify plan)

**Google Drive**
- Purpose: Long-term document storage (medical PDFs, tax docs, statements)
- Location: `G:\My Drive\Personal\`
- Access: Direct filesystem (Google Drive for Desktop) + API (service account)
- Organization: See [[workflows/tables/gdrive-folders]]
- Quota: 15 GB (currently ~3.2 GB used)

**GitHub**
- Purpose: Version control for vault, scripts, dashboards
- Repos: `personal` (private), `vital-signal-reports` (public GitHub Pages)
- Access: GitHub account + personal access token (PAT)

---

## Automation Platform

**GitHub Actions**
- Platform: Ubuntu-latest runners
- Python: 3.11+
- Schedules: Cron expressions in `.github/workflows/*.yml`
- Secrets: Repository secrets (encrypted at rest)
- Logs: Retained for 90 days
- Cost: Free tier (private repo gets 2,000 minutes/month)

**Active workflows:**
```
.github/workflows/
├── whoop-daily-sync.yml           # Daily 8 AM UTC
├── whoop-bootstrap-token.yml      # Weekly Sunday midnight
├── medical-ingest-labs.yml        # Weekly Monday 9 AM
├── medical-rebuild-dashboards.yml # Weekly Monday 10 AM
└── medical-clean-drive.yml        # Monthly 1st midnight
```

---

## APIs & Integrations

### Whoop API
- Purpose: Fitness and recovery tracking
- Endpoint: `https://api.prod.whoop.com`
- Auth: OAuth 2.0 (refresh token auto-rotated weekly)
- Rate limits: (Verify current limits)
- Data retention: 7 days in API (must sync to Supabase)

### Google Drive API
- Purpose: Medical PDF ingestion, file cleanup
- Auth: Service account (JSON credentials)
- Scopes: Drive read/write to `G:\My Drive\Personal\`
- Usage: Weekly lab ingestion, monthly cleanup
- Alternative: Direct filesystem via Google Drive for Desktop

---

## Hosting & Deployment

### GitHub Pages
- Sites: `vital-signal-reports` (medical dashboards)
- Branch: `gh-pages` (auto-deploy on push)
- URL: https://fernandomartinez-de.github.io/vital-signal-reports/
- Content: Static HTML + embedded JSON data
- CDN: Cloudflare (GitHub Pages default)

### Local Windows PC
- Platform: Windows 11 Enterprise
- Python: Installed locally for manual scripts
- Google Drive: Mounted at `G:\My Drive\Personal\`
- Repos: `C:\Users\fmartine\Personal\repos\personal\`

---

## Data Flow

### Health Data Pipeline
```
Whoop API (daily)
  → GitHub Actions (whoop/sync.py)
  → Supabase (whoop_* tables)
  → (Future) Dashboard generation

Google Drive PDFs (weekly)
  → GitHub Actions (medical/ingest_labs_gdrive.py)
  → PyPDF2 text extraction
  → Supabase (labs table)
  → GitHub Actions (medical/build_dashboards.py)
  → GitHub Pages (HTML dashboards)
```

### Document Management Pipeline
```
vault/ops/incoming/
  → Manual execution (docs/process_personal_inbox.py via PROCESS_INBOX.bat)
  → Pattern matching + classification (financial, medical, tax, ID, employment)
  → Google Drive (correct folder per category: Finances/, Medical/, Tax/, etc.)
  → Vault notes updated with metadata
```

### Finance Pipeline
```
Chase website
  → Manual download (3 Excel files: checking, freedom, sapphire)
  → Drop in vault/ops/incoming/
  → PROCESS_INBOX.bat (classify as financial, rename, file to Google Drive)
  → Google Drive: Finances/Chase/2026/
  → (Manual) Sync to Supabase expense_transactions
  → finances.html dashboard (standalone HTML with live APIs)
```

---

## Security

**Secrets storage:**
- GitHub repository secrets (encrypted)
- Apple Keychain (personal accounts)
- Never in git (verified by .gitignore)

**Access control:**
- GitHub repos: Private (personal account only)
- Supabase: Connection string kept secret
- Google Drive: Service account has Editor access only to Personal folder

**Network:**
- GitHub Actions: Encrypted connections (HTTPS)
- Supabase: TLS/SSL connections
- No sensitive data in logs

---

## Monitoring & Alerts

**Workflow monitoring:**
- GitHub Actions UI: https://github.com/fernandomartinez-de/personal/actions
- Email notifications: Enabled for failures
- Logs: Available for 90 days

**Data validation:**
- Manual checks via Supabase dashboard
- Dashboard visual inspection (missing data = ingestion issue)

**Future:**
- Email/SMS alerts for out-of-range health metrics
- Automated data quality checks
- Dead man's switch for missed critical workflows

---

## Scalability & Limits

**GitHub Actions:**
- Free tier: 2,000 minutes/month for private repos
- Current usage: ~100 minutes/month (well under limit)
- Workflow timeout: 6 hours max (scripts run < 5 min each)

**Supabase:**
- Free tier: 500 MB database, 1 GB file storage, 50,000 monthly active users
- Current usage: < 10 MB database, no file storage used
- Connection pooling: N/A (single user)

**Google Drive:**
- Quota: 15 GB
- Current: ~3.2 GB (21% used)
- Growth: ~500 MB/year (medical PDFs + statements)

**GitHub Pages:**
- Bandwidth: 100 GB/month soft limit
- Current: < 1 GB/month (static dashboards, low traffic)
- File size: 1 GB max per site

---

## Disaster Recovery

**Data backup hierarchy:**
1. **Primary:** Supabase (auto-backups) + Google Drive (cloud)
2. **Secondary:** GitHub (version-controlled vault + scripts)
3. **Tertiary:** Local repo clone (`C:\Users\fmartine\Personal\repos\personal\`)

**Recovery procedures:** See [[tech/recovery]]

---

## Future Enhancements

**High priority:**
- Email/SMS alerts for critical health metrics (thyroglobulin, TSH out of range)
- Automated data quality checks (missing data, suspicious values)
- Automated Supabase sync for expense_transactions (currently manual)

**Medium priority:**
- InBody data ingestion (OCR from PDFs or API if available)
- Travel expense tracking integration
- Tax document automation (1099s, W-2s, receipts)

**Low priority:**
- Real-time dashboard updates (WebSockets)
- Mobile app (read-only dashboard)
- Multi-language dashboard support (English/Spanish)

---

**Related:**
- [[tech/services]] - Service credentials and endpoints
- [[tech/troubleshooting]] - Common issues
- [[workflows/README]] - Workflow overview
- [[workflows/scripts/README]] - All automation scripts
