# Fernando Martinez - Personal Vault

**Purpose:** Persistent life context for working with Claude across sessions. This vault contains personal information, health surveillance infrastructure, cross-border logistics, and lifecycle tracking that persists beyond any single conversation.

**Not for:** Work context (that lives in ssc-vault-fm). This vault is personal life, health, identity, and admin.

**Structure:**

```
/workflows/       Complete automation documentation (health, docs, finances, travel, tech)
                  Includes: scripts/, tables/ (Google Drive structure)
/ops/             Operations: incoming/ (inbox), outgoing/ (outputs), outstanding/ (tasks)
/identity/        Passports, visas, licenses, citizenship
/life-admin/      Real estate, taxes, employment, investments
/family/          Mom, dad, siblings, emergency contacts
/quick-ref/       Emergency info, renewals, documents index, key dates
```

**How to use:**
1. Start with VAULT_INDEX.md for navigation
2. Health info: workflows/health/
3. Emergency brief: quick-ref/emergency.md
4. Technical issues: workflows/tech/troubleshooting.md

**Last updated:** 2026-09-21

**Recent changes (2026-09-21):**
- Chase transactions Plaid pull is LIVE (first run pulled 64 transactions, reconciled clean).
- New Fidelity retirement holdings pull via Plaid Investments (weekday snapshots into `stocks_crypto_history`); awaiting Plaid review.
- Security: this vault was removed from the public repo and scrubbed from git history. It is now local only and gitignored. Do NOT commit or stage anything under `vault/`.

**Vault owner:** Fernando Martinez
**Location:** `C:\Users\fmartine\Personal\repos\personal\vault\` (local only; gitignored)
