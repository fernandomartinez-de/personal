# Services

External services, credentials, and API endpoints for Fernando's personal infrastructure.

---

## Data Storage Services

### Supabase (PostgreSQL)
**Purpose:** Structured data storage (health, expenses, travel)  
**Endpoint:** (from `SUPABASE_DB_URL` secret)  
**Plan:** Free tier  
**Tables:** 
- Health: `whoop_recovery`, `whoop_sleep`, `whoop_cycles`, `whoop_workouts`, `labs`
- Finance: `expense_transactions`, `category_mapping`, `stocks_crypto_history`, `real_estate_history`
- Travel: `trips`, `trip_days`, `activities`

**Access:** Connection string in GitHub repository secrets  
**Dashboard:** https://supabase.com/dashboard  
**Backup:** Automatic (verify plan includes backups)

---

### Google Drive
**Purpose:** Long-term document storage  
**Location:** `G:\My Drive\Personal\`  
**Account:** fernandopv2655@gmail.com  
**Plan:** Free (15 GB)  
**Usage:** ~3.2 GB (21%)  
**Access methods:**
- Local: Google Drive for Desktop (filesystem mount)
- API: Service account credentials (`GOOGLE_CREDENTIALS` secret)

**Service account:**
- Email: (stored in `GOOGLE_CREDENTIALS` JSON)
- Permissions: Editor access to `G:\My Drive\Personal\` only
- Used by: GitHub Actions workflows

---

### GitHub
**Purpose:** Version control, automation, hosting  
**Account:** fernandomartinez-de  
**Email:** fernandopv2655@gmail.com

**Repositories:**
- `personal` (private) - Vault, automation scripts (health, docs, finances, travel)
- `vital-signal-reports` (public) - Medical dashboards (GitHub Pages)

**GitHub Actions:**
- Plan: Free tier (2,000 minutes/month for private repos)
- Usage: ~100 minutes/month

**GitHub Pages:**
- Site: https://fernandomartinez-de.github.io/vital-signal-reports/
- Branch: `gh-pages`
- Bandwidth: 100 GB/month soft limit

---

## API Services

### Whoop API
**Purpose:** Fitness and recovery data  
**Endpoint:** https://api.prod.whoop.com  
**Auth:** OAuth 2.0  
**Credentials:**
- Client ID: `WHOOP_CLIENT_ID` (GitHub secret)
- Client Secret: `WHOOP_CLIENT_SECRET` (GitHub secret)
- Refresh Token: `WHOOP_REFRESH_TOKEN` (auto-updated weekly)

**OAuth app:** Registered in Whoop developer portal  
**Token refresh:** Automated via `whoop-bootstrap-token.yml` (weekly)  
**Rate limits:** (Verify current limits)  
**Data retention:** 7 days in API (must sync to Supabase)

**Developer portal:** https://developer.whoop.com/

---

### Google Drive API
**Purpose:** Automated file access (lab ingestion, cleanup)  
**Endpoint:** https://www.googleapis.com/drive/v3/  
**Auth:** Service account (JSON key file)  
**Credentials:** `GOOGLE_CREDENTIALS` (GitHub secret)  
**Scopes:** `https://www.googleapis.com/auth/drive`  
**Usage:** Weekly lab ingestion, monthly cleanup

**Service account setup:**
1. Created in Google Cloud Console
2. JSON key downloaded and stored as secret
3. Shared `G:\My Drive\Personal\` folder with service account email
4. Service account has Editor permissions

---

## Secrets Management

**Stored in:** GitHub repository secrets (Settings → Secrets → Actions)

### Active Secrets

**`GH_PAT`** - GitHub Personal Access Token  
- Purpose: Update secrets programmatically (token refresh)
- Scopes: `repo`, `workflow`
- Expiration: (Check and renew annually)

**`SUPABASE_DB_URL`** - PostgreSQL Connection String  
- Format: `postgresql://user:pass@host:port/db`
- Includes: Username, password, host, port, database name
- Expiration: None (unless project deleted)

**`WHOOP_CLIENT_ID`** - Whoop OAuth App ID  
- Format: Alphanumeric string
- Expiration: None (unless app deleted)

**`WHOOP_CLIENT_SECRET`** - Whoop OAuth App Secret  
- Format: Alphanumeric string
- Expiration: None (unless app deleted)
- Security: Keep secret, never commit to git

**`WHOOP_REFRESH_TOKEN`** - Whoop OAuth Refresh Token  
- Format: JWT token
- Expiration: Auto-renewed weekly by `whoop-bootstrap-token.yml`
- Purpose: Exchange for short-lived access tokens

**`GOOGLE_CREDENTIALS`** - Google Service Account JSON  
- Format: JSON key file (multi-line)
- Contains: Service account email, private key, project ID
- Expiration: None (unless key revoked)
- Security: Never commit to git, only in GitHub secrets

---

## Local Services (Windows PC)

### Google Drive for Desktop
**Purpose:** Local filesystem mount for Google Drive  
**Mount point:** `G:\My Drive\Personal\`  
**Auto-start:** Yes  
**Sync mode:** Stream (files downloaded on-demand)  
**Version:** (Check for updates)

### Python
**Version:** 3.11+ (verify: `python --version`)  
**Location:** `C:\Users\fmartine\AppData\Local\Programs\Python\`  
**Packages:** Per-script requirements.txt files

### Git
**Version:** (Check: `git --version`)  
**Config:**
```
git config user.name "fernandomartinez-de"
git config user.email "fernandopv2655@gmail.com"
```

---

## Status Pages

**Check service availability:**

- GitHub: https://www.githubstatus.com/
- Supabase: https://status.supabase.com/
- Google Drive: https://www.google.com/appsstatus
- Whoop: https://status.whoop.com/

---

## Credential Rotation Schedule

**Quarterly:**
- [ ] Review GitHub PAT expiration
- [ ] Verify Whoop OAuth app active
- [ ] Check Google service account permissions

**Annual:**
- [ ] Rotate GitHub PAT
- [ ] Review all API credentials
- [ ] Audit GitHub secrets (remove unused)
- [ ] Verify Supabase project active

**Automatic:**
- Whoop refresh token: Auto-rotated weekly

---

## Adding New Services

**Checklist when adding a new service:**
1. Document in this file (endpoint, auth, purpose)
2. Store credentials as GitHub repository secrets
3. Never commit secrets to git (check .gitignore)
4. Add status page URL for monitoring
5. Document in [[tech/infrastructure]]
6. Add to rotation schedule if credentials expire

---

## Emergency Access

**If credentials compromised:**
1. Revoke immediately in service portal
2. Generate new credentials
3. Update GitHub secrets
4. Re-run affected workflows
5. Review logs for unauthorized access

**If locked out of GitHub:**
- Account recovery via email: fernandopv2655@gmail.com
- 2FA backup codes: (Store securely, not in this vault)

**If Supabase project lost:**
- Restore from Supabase automatic backups
- Recreate tables from [[workflows/health/supabase-tables]]
- Re-ingest data from Google Drive PDFs

---

**Related:**
- [[tech/infrastructure]] - System architecture
- [[tech/troubleshooting]] - Common issues with services
- [[workflows/health/scripts]] - Scripts that use these services
