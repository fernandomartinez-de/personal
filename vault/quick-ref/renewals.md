---
type: quick-ref
last_updated: 2026-09-14
related: [[identity/citizenship]], [[identity/visas]], [[identity/licenses]], [[life-admin/real-estate]], [[workflows/health/insurance]]
---

# Renewals & Expirations Tracker

**Everything with an expiry date - check quarterly, act 3-6 months before expiration**

## Identity Documents

| Document | Expiry Date | Renewal Window | Lead Time |
|----------|-------------|----------------|-----------|
| **Spain passport** | April 29, 2030 | October 2029 | 2-3 months |
| **Mexico passport** | February 28, 2029 | August 2028 | 2-3 months |
| **Canada passport** | April 8, 2029 | October 2028 | 2-3 months |
| **TN visa (I-94)** | June 22, 2029 | December 2028 | 3-6 months |
| **NY drivers license** | November 27, 2026 | **NOW - October 2026** | 1-2 months |

## Insurance

| Policy | Renewal Date | Lead Time |
|--------|--------------|-----------|
| **Homeowners insurance** | (From [[real-estate]]) | 30 days before |
| **Health insurance** | January 1 (open enrollment Oct-Nov) | Enroll in Nov |

## Housing

| Item | Due Date | Frequency |
|------|----------|-----------|
| **Property tax (NYC)** | Quarterly (varies by borough) | Check DOF notices |
| **HOA common charges** | Monthly (auto-pay) | Verify payment processing |
| **Mortgage** | Monthly (auto-pay on [day]) | Annual review |

## Professional

| Item | Expiry/Due | Frequency |
|------|-----------|-----------|
| **Professional licenses** | (If applicable - CFA, CPA, etc.) | Annual/biennial |
| **Continuing education** | (If required for license) | Track credits |

## Health

| Item | Last Done | Next Due | Frequency |
|------|-----------|----------|-----------|
| **Thyroglobulin test** | (From [[workflows/health/test-results-tracker]]) | (6 months from last) | Every 6 months |
| **Thyroid ultrasound** | (From [[workflows/health/test-results-tracker]]) | (1 year from last) | Annual |
| **PET scan** | (From [[workflows/health/test-results-tracker]]) | 2028 (approx) | Every 4 years |
| **InBody composition** | (From Supabase or dashboard) | (2-3 months from last) | 2-3 months |
| **Annual physical** | (Add if schedule) | (Add) | Annual |
| **Dental cleaning** | (Add if schedule) | (Add) | Every 6 months |
| **Vision exam** | (Add if schedule) | (Add) | 1-2 years |

## Subscriptions & Services

| Service | Renewal Date | Cost | Auto-Renew? |
|---------|--------------|------|-------------|
| **WHOOP membership** | (Add if paid subscription) | (Add) | Yes/No |
| **GitHub Pro** | (Add if have) | (Add) | Yes/No |
| **Anthropic API credits** | Pay-as-you-go | ~$3-5/month | Yes |
| **Supabase** | Free tier | $0 | N/A |
| **Netflix, Spotify, etc.** | (Add from [[life-admin/expenses]]) | (Add) | Yes/No |
| **Gym membership** | (Add if have) | (Add) | Yes/No |

## Financial

| Item | Due Date | Action |
|------|----------|--------|
| **Tax return (federal)** | April 15 | File by deadline |
| **Tax return (NY state)** | April 15 | File by deadline |
| **FBAR (foreign accounts)** | June 15 (if >$10k abroad) | File if applicable |
| **Retirement contribution (401k)** | December 31 (for tax year) | Max out if possible |
| **IRA contribution** | April 15 (for prior tax year) | Contribute if eligible |
| **FSA/HSA use-it-or-lose-it** | December 31 | Spend balance |

## Technology

| Item | Expiry/Renewal | Action |
|------|----------------|--------|
| **GitHub PAT (GH_PAT secret)** | (Check expiry - typically 90 days or 1 year) | Regenerate before expiry |
| **WHOOP OAuth refresh token** | Auto-rotates (no action needed) | Monitor daily_sync workflow |
| **Google service account key** | No expiry (but audit annually) | Verify Drive permissions |
| **Anthropic API key** | No expiry (but can rotate) | Monitor usage |
| **Domain names** | (Add if own any) | Renew annually |

## Quarterly Review Checklist

**Every 3 months (March, June, September, December):**
1. Review this file - anything expiring in next 6 months?
2. Check health schedule - thyroglobulin due?
3. Review subscriptions - cancel anything unused?
4. Check GitHub Actions - all workflows running?
5. Verify dashboard freshness - "Generado" date current?
6. Mom check: `_REVISAR` folder empty?

## Annual Review Checklist

**Every January:**
1. Update passport/visa expiry dates if renewed
2. Update insurance policy numbers if changed
3. Review all auto-pay settings - correct bank accounts?
4. Check credit reports (annualcreditreport.com)
5. Update beneficiaries (401k, IRA, insurance)
6. Review this vault - anything stale?
