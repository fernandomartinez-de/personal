---
type: life-admin
last_updated: 2026-09-27
related: [[employment]], [[investments]], [[taxes]], [[workflows/finances/finances-automation]], [[workflows/tech/lyftr-app]]
---

# Retirement Accounts

## Fidelity NetBenefits (SS&C 401k)

**Account:** G:\My Drive\Personal\Employment\Retirement\Confirmation_ Fidelity NetBenefits.pdf
**Portal:** nb.fidelity.com (NetBenefits)
**Account number:** 401(k): 7458 (last 4)
**Current balance:** ~$3,120.90 (auto-pulled from Fidelity via Plaid; refreshes weekdays)
**Current holding:** CG 2055 target-date fund (ticker `ONUY`)

**Automation (LIVE):** The 401k value updates automatically from Fidelity via
Plaid Investments. Weekday snapshots land in Supabase
`stocks_crypto_history` with `asset_type = 'Retirement'`, driven by
`.github/workflows/pull-investments.yml` (cron `0 22 * * 1-5`, 18:00 ET),
running `finances/scripts/plaid_investments_sync.py`.

This is an employer 401k accessed through Fidelity NetBenefits. If NetBenefits
only exposes the account balance rather than each fund, the pipeline records
the total account balance as a single row (asset_name suffixed `(balance)`)
so the retirement value is still captured.

The v2 Lyftr app (see [[workflows/tech/lyftr-app]]) reads this live value in
the Hub card, Finances → Investments page (sunburst / ladder / stat cards),
and the "How Your 401(k) Works" modal. The prior hardcoded $2,480.30
fallback constant lingers in a few source files as a defensive default when
the Supabase query returns zero rows; when the live pull is healthy it is
never used.

**Contribution rate:** 6% Roth contributions
**Employer match:** (Check benefits guide - typically 50% up to 6%)
**Vesting schedule:** (Check benefits guide - immediate, graded, or cliff)

**Investment elections:** (Add fund selections or target date fund from Fidelity)
**Auto-increase:** (Check if enrolled in annual increase)

## Contribution Limits (2026)

**401(k) limit:** $23,000 (employee contribution)
**Catch-up (age 50+):** $7,500 additional
**Total limit (employee + employer):** $69,000

**Current contribution:** (Calculate annual based on % and salary)

## Previous Employer 401(k)s

**NYDIS 401(k):** (Add if rolled over or still open)
- Provider: (Add)
- Balance: (Add)
- Rollover date: (Add if completed)

**Kyriba 401(k):** (Add if applicable)

**Action needed:** Consider consolidating old 401(k)s into Fidelity or IRA

## IRA (Individual Retirement Account)

**Account:** (Add if have IRA separate from 401k)
**Type:** Traditional or Roth
**Provider:** (Add - Fidelity, Vanguard, etc.)
**Balance:** (Add)

**Contribution limit (2026):** $7,000 ($8,000 if age 50+)

**Roth IRA income limits:** (Verify eligibility based on salary)

## Retirement Planning

**Target retirement age:** (Add)
**Years to retirement:** (Calculate)
**Estimated need:** (Rule of thumb: 25x annual expenses)

**Savings rate:** (Total % going to retirement accounts)
**On track?** (Use retirement calculator)

## Social Security

**Estimated benefit:** (Check ssa.gov/myaccount for estimate)
**Full retirement age:** 67 (for most people born after 1960)
**Early retirement:** 62 (reduced benefit)
**Delayed retirement:** 70 (max benefit)

**SSA account:** ssa.gov/myaccount (create if not have)

## Beneficiaries

**401(k) primary:** Not designated (deferred by choice)
**401(k) contingent:** Not designated
**IRA beneficiary:** N/A (no IRA)

**Note:** Foreign beneficiaries (e.g., Mom in Mexico) can be designated via phone (1-800-343-3548) using RFC or without SSN
**Decision:** Deferred for now, will revisit when ready
**Update after:** Marriage, divorce, births, deaths

## Required Minimum Distributions (RMD)

**Age:** 73 (as of current law)
**Calculation:** IRS tables based on account balance and life expectancy
**Penalty:** 50% of amount not withdrawn if miss RMD

## Rollover Strategy

**If change jobs:**
- Option 1: Roll old 401(k) to new employer 401(k)
- Option 2: Roll to IRA (more investment choices)
- Option 3: Leave in old plan (if allowed)
- **Don't:** Cash out (taxes + 10% penalty if under 59.5)

## Estate Planning

**Retirement accounts** are largest asset for most people - review beneficiaries annually
**Consider:** Will, trust, power of attorney (see separate estate planning docs if created)
