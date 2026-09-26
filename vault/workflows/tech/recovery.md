# Disaster Recovery

Procedures for recovering Fernando's personal data and infrastructure in case of catastrophic failure.

---

## Backup Hierarchy

### Tier 1: Cloud Services (Primary)
**Services:**
- Supabase (automatic backups)
- Google Drive (cloud storage)
- GitHub (version control)

**Risk:** Service shutdown, account suspension, data corruption  
**Recovery:** Restore from Tier 2 or 3

---

### Tier 2: Local Computer (Secondary)
**Location:** `C:\Users\fmartine\Personal\repos\personal\`  
**Contents:**
- Vault (all markdown files)
- Scripts (Python automation)
- Git history (full commit log)

**Risk:** Computer failure, theft, ransomware  
**Recovery:** Clone from GitHub (Tier 1) or external backup (Tier 3)

---

### Tier 3: External Backup (Tertiary)
**Status:** Declined by choice - relying on Tier 1 cloud services (Google Drive, Supabase, GitHub)

**Decision rationale:**
- Google Drive is reliable cloud provider
- Supabase has automatic backups
- GitHub provides version control
- Tier 1 + Tier 2 (local computer) deemed sufficient

**If reconsidered later:**
- External hard drive (~$60) OR
- Cloud backup service (~$99/year)
- Quarterly Google Takeout exports

---

## Recovery Scenarios

### Scenario 1: GitHub Account Lost

**Symptoms:**
- Cannot access GitHub repos
- Account suspended or deleted
- 2FA device lost

**Impact:** Loss of vault, scripts, automation, dashboards

**Recovery:**
1. **Restore vault from local clone:**
   - Local copy: `C:\Users\fmartine\Personal\repos\personal\`
   - Contains: Full vault + scripts
2. **Create new GitHub account** (or recover existing)
3. **Push local repo to new remote:**
   ```bash
   cd C:\Users\fmartine\Personal\repos\personal
   git remote set-url origin https://github.com/NEW_USERNAME/personal.git
   git push -u origin main
   ```
4. **Reconfigure GitHub Actions:**
   - Re-add repository secrets
   - Verify workflows run successfully
5. **Redeploy dashboards:**
   - Create new `vital-signal-reports` repo
   - Enable GitHub Pages
   - Push dashboards to `gh-pages` branch

**Prevention:** Keep local clone updated, store 2FA backup codes securely

---

### Scenario 2: Supabase Project Deleted

**Symptoms:**
- Cannot connect to database
- `SUPABASE_DB_URL` returns connection error
- Supabase dashboard shows project gone

**Impact:** Loss of structured health data (Whoop, labs)

**Recovery:**
1. **Create new Supabase project**
2. **Recreate tables:**
   - Schemas: [[workflows/health/supabase-tables]]
   - Run SQL CREATE TABLE statements
3. **Re-ingest data:**
   - Medical labs: Re-run `ingest_labs_gdrive.py` on all PDFs in Google Drive
   - Whoop data: Only last 7 days available (older data lost if not backed up)
4. **Update connection string:**
   - Copy new `SUPABASE_DB_URL` from Supabase dashboard
   - Update GitHub repository secret
5. **Rebuild dashboards:**
   - Run `build_dashboards.py` to regenerate with restored data

**Prevention:** Enable Supabase automatic backups, periodic database exports to CSV

---

### Scenario 3: Google Drive Account Lost

**Symptoms:**
- Cannot access `G:\My Drive\Personal\`
- Account suspended or deleted
- All documents gone

**Impact:** Loss of all medical PDFs, tax docs, statements, ID scans

**Recovery:**
1. **Attempt account recovery:**
   - Google account recovery: https://accounts.google.com/signin/recovery
   - Contact Google support
2. **If unrecoverable:**
   - Medical records: Request copies from providers (Dra. Escobar, Labcorp, Quest)
   - Tax docs: Request copies from IRS (form 4506-T for transcripts)
   - Employment: Request from SS&C HR
   - ID documents: Have physical originals, re-scan if needed
3. **Restore from external backup** (if available)
4. **Recreate folder structure:**
   - See [[workflows/tables/gdrive-folders]] for complete structure
   - Re-organize files as they're recovered

**Prevention:**
- Google Takeout export (quarterly)
- External hard drive backup of critical PDFs
- Physical copies of key documents (passport, SSN, tax returns)

---

### Scenario 4: Local Computer Failure

**Symptoms:**
- Hard drive failure
- Ransomware encryption
- Computer stolen or destroyed

**Impact:** Loss of local vault clone, scripts, uncommitted changes

**Recovery:**
1. **Clone repos from GitHub:**
   ```bash
   git clone https://github.com/fernandomartinez-de/personal.git
   cd personal
   ```
2. **Reinstall dependencies:**
   ```bash
   pip install -r health/whoop/requirements.txt
   pip install -r health/medical/requirements.txt
   pip install -r docs/requirements.txt
   ```
3. **Reinstall Google Drive for Desktop**
4. **Reconfigure environment:**
   - Verify Python installed
   - Verify Git installed
   - Mount Google Drive at `G:\`
5. **No data loss** (everything in GitHub + Google Drive)

**Prevention:** Regular git commits and pushes, external backup of local files

---

### Scenario 5: Complete Data Loss (All Tiers)

**Symptoms:**
- GitHub account gone
- Supabase project gone
- Google Drive gone
- Computer destroyed
- No external backup

**Impact:** Catastrophic - loss of all personal data infrastructure

**Recovery:**
1. **Vault content:** Recreate from memory and paper records
2. **Medical history:** Request from providers (slow but possible)
3. **Tax documents:** Request from IRS, employer W2s, 1098s, 1099s
4. **ID documents:** Physical originals still exist (passports, licenses)
5. **Automation:** Rebuild scripts from scratch (time-consuming)
6. **Structured data:** Lost permanently (Whoop historical, lab trends)

**Prevention:**
- **CRITICAL:** Set up Tier 3 external backup immediately
- Quarterly Google Takeout export
- Annual database dumps to external drive
- Physical copies of irreplaceable documents

---

## Backup Procedures

### Quarterly Backup Checklist

**Google Drive:**
1. Go to: https://takeout.google.com/
2. Select: Google Drive → `G:\My Drive\Personal\` only
3. Format: .zip, 10 GB per file
4. Delivery: Download link (expires in 7 days)
5. Store: External hard drive + cloud backup (Dropbox, iCloud, etc.)

**Supabase:**
1. Go to: Supabase dashboard → Database
2. Backup & Restore → Download backup
3. Or: Run manual pg_dump:
   ```bash
   pg_dump $SUPABASE_DB_URL > backup_YYYYMMDD.sql
   ```
4. Store: External hard drive + cloud backup

**GitHub:**
1. Local clone is sufficient (already on computer)
2. Optional: Export as .zip from GitHub settings
3. Store: External hard drive

**Dashboards:**
1. Clone `vital-signal-reports` repo
2. Or: Save HTML files from GitHub Pages
3. Store: External hard drive

**Frequency:** Quarterly (Jan 1, Apr 1, Jul 1, Oct 1)  
**Retention:** Keep last 4 backups (1 year)

---

## External Backup Setup (TODO)

**Recommended approach:**

**Option 1: External Hard Drive**
- Buy: 1-2 TB USB external drive
- Encrypt: BitLocker (Windows) or VeraCrypt
- Store: Home safe or off-site (bank safe deposit box)
- Update: Quarterly

**Option 2: Cloud Backup Service**
- Services: Dropbox, iCloud, Backblaze
- Encrypt: Before upload (sensitive medical/tax docs)
- Frequency: Automatic sync
- Cost: ~$10-15/month

**Option 3: Hybrid (Recommended)**
- External drive: Annual full backup (off-site)
- Cloud backup: Quarterly incremental backups
- Both: Encrypted

---

## Testing Recovery

**Annual recovery drill:**
1. Pick random file from Google Drive backup
2. Verify can restore to new location
3. Pick random table from Supabase backup
4. Verify can restore to test database
5. Clone repo to new directory
6. Verify scripts run successfully

**Last tested:** ⚠️ **NEVER** (add to schedule)

---

## Recovery Contacts

**GitHub support:** https://support.github.com/  
**Supabase support:** https://supabase.com/dashboard/support  
**Google support:** https://support.google.com/  

**Emergency data recovery:**
- Providers: Dra. Escobar, Labcorp, Quest (medical records)
- IRS: 1-800-829-1040 (tax documents)
- SS&C HR: (add number) (employment documents)

---

## Post-Recovery Checklist

After major recovery:
- [ ] Verify all repos cloned correctly
- [ ] Verify all secrets set in GitHub
- [ ] Run test workflow to confirm automation works
- [ ] Check Supabase tables populated
- [ ] Verify Google Drive folder structure
- [ ] Test dashboard generation
- [ ] Review logs for errors
- [ ] Document what was lost (if anything)
- [ ] Update recovery procedures with lessons learned

---

**Related:**
- [[tech/troubleshooting]] - Common issues
- [[tech/infrastructure]] - System architecture
- [[workflows/tables/gdrive-folders]] - Google Drive structure to recreate
- [[workflows/health/supabase-tables]] - Database schemas to recreate
