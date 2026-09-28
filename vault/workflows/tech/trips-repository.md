---
type: repository
category: personal-project
status: active
created: 2026-09-26
last_updated: 2026-09-26
---

# Trips Repository

**Standalone repository for family travel planning sites**

Extracted from the `personal` monorepo on September 26, 2026.

---

## Quick Reference

**Repository:** https://github.com/fernandomartinez-de/trips  
**Live Site:** https://fernandomartinez-de.github.io/trips/  
**Visibility:** Public  
**Purpose:** Family travel planning with real-time collaboration  

---

## Overview

Static HTML trip planning sites (one per trip) with real-time family collaboration via Supabase. No build process, pure HTML/JavaScript deployed via GitHub Pages.

### Tech Stack
- **Frontend:** Pure HTML, Tailwind CSS (CDN), JavaScript
- **Backend:** Supabase (PostgreSQL + Realtime)
- **Maps:** Google Maps JavaScript API
- **Hosting:** GitHub Pages
- **Deployment:** Automatic on push to `main`

### Key Features
- Real-time collaboration (no login required)
- Activity voting and planning
- Interactive map with trip itinerary
- Inspiration photo gallery
- Offline-capable (localStorage caching)
- Mobile-first responsive design

---

## Repository Structure

```
trips/
├── README.md                   Main documentation
├── SETUP.md                    GitHub Pages setup guide
├── SECRETS.md                  API keys and configuration
├── EXTRACTION_SUMMARY.md       Extraction details from personal repo
├── .gitignore                  Git ignore rules
├── index.html                  Landing page listing all trips
│
├── docs/                       Workflow documentation (from vault)
│   ├── travel-automation.md   Architecture and deployment
│   ├── scripts.md             Technical implementation
│   └── supabase-tables.md     Database schema reference
│
└── japan/                      Example trip (November 2026)
    ├── index.html             Complete trip site (~112 KB)
    ├── schema.sql             Supabase DDL + RLS + Realtime + seed data
    └── assets/
        └── img/               14 photos (~1.5 MB)
```

**Total size:** ~3.3 MB  
**Files:** 25

---

## External Dependencies

### Supabase Project: `trips`
- **URL:** `https://hmeenrnlbdzqhbdbsxjf.supabase.co`
- **Purpose:** Database + real-time collaboration
- **Tables:** `japan_*` prefix (one set per trip)
- **Storage:** `japan-images` bucket for photos
- **Access:** Anonymous publishable key (embedded in HTML)
- **Security:** Row Level Security policies

### Google Maps API
- **API Key:** Embedded in `japan/index.html`
- **Restrictions:** HTTP referrer to `fernandomartinez-de.github.io/*`
- **APIs enabled:** Maps JavaScript API, Places API
- **Usage:** Map rendering + Places autocomplete

---

## Deployment

### GitHub Pages Configuration
- **Source:** Deploy from branch `main`, folder `/ (root)`
- **URL:** `https://fernandomartinez-de.github.io/trips/`
- **Deployment:** Automatic on push (~1-2 minutes)
- **No build process:** Pure static HTML

### Workflow
```bash
# Make changes locally
git add .
git commit -m "Update itinerary"
git push

# Wait 1-2 minutes
# Site automatically redeploys
```

---

## Current Trips

### Japan · November 2026
- **Folder:** `japan/`
- **Live URL:** https://fernandomartinez-de.github.io/trips/japan/
- **Status:** Active planning
- **Database:** `japan_*` tables in Supabase `trips` project

---

## Extraction Details (September 26, 2026)

### Previous Location
- **Repository:** `https://github.com/fernandomartinez-de/personal`
- **Folder:** `travel/`
- **URL:** `https://fernandomartinez-de.github.io/personal/travel/`

### What Changed
- ✅ Extracted to standalone `trips` repository
- ✅ New URL: `/trips/` instead of `/personal/travel/`
- ✅ Complete documentation added (README, SETUP, SECRETS)
- ✅ Vault workflow docs copied to `docs/` folder

### What Stayed the Same
- ✅ Supabase project (already was separate)
- ✅ Google Maps API key (referrer restrictions work with new URL)
- ✅ Architecture and code (no changes)
- ✅ All trip data and images

### Why Extracted
- Independent deployment and versioning
- Cleaner separation between personal and family projects
- Easier to share and collaborate
- Complete documentation in one repository
- Can delete from personal repo to reduce clutter

---

## Development

### Local Development
```bash
# Option 1: Direct file open
open japan/index.html
# Caveat: Google Places autocomplete won't work (referrer restriction)

# Option 2: Local server (recommended)
cd japan
python -m http.server 8000
open http://localhost:8000
# Google Places autocomplete works
```

### Adding a New Trip
```bash
# 1. Duplicate existing trip
cp -r japan/ italy/

# 2. Edit italy/index.html
# - Update ITINERARY array
# - Update hero text and title
# - Change japan_* to italy_*

# 3. Create database schema
# - Copy italy/schema.sql
# - Replace japan_ with italy_
# - Run in Supabase SQL Editor

# 4. Update landing page
# - Add card to index.html
# - Add bullet to README.md

# 5. Deploy
git add .
git commit -m "Add Italy trip"
git push
```

---

## Secrets & Configuration

**All secrets are embedded in HTML files** (intentionally public by design).

### Supabase Credentials
- **URL:** `https://hmeenrnlbdzqhbdbsxjf.supabase.co`
- **Publishable Key:** `sb_publishable_n0GbcnDhojPMzKOVAGDp3Q_tSrLYnlX`
- **Location:** `japan/index.html` lines ~568-569
- **Security:** Row Level Security policies (not key secrecy)

### Google Maps API Key
- **Key:** `AIzaSyCzVi_vQMDVzkzivFo010pRSu1NoRC41Aw`
- **Location:** `japan/index.html` line ~564
- **Restrictions:** HTTP referrer to `fernandomartinez-de.github.io/*`

**See:** `SECRETS.md` in repository for full details.

---

## Cost

**Everything is free:**
- ✅ GitHub Pages: Free for public repos
- ✅ Supabase: Free tier (500 MB DB, 1 GB storage, realtime included)
- ✅ Google Maps: $200/month free credit

**Typical monthly usage:** $0/month (well within free tiers)

---

## Maintenance

### Regular Tasks
- **None** - Static site, no scheduled maintenance
- Supabase project stays active as long as used
- GitHub Pages automatically deploys on push

### Potential Issues
1. **Supabase project paused** (free tier, after inactivity)
   - Fix: Visit Supabase dashboard to wake up
   
2. **Google Maps API quota exceeded**
   - Monitor: Google Cloud Console
   - Fix: Set usage quotas or add billing

3. **Old URL bookmarks** (family still using `/personal/travel/`)
   - Fix: Share new URL, optionally add redirect

---

## Related Vault Notes

- [[workflows/travel/travel-automation]] - Full workflow documentation
- [[workflows/travel/scripts]] - Technical implementation details
- [[workflows/travel/supabase-tables]] - Database schema reference

---

## Future Enhancements

Potential features (not currently implemented):
1. Flight tracking integration
2. Budget tracking per trip
3. Weather forecast widget
4. Spanish/English toggle
5. Progressive Web App (offline mode)
6. Printable PDF export
7. Past trips archive section

---

## Family Sharing

**Current URL:** https://fernandomartinez-de.github.io/trips/

**Share with:**
- Mom
- Family members planning Japan trip

**Note:** Old URL (`/personal/travel/`) may still work but should not be used. Update all bookmarks and shares to new URL.

---

## Backup & Recovery

### Git History
- Full commit history in GitHub repository
- Can revert to any previous version

### Supabase Data
- Automatic backups (verify in Supabase dashboard)
- Export: Use Supabase dashboard or API
- Schema: `japan/schema.sql` is idempotent (safe to re-run)

### Images
- Stored in repository (`japan/assets/img/`)
- Also uploaded to Supabase Storage (`japan-images` bucket)
- Backed up via git commits

---

## Status

**Active** - Currently used for Japan November 2026 trip planning

**Last updated:** September 26, 2026 (extraction from personal repo)
