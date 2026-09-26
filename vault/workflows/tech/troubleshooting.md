# Troubleshooting

Common issues and fixes for Fernando's automation system.

---

## GitHub Actions Failures

### Workflow Not Running on Schedule

**Symptoms:**
- Expected workflow didn't trigger at scheduled time
- No entry in Actions tab for expected run

**Causes:**
- Cron expression timezone confusion (GitHub Actions uses UTC)
- Repository inactive (GitHub may pause scheduled workflows after 60 days of no repo activity)
- Workflow YAML syntax error

**Fixes:**
1. Check cron expression: `0 8 * * *` means 8 AM UTC, not local time
2. Push any commit to repo to reactivate scheduled workflows
3. Validate YAML syntax: https://www.yamllint.com/
4. Check workflow file has `schedule:` trigger enabled

---

### Workflow Running But Failing

**Symptoms:**
- Workflow triggered but exits with error
- Red X in GitHub Actions tab

**Fixes:**
1. **Check logs:** Click workflow run → Click failed job → Expand failed step
2. **Common errors:**
   - `ModuleNotFoundError`: Add missing package to requirements.txt
   - `Authentication failed`: Check secret is set correctly in Settings → Secrets
   - `Rate limit exceeded`: Wait and retry (Whoop API, Google Drive API)
   - `Connection timeout`: External service may be down, retry later
3. **Secrets expired:**
   - `WHOOP_REFRESH_TOKEN`: Should auto-update weekly, check bootstrap workflow
   - `GOOGLE_CREDENTIALS`: Service account JSON, shouldn't expire
   - `SUPABASE_DB_URL`: Check Supabase project is active
4. **Re-run workflow:** Click "Re-run failed jobs" button

---

### Whoop Token Refresh Failed

**Symptoms:**
- `whoop-daily-sync.yml` failing with authentication error
- `whoop-bootstrap-token.yml` ran but didn't update secret

**Cause:** Refresh token expired or OAuth app revoked

**Fix:**
1. Re-authorize Whoop OAuth:
   - Go to Whoop developer portal
   - Generate new OAuth client credentials
   - Update `WHOOP_CLIENT_ID` and `WHOOP_CLIENT_SECRET` secrets
   - Manually run bootstrap script to get new refresh token
2. Update `WHOOP_REFRESH_TOKEN` secret in GitHub
3. Re-run `whoop-daily-sync.yml`

---

## Local Script Failures

### Google Drive Not Accessible

**Symptoms:**
- `FileNotFoundError: G:\My Drive\Personal\...`
- Script exits with "G: drive not accessible"

**Cause:** Google Drive for Desktop not running or not synced

**Fixes:**
1. Open Google Drive for Desktop app
2. Check sync status (should show green checkmark)
3. If sync paused, resume it
4. Wait for sync to complete
5. Retry script

---

### Python Module Not Found

**Symptoms:**
- `ModuleNotFoundError: No module named 'PyPDF2'`
- Script fails immediately on import

**Cause:** Dependencies not installed

**Fix:**
```bash
cd docs
pip install -r requirements.txt --break-system-packages
```

Note: `--break-system-packages` flag required on newer Python versions

---

### Permission Denied

**Symptoms:**
- `PermissionError: [WinError 32]` (file in use)
- `Access is denied`

**Cause:** File locked by another program (Excel, Adobe Acrobat, etc.)

**Fixes:**
1. Close applications that might have the file open
2. Check Task Manager for hidden Excel/Acrobat processes
3. Restart computer if file lock persists
4. Retry script

---

## Data Issues

### Lab Results Missing from Dashboard

**Symptoms:**
- Lab PDF in Google Drive but not showing in dashboard
- Dashboard shows old data only

**Checks:**
1. **PDF location correct?** Must be in `G:\My Drive\Personal\Medical\{YEAR}\labs\`
2. **Ingestion ran?** Check `medical-ingest-labs.yml` workflow status (Monday 9 AM UTC)
3. **Data in Supabase?** Check Supabase dashboard → `labs` table
4. **Dashboard rebuilt?** Check `medical-rebuild-dashboards.yml` ran (Monday 10 AM UTC)

**Fixes:**
1. Verify PDF naming: `YYYY-MM-DD_labs_provider_description.pdf`
2. Manually run ingestion: `python health/medical/ingest_labs_gdrive.py`
3. Check script output for parsing errors
4. Manually add to Supabase if parsing fails
5. Rebuild dashboard: `python health/medical/build_dashboards.py`

---

### Whoop Data Not Syncing

**Symptoms:**
- Dashboard shows stale recovery data
- Last entry is several days old

**Checks:**
1. **Workflow running?** Check `whoop-daily-sync.yml` status (daily 8 AM UTC)
2. **Authentication working?** Check for auth errors in logs
3. **Data in Supabase?** Check Supabase → `whoop_recovery` table

**Fixes:**
1. Check Whoop API status: https://status.whoop.com/
2. Verify `WHOOP_REFRESH_TOKEN` is current
3. Manually run sync: `python health/whoop/sync.py` (requires env vars)
4. If token expired, run bootstrap: `python health/whoop/bootstrap.py`

---

### Google Drive Cleanup Moving Wrong Files

**Symptoms:**
- `clean_medical_drive.py` suggesting wrong folders
- Files moving to incorrect year/category

**Cause:** Pattern matching logic needs tuning

**Fixes:**
1. Don't confirm suggested moves if they look wrong
2. Manually move files to correct folder
3. Update pattern matching in script
4. File issue in GitHub repo with example filename

---

## Dashboard Issues

### Dashboard Not Updating

**Symptoms:**
- Dashboard shows old data despite new data in Supabase
- Changes pushed to GitHub but dashboard unchanged

**Checks:**
1. **GitHub Pages deployed?** Check Settings → Pages (should show green checkmark)
2. **Correct branch?** Should deploy from `gh-pages` branch
3. **Build ran?** Check `medical-rebuild-dashboards.yml` status

**Fixes:**
1. Hard refresh browser: `Ctrl+Shift+R` (Windows) or `Cmd+Shift+R` (Mac)
2. Check GitHub Pages deployment: https://github.com/fernandomartinez-de/vital-signal-reports/deployments
3. Manually rebuild: `python health/medical/build_dashboards.py`
4. Push to GitHub: `git add . && git commit -m "Update" && git push`
5. Wait 1-2 minutes for GitHub Pages to deploy

---

### Charts Not Rendering

**Symptoms:**
- Dashboard loads but charts are blank or missing
- Console shows JavaScript errors

**Causes:**
- Chart.js CDN blocked or down
- JSON data malformed
- Browser compatibility issue

**Fixes:**
1. Check browser console for errors (F12 → Console tab)
2. Verify Chart.js CDN accessible: `https://cdn.jsdelivr.net/npm/chart.js`
3. Validate JSON data embedded in HTML
4. Try different browser (Chrome, Firefox, Safari)
5. Check for ad-blocker interference

---

## Bash/Linux Environment Issues

### Workspace Still Starting

**Symptoms:**
- Bash command returns "Workspace still starting"
- No output from bash tool

**Cause:** Linux VM booting in background

**Fix:** Wait 3-5 seconds and retry command

---

### Command Not Found

**Symptoms:**
- `bash: python3: command not found`
- `bash: pip: command not found`

**Cause:** Tool not installed in Linux environment

**Fixes:**
1. Use full path: `/usr/bin/python3`
2. Install via apt: `apt-get update && apt-get install -y python3`
3. Use pre-installed tools: `find`, `grep`, `ls`, `cat`

---

## Supabase Issues

### Connection Timeout

**Symptoms:**
- Script hangs connecting to database
- `psycopg2.OperationalError: timeout`

**Causes:**
- Supabase project paused (free tier inactivity)
- Network issue
- Connection string wrong

**Fixes:**
1. Check Supabase dashboard - project may be paused
2. Click "Resume" if paused
3. Verify `SUPABASE_DB_URL` secret is correct
4. Check network connectivity
5. Retry after a few minutes

---

### Table Not Found

**Symptoms:**
- `psycopg2.ProgrammingError: relation "labs" does not exist`

**Cause:** Table not created yet or wrong database

**Fixes:**
1. Check Supabase → Table Editor
2. Create table: See [[workflows/health/supabase-tables]] for schema
3. Verify connection string points to correct project

---

## Prevention Tips

**Avoid failures:**
1. Test scripts locally before committing
2. Monitor GitHub Actions tab weekly
3. Check Supabase data monthly
4. Keep secrets up to date (especially OAuth tokens)
5. Document any workflow changes

**Monitoring checklist:**
- [ ] GitHub Actions all green
- [ ] Dashboards showing current data
- [ ] Google Drive sync active
- [ ] Supabase project active
- [ ] No email alerts from GitHub

---

## Getting More Help

**Script issues:** Check script logs in GitHub Actions  
**Data issues:** Check Supabase dashboard  
**Vault questions:** See [[workflows/README]]  
**Infrastructure:** See [[tech/infrastructure]]

**Emergency contact:** Fernando Martinez (fernandopv2655@gmail.com)

---

**Related:**
- [[tech/recovery]] - Disaster recovery procedures
- [[tech/infrastructure]] - System architecture
- [[workflows/README]] - Workflow overview
- [[workflows/health/health-data-pipeline]] - Health automation details
