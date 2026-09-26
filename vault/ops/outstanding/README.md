---
tags: [outstanding, action-items, quarterly-review]
last_reviewed: 2026-09-15
---

# Outstanding

Action items and incomplete vault entries to be filled in during quarterly reviews.

## Purpose

Tracks all vault notes with missing information, blanks to fill, research needed, or pending decisions.

**Review cadence:** Quarterly (Jan, Apr, Jul, Oct)

**Last reviewed:** September 15, 2026

---

## Current Outstanding Items

### Legal & Estate Documents

**[[life-admin/will]]**
- [ ] Complete Trust & Will online questionnaire ($199)
- [ ] Designate executor, beneficiaries, healthcare proxy, POA
- [ ] Print and execute with 2 witnesses + notary
- [ ] Store original securely, upload copy to Google Drive

---

### Imminent Renewals

⚠️ **TIME-SENSITIVE:**

**[[identity/licenses]]** - Driver's license renewal:
- [ ] Renew NY driver's license (expires November 27, 2026 - **2.5 months away**)
- [x] Schedule DMV appointment or renew online

---

### Remaining Manual Steps

**[[workflows/finances/finances-automation]]** - Finance tracking manual work:
- [ ] **Monthly (after Plaid approved):** Run `python plaid_sync.py` to pull new Chase transactions (replaces manual Excel downloads)
- [ ] **Monthly:** Fetch Redfin property estimate (run `python fetch_redfin_property_value.py`), then click dashboard "Refresh Prices" to update Zillow + recalculate average
- [ ] **As needed:** Add new category mapping rules to Supabase when unknown merchants appear
- [ ] **Monthly:** Review finances.html dashboard for miscategorized transactions
- [ ] **Monthly:** Update retirement 401(k) balance in dashboard code (hardcoded value)

**[[life-admin/real-estate]]** - Property tax and assessment tracking:
- [ ] **Quarterly:** Download property tax bills from NYC portal and save to Google Drive
  - August/September: Q2 bill (due Oct 1)
  - November/December: Q3 bill (due Jan 1)
  - February/March: Q4 bill (due Apr 1)
  - May/June: Q1 bill (due Jul 1)
- [ ] **Annually (January):** Download Final Assessment Roll from NYC portal and save to Google Drive

---

## Status

**Vault completion:** 100% (all current data present)  
**Outstanding items:** 13 (will/estate planning, property tax tracking, recurring manual work)  
**Completed this quarter:** 24 (document extraction + financial accounts + property deed + finance alert configuration + Plaid integration scripts + property tax analysis - September 16, 2026)  
**Time-sensitive:** 1 (driver's license renewal - November 27, 2026)  
**Recurring manual:** 6 (monthly + quarterly tasks)  
**Next review:** January 2027

---

## Related

- [[workflows/docs/scripts]] - quarterly review process documentation
- [[workflows/README]] - full workflow status
- [[quick-ref/renewals]] - expiring documents to track
- [[quick-ref/key-dates]] - important dates calendar
