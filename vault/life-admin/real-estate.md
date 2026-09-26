---
type: life-admin
last_updated: 2026-09-15
related: [[life-admin/taxes]], [[quick-ref/renewals]]
---

# 66 S 6th Street, Unit 4A, Brooklyn, NY

## Purchase Details

**Purchase date:** April 2025 (closing - see contract for exact date)
**Purchase price:** $895,000
**Down payment:** $420,000 (47% down)
**Closing documents:** G:\My Drive\Personal\66 S 6th Street\

**Key documents:**
- Signed contract: Signed Contract 4A.pdf
- Final disclosure: Final Disclosure.pdf
- Appraisal: Apppraisal Report.pdf
- **DEED:** Get from NYC ACRIS (free online) at https://a836-acris.nyc.gov/DS/DocumentSearch/Index

**Attorney:** Steve Decker (handled purchase closing)
- Contact: (Available in closing documents if needed)

## Mortgage

**Lender:** JPMorgan Chase Bank, N.A.
**Loan amount:** $475,000
**Interest rate:** 6.490%
**Term:** 30-year fixed
**Loan-to-value (LTV):** 54%
**Monthly payment (P&I):** $2,999.20
**Escrow (taxes + insurance):** $1,018.64/month (effective November 1, 2026)
**Total monthly payment:** $4,017.84 (effective November 1, 2026)
**Previous payment:** $3,683.44 (increased $334.40/month due to property tax jump)
**Account number:** 1534477436
**Commitment date:** April 10, 2025

**Escrow breakdown (Nov 2026 forward):**
- Property taxes: $771.70/month ($11,191.12/year ÷ 12)
- Homeowner's insurance: $29.83/month ($358/year ÷ 12)
- Shortage repayment: $217.11/month ($2,605.30 ÷ 12 months)
- **Total escrow:** $1,018.64/month

**Escrow status:**
- Shortage: $2,605.30 (as of September 12, 2026)
- Reason: Property tax jumped 51% due to NYC reassessment ($7,402 → $11,191/year)
- Chase was collecting $613.82/month but actual need is $771.70/month (+$157.88/month)
- Options: Pay shortage in full ($2,605.30 lump sum) or spread across 12 months (+$217.11/month)
- **Annual escrow analysis:** Arrives in mail every September (reviews taxes/insurance, adjusts payment)

**Payment method:** Auto-pay from Chase checking
**Due date:** 2nd of each month
**Mortgage portal:** chase.com/escrow

**Important dates:**
- September: Escrow analysis statement arrives (check mail for payment changes)
- November 1: New escrow payment amount takes effect (if changed)

**Tax documents:** 
- 1098 (mortgage interest): G:\My Drive\Personal\Tax&BS\Tax 2025\Chase (Mortgage)\
- Latest: Mortgage Tax 1098.pdf and 1099-Int.pdf

## HOA / Condo Association

**Name:** 66 S 6th Street Condominium Association
**Monthly common charges:** $506/month
**Payment method:** Direct deposit (enrollment form filed)

**Management company:** G Buddy
- Contact: Priscilla
- Email: priscilla@gbuddyinc.com
- Phone: (718) 234-1515

**Building policies:** (Add any specific rules - pets, renovations, etc.)

**Owner registration:** G:\My Drive\Personal\66 S 6th Street\Owner and Tenant Registration Form 4A.pdf

## Insurance

**Homeowners insurance:** Condominium Unitowners Policy
**Carrier:** State Farm Fire and Casualty Company
**Policy number:** 56-EN-C719-4
**Agent:** Brian Silk - (631) 998-4280
**Agent location:** 139 Old Riverhead Rd, Westhampton Beach, NY 11978

**Coverage amounts:**
- Coverage A (Building Property): (See policy page 2)
- Coverage B (Personal Property): $45,600
- Coverage C (Loss of Use): $10,200
- Coverage D (Loss Assessment): $9,180
- Personal Liability: $300,000 per occurrence

**Annual premium:** $358.00 (paid by mortgagee through escrow)
**Policy period:** May 2, 2026 - May 2, 2027
**Payment:** Included in monthly mortgage escrow ($41.67/month hazard portion)

**Insurance binder:** G:\My Drive\Personal\66 S 6th Street\Insurance Binder.pdf
**Additional insureds:** G:\My Drive\Personal\66 S 6th Street\binder with additional insureds.pdf

**Certificates:**
- Certificate Bridgeview.pdf (for mortgage lender)
- Certificate Wall.pdf (for building)

## Property Valuation Tracking

**Current estimated value:** ~$1,086,755 (Average of Zillow + Redfin - September 17, 2026)
- **Zillow Zestimate:** $931,100
- **Redfin Estimate:** $1,242,410
- **Difference:** $311,310 (28.6% variance)

**Purchase price:** $895,000 (April 2025)
**Appreciation:** $191,755 (+21.4% in 17 months based on average)

**Automated tracking (Sep 17, 2026):**
- **Zillow:** Fully automated via dashboard "Refresh Prices" button (fetches via RapidAPI, saves to Supabase)
- **Redfin:** Manual script `fetch_redfin_property_value.py` (run monthly)
- **Average calculation:** Automatic in dashboard (uses both Zillow + Redfin when available)
- **Storage:** Supabase `real_estate_history` table (separate rows for each data_source)
- **Dashboard:** finances.html → Investments tab → Real Estate card (click to see breakdown)

**Tracking method:**
- Zillow via RapidAPI (automated via dashboard button - 1000 free calls/month)
- Redfin via web scraping (manual script due to CORS restrictions)
- Dashboard automatically averages both estimates for portfolio calculations
- Real Estate modal shows both individual estimates + average + variance

**Historical estimates:**
- September 17, 2026: $931,100 (Zillow), $1,242,410 (Redfin), $1,086,755 (average)
- April 2025: $895,000 (purchase price - baseline)

**Scripts location:**
- `C:\Users\fmartine\Personal\repos\personal\finances\scripts\fetch_redfin_property_value.py` (monthly manual)
- `C:\Users\fmartine\Personal\repos\personal\finances\finances.html` (dashboard with Zillow automation)

**Manual override:** If you get a professional appraisal, update cost basis and add note in Supabase

## Property Taxes

**Annual tax:** $11,191.12 (2026-2027 tax year)
**Quarterly bill:** $2,797.78 (due Oct 1, Jan 1, Apr 1, Jul 1)
**Monthly escrow:** $771.70/month (collected by Chase)
**Previous annual:** $7,402.00 (2025-2026 - increased by $3,789.12/year or +51%)
**Payment method:** Paid from mortgage escrow account

**Tax increase analysis (September 2026):**
- **Assessed value:** $59,216 (2025-26) → $89,968 (2026-27) - **+51.9% increase**
- **Market value (NYC estimate):** $155,430 → $213,143 - **+37.1% increase**
- **Cause:** Williamsburg real estate market surge + NYC reassessment caught up to reality
- **Remaining tax benefit:** 8-30% limitation abatement (partial 421-a still active but phasing out)
- **Your condo gained ~$58K in value** but property taxes increased $3,789/year as a result

**Recent payment:**
- Date: September 11, 2026
- Amount: $2,797.78 (Q2 2026-2027 bill, due October 1)
- Paid by: Chase from escrow account
- This payment triggered the escrow shortage ($2,605.30)

**Tax documents & records:**
- **Property tax bills:** G:\My Drive\Personal\Property\66 S 6th Street\Property Tax\ (quarterly bills, see extraction schedule below)
- **Market value assessments:** G:\My Drive\Personal\Property\66 S 6th Street\Market Value Assessments\ (annual assessment roll, see extraction schedule below)
- **NYC property tax lookup:** https://a836-pts-access.nyc.gov/care/ (BBL: 3-2470-1105)
- **Assessment roll:** Block 2470, Lot 1105, Tax Class 2C (residential condo)

**Quarterly extraction schedule:**
NYC sends **4 quarterly tax bills per year** (July 1 - June 30 tax year):
1. **Q2 bill (mailed in August):** Due October 1 - Download and save as `MM-DD-YYYY.pdf`
2. **Q3 bill (mailed in November):** Due January 1 - Download and save as `MM-DD-YYYY.pdf`
3. **Q4 bill (mailed in February):** Due April 1 - Download and save as `MM-DD-YYYY.pdf`
4. **Q1 bill (mailed in May):** Due July 1 - Download and save as `MM-DD-YYYY.pdf`

**Annual extraction schedule:**
NYC publishes **Final Assessment Roll** in January (for upcoming tax year starting July 1):
- Download and save as `YYYY-YYYY.pdf` (e.g., `2026-2027.pdf`)
- Shows assessed value and NYC market value for the tax year
- Compare to previous year to calculate property tax impact

## Utilities

**Electric:** Con Edison - Account #62302-57147-6 (varies by usage)
**Gas:** (Check if separate or included in electric)
**Internet & Phone:** Verizon Fios - $138/month
**Water/sewer:** Included in common charges

## Building Access

**Keys:** Multiple sets - one carried daily, spare in home, lock-safe outside apartment on stair rails
**Intercom code:** None
**Access codes:** None
**Mailbox:** (Number if known)
**Storage unit:** (If applicable)
**Parking:** (If applicable)

## Vendors

**Super/Handyman:** (Add contact)
**Plumber:** (Add if have preferred)
**Electrician:** (Add if have preferred)
**Locksmith:** (Add local locksmith)

## Emergency Contacts

**Building emergency:** (Add super/management 24/7 number)
**Gas leak:** National Grid 1-800-75-CONED
**Water leak:** (Building super first, then NYC DEP)
**Fire/Police:** 911

## Previous Address (Historical)

**67 Wall Street:** G:\My Drive\Personal\DMV\67 Wall Lease Agreement.png (previous lease)
