---
type: life-admin
last_updated: 2026-09-27
related: [[life-admin/taxes]], [[life-admin/retirement]], [[workflows/finances/finances-automation]], [[workflows/tech/lyftr-app]]
---

# Investments & Accounts

## Morgan Stanley

**Account type:** Brokerage/Investment account
**Account number:** 930-049013-170
**Portal:** morganstanley.com/access

**Tax documents:** G:\My Drive\Personal\Tax&BS\Tax 2025\Morgan Stanley\
- 3 PDFs (2026-04-15 statements)

**Purpose:** Taxable brokerage for stocks
**Holdings:** 
- AAPL: ~28 shares
- NCDA: ~60 shares
- TSLA: ~21 shares
(Verify current positions from latest statement)

**Automation:** These manual positions (AAPL, NVDA, TSLA, Bitcoin) stay in
Supabase `stocks_crypto_history` as asset_type `Stock` / `Crypto`, hand-updated
as before. Auto-pulled Fidelity retirement holdings share the same table under
asset_type `Retirement` (see [[life-admin/retirement]]) and never overwrite the
manual rows.

**Contact:** No dedicated financial advisor - self-managed account

## Coinbase

**Account type:** Cryptocurrency exchange
**Account email:** fernandopv2655@gmail.com
**2FA:** ✅ **ENABLED** (completed 2026-09-14)

**Tax documents:** G:\My Drive\Personal\Tax&BS\Tax 2025\Coinbase\Coinbase 1099.pdf

**Holdings:** 0.06116791 BTC (as of 2026 - check current value)
**Tax treatment:** Crypto = property (capital gains on sales)

**SECURITY PRIORITY:** Enable 2FA immediately (authenticator app, not SMS)

**Security:**
- Enable 2FA (authenticator app, not SMS)
- Store recovery phrase offline (secure location)
- Withdrawal whitelist (if available)

## Fidelity NetBenefits (401k)

See [[life-admin/retirement]] for details.

Confirmation: G:\My Drive\Personal\Employment\Retirement\Confirmation_ Fidelity NetBenefits.pdf

**Automation (LIVE):** Employer 401k holdings auto-pull weekdays via Plaid
Investments into `stocks_crypto_history` as `asset_type = 'Retirement'`.
Pipeline: `.github/workflows/pull-investments.yml` (cron `0 22 * * 1-5`,
18:00 ET) → `finances/scripts/plaid_investments_sync.py` →
`/investments/holdings/get`. One-time auth via
`finances/scripts/plaid_investments_link.py` (Plaid Hosted Link, separate
Plaid item from Chase). Access token stored in GitHub Actions secret
`PLAID_FIDELITY_ACCESS_TOKEN`. Local files
`.plaid_investments_secrets.local` and `.env` are gitignored and never
committed. Details in [[workflows/finances/finances-automation]].

## Live Price Refresh (v2 Lyftr Investments Tab)

The v2 React app (see [[workflows/tech/lyftr-app]]) has a manual **↻ Refresh
Prices** button on the Investments page that writes a fresh snapshot into
`stocks_crypto_history` on demand:

- **Stocks (AAPL, NVDA, TSLA):** Finnhub `/quote` endpoint
- **Crypto (Bitcoin):** CoinGecko `/simple/price`
- **Real estate (Condo Zillow estimate):** RapidAPI Zillow scraper

Manual holdings (Stock / Crypto rows) are hand-tracked and never overwritten
by the weekday Fidelity Plaid pull, which only touches `Retirement` /
`Brokerage` rows. Cost basis for TSLA is `$200` (7 shares bought in 2020,
now 21 shares after 2022 3-for-1 split).

## Other Accounts

**Checking & Savings:** Chase (primary banking)
**Emergency fund:** Target: ~$30k (6 months expenses) - track in budget spreadsheet

## Investment Strategy

**Risk tolerance:** (Conservative, moderate, aggressive)
**Time horizon:** (Years until retirement/goal)
**Asset allocation:** (% stocks, bonds, cash, alternative)

**Rebalancing:** (Frequency - annual, quarterly, threshold-based)

## FBAR Requirement (Foreign Accounts)

**Threshold:** $10,000 total across all foreign accounts at any point in year
**Form:** FinCEN 114 (filed online, due June 15)

**Foreign accounts:** (Add if have Mexico bank accounts, investment accounts abroad)

## Performance Tracking

**Benchmarks:** S&P 500, bond index, etc.
**Review frequency:** Quarterly
**Last reviewed:** (Add date)

## Beneficiaries

**Morgan Stanley:** Not yet designated - add during account review
**Coinbase:** (Add if allows beneficiary designation)
**401(k):** (Add beneficiary - see retirement)

**Keep beneficiaries updated** after life changes (marriage, divorce, births, deaths)
