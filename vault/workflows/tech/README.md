# Tech

Technical infrastructure, automation pipelines, and troubleshooting guides for Fernando's personal system.

---

## What's Here

**Infrastructure documentation:**
- [[tech/infrastructure]] - System architecture overview
- [[tech/services]] - External services and credentials

**Troubleshooting:**
- [[tech/troubleshooting]] - Common issues and fixes
- [[tech/recovery]] - Disaster recovery procedures

---

## Quick Overview

### Core Services

**Data storage:**
- Supabase PostgreSQL (health data, expenses, travel)
- Google Drive (documents, medical files, statements)
- GitHub (vault, scripts, version control)

**Automation:**
- GitHub Actions (scheduled workflows)
- Google Drive API (file ingestion)
- Whoop API (fitness data)

**Hosting:**
- GitHub Pages (dashboards, travel sites)

---

## Repositories

**Primary repos:**
- `personal` (private) - Vault, all automation scripts (health, docs, finances, travel)
- `vital-signal-reports` (public) - Medical dashboards (GitHub Pages)

**GitHub account:** fernandomartinez-de  
**Organization:** (none - personal account only)

---

## System Architecture

```
┌─────────────────────────────────────────────────────┐
│                 External APIs                        │
│  Whoop API | Google Drive | Supabase PostgreSQL     │
└──────────────────┬──────────────────────────────────┘
                   │
         ┌─────────┴──────────┐
         │  GitHub Actions    │
         │  (ubuntu-latest)   │
         │  - Daily Whoop     │
         │  - Weekly Labs     │
         │  - Monthly Cleanup │
         └─────────┬──────────┘
                   │
    ┌──────────────┴───────────────┐
    │                              │
    v                              v
┌────────────┐          ┌──────────────────┐
│  Supabase  │          │  GitHub Pages    │
│  (storage) │          │  (dashboards)    │
└────────────┘          └──────────────────┘
    │
    │
    v
┌────────────────────────┐
│  Local Windows PC      │
│  - Manual scripts      │
│  - Google Drive mount  │
│  - Vault editing       │
└────────────────────────┘
```

---

## Access & Credentials

**Stored in:**
- GitHub repository secrets (automation)
- Apple Keychain (personal logins)

**Never committed to git:**
- API keys
- Passwords
- Service account JSONs
- OAuth tokens

See [[tech/services]] for all credentials and secrets documentation.

---

## Monitoring

**GitHub Actions status:**  
https://github.com/fernandomartinez-de/personal/actions

**Supabase dashboard:**  
https://supabase.com/dashboard

**Email notifications:**  
Workflow failures sent to GitHub account email

---

## Getting Help

**For automation issues:** See [[tech/troubleshooting]]  
**For data recovery:** See [[tech/recovery]]  
**For workflow details:** See [[workflows/README]]  
**For all scripts:** See [[workflows/scripts/README]]

---

**Last updated:** 2026-09-14
