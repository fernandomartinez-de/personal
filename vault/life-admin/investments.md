---
type: life-admin
last_updated: 2026-09-21
related: [[life-admin/taxes]], [[life-admin/retirement]]
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

**Automation:** Employer 401k holdings auto-pull daily via Plaid Investments
into `stocks_crypto_history` as asset_type `Retirement` (workflow
`pull-investments.yml`). Details in [[workflows/finances/finances-automation]].

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
