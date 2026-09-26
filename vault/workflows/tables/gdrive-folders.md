# Google Drive Folder Structure

Complete map of Fernando's personal Google Drive organization at `G:\My Drive\Personal\`

This document serves as the canonical reference for all automation workflows that interact with Google Drive.

## Root Location

**Mounted path:** `G:\My Drive\Personal\`  
**Service account access:** Via `GOOGLE_CREDENTIALS` secret for GitHub Actions  
**Local access:** Google Drive for Desktop (direct filesystem access)

---

## Complete Folder Tree

```
G:\My Drive\Personal\
├── Medical\
│   ├── _REVISAR\                    # Pending review/filing (monthly cleanup)
│   ├── 2018\
│   │   ├── labs\
│   │   └── radiologia\
│   ├── 2019\
│   │   ├── labs\
│   │   ├── radiologia\
│   │   └── patologia\              # Thyroid cancer biopsy
│   ├── 2020\
│   │   ├── labs\
│   │   └── radiologia\              # RAI uptake scan + PET baseline
│   ├── 2021\
│   │   └── labs\
│   ├── 2022\
│   │   └── labs\
│   ├── 2023\
│   │   └── labs\
│   ├── 2024\
│   │   └── labs\
│   ├── 2025\
│   │   └── labs\
│   └── 2026\
│       ├── labs\                    # Lab results (thyroglobulin, TSH, free T4)
│       ├── radiologia\              # X-rays, CT, PET scans
│       ├── ultrasonidos\            # Ultrasound reports
│       └── inbody\                  # Body composition scans
│
├── Finances\
│   ├── Chase\                       # Chase Freedom Unlimited statements
│   │   ├── 2024\
│   │   ├── 2025\
│   │   └── 2026\
│   ├── Amex\                        # Amex extension card statements
│   │   ├── 2024\
│   │   ├── 2025\
│   │   └── 2026\
│   ├── Verizon\                     # Internet bills
│   │   ├── 2024\
│   │   ├── 2025\
│   │   └── 2026\
│   ├── Con Edison\                  # Electric utility bills
│   │   ├── 2024\
│   │   ├── 2025\
│   │   └── 2026\
│   ├── HOA\                         # HOA monthly fees
│   │   ├── 2024\
│   │   ├── 2025\
│   │   └── 2026\
│   └── Chase Mortgage\              # Mortgage statements
│       ├── 2024\
│       ├── 2025\
│       └── 2026\
│
├── Tax\
│   ├── W2\                          # All W2s (any year)
│   ├── Tax 2019\
│   ├── Tax 2020\
│   ├── Tax 2021\
│   ├── Tax 2022\
│   ├── Tax 2023\
│   ├── Tax 2024\
│   └── Tax 2025\
│       ├── 2025 Tax Return\        # Filed 1040 + schedules
│       ├── W2\                      # 2025 W2 from SS&C
│       ├── Coinbase\                # 1099-MISC crypto gains
│       ├── Morgan Stanley\          # 1099-DIV dividends
│       └── Chase (Mortgage)\        # 1098 mortgage interest
│
├── Employment\
│   ├── Resume\                      # Current resume versions
│   ├── Kyriba\                      # Previous employer
│   │   ├── Offer Letter\
│   │   └── Benefits\
│   ├── NYDIS\                       # Previous employer
│   │   ├── Offer Letter\
│   │   └── Benefits\
│   └── SS&C\                        # Current employer (State Street Corp)
│       ├── Offer Letter\
│       ├── Benefits\                # 401k docs, insurance summary
│       ├── Paystubs\
│       └── TN Visa\
│           ├── Approval Notice\
│           ├── I-94\                # I-94 admit until record
│           └── Supporting Docs\     # Degree, employment letter
│
├── ID\
│   ├── SSN\                         # Social Security card scan
│   ├── Visa\                        # US visa history (if applicable)
│   ├── Canada\                      # Canadian passport + citizenship
│   ├── Drivers Liscence\            # NY driver's license (expires Nov 2026)
│   ├── Spain\                       # Spanish passport + NIE
│   └── Mexico\                      # Mexican passport + INE
│
├── Education\
│   ├── Universidad de Lima\
│   │   ├── Transcript\
│   │   ├── Diploma\
│   │   └── I-20\                    # F1 visa documents
│   └── Certifications\
│
├── Insurance\
│   ├── Health\                      # Cigna policy declarations
│   ├── Home\                        # Home insurance policy
│   └── Claims\                      # Submitted claims + receipts
│
├── Property\
│   └── 66 S 6th Street\             # Current residence
│       ├── Purchase\                # Closing documents, deed
│       ├── Mortgage\                # Mortgage contract (Chase)
│       ├── HOA\                     # HOA bylaws, rules
│       ├── Insurance\               # Home insurance
│       ├── Tax\                     # Property tax bills
│       ├── Utilities\               # Setup documents
│       ├── Repairs\                 # Maintenance records
│       └── Keys\                    # Key copies info
│
├── Travel\                          # Trip archives (future)
│   └── (empty - planning sites via GitHub Pages)
│
└── vault\                           # This vault (synced from GitHub)
    └── (version controlled separately)
```

---

## Naming Conventions

### Medical Files
**Format:** `YYYY-MM-DD_{type}_{source}_{description}.pdf`

Examples:
- `2026-04-17_labs_quest-mx_general.pdf`
- `2025-03-05_labs_quest-mx_thyroglobulin-stimulated.pdf`
- `2024-09-12_radiologia_abc_ultrasound-neck.pdf`
- `2026-01-20_ultrasonidos_abc_thyroid.pdf`

### Finance Files
**Format:** `YYYY-MM_{vendor}_{type}.pdf`

Examples:
- `2026-01_chase_statement.pdf`
- `2026-02_verizon_bill.pdf`
- `2026-03_con-edison_statement.pdf`

### Tax Files
**Format:** `YYYY-{form-type}_{source}.pdf`

Examples:
- `2025-W2_ssc.pdf`
- `2025-1098_chase-mortgage.pdf`
- `2025-1099-DIV_morgan-stanley.pdf`
- `2025-1040_tax-return.pdf`

### Employment Files
**Format:** `YYYY-MM-DD_{type}_{company}.pdf`

Examples:
- `2024-05-14_offer-letter_ssc.pdf`
- `2024-06-01_benefits-summary_ssc.pdf`
- `2026-06-22_tn-visa-approval_ssc.pdf`

### ID Files
**Format:** `{country}_{document-type}_{year-issued}.pdf`

Examples:
- `canada_passport_2025.pdf`
- `spain_passport_2020.pdf`
- `ny_drivers-license_2018.pdf`

---

## Automation Workflows

### Health Pipeline
**Automated via GitHub Actions**

- **Medical labs ingestion:** Weekly Monday 9 AM UTC
  - Scans: `G:\My Drive\Personal\Medical\{YEAR}\labs\*.pdf`
  - Extracts: TSH, free T4, thyroglobulin
  - Stores: Supabase `labs` table
  
- **Medical file cleanup:** Monthly 1st day midnight
  - Scans: `G:\My Drive\Personal\Medical\_REVISAR\`
  - Suggests: Year/category for unfiled PDFs
  - Moves: Confirmed files to correct year/folder

**Script:** `personal/health/medical/ingest_labs_gdrive.py`  
**Credentials:** `GOOGLE_CREDENTIALS` (service account JSON)

### Personal Docs Processing
**Manual on-demand**

- **Inbox processing:** Pattern matching and classification
  - Source: `C:\Users\fmartine\Personal\repos\personal\docs\inbox\`
  - Targets: Various folders per pattern (see [[docs/docs-automation]])
  - Renames: Applies standard naming convention
  
- **Expiration scanning:** Document expiration tracking
  - Scans: `G:\My Drive\Personal\ID\`, `Insurance\`, `Employment\`
  - Outputs: CSV + HTML report with expiration dates

**Script:** `personal/docs/process_personal_inbox.py`  
**Access:** Google Drive for Desktop (G:\ drive must be mounted)

### Finance Statement Filing
**Manual monthly**

- **Statement organization:** Vendor-based filing
  - Download from vendor sites
  - Rename to `YYYY-MM_{vendor}_{type}.pdf`
  - File to: `G:\My Drive\Personal\Finances\{vendor}\{YEAR}\`
  
**Script:** Manual (no automation yet)  
**Future:** `personal/finances/categorize_expenses.py` (TBD)

---

## Access Methods

### Local Access (Manual Workflows)
- **Method:** Google Drive for Desktop app
- **Mount point:** `G:\My Drive\Personal\`
- **Used by:** 
  - `docs/process_personal_inbox.py`
  - `docs/scan_expirations.py`
  - Manual file management

### API Access (GitHub Actions)
- **Method:** Google Drive API via service account
- **Credentials:** `GOOGLE_CREDENTIALS` repository secret
- **Used by:**
  - `health/medical/ingest_labs_gdrive.py`
  - `health/medical/clean_medical_drive.py`
- **Permissions:** Read/write access to `G:\My Drive\Personal\`

---

## Storage Quotas & Cleanup

**Google Drive storage:** 15 GB free tier

**Current usage (estimated):**
- Medical: ~2 GB (PDFs 2018-2026)
- Finances: ~500 MB
- Tax: ~300 MB
- Employment: ~200 MB
- ID: ~100 MB
- Other: ~100 MB
- **Total:** ~3.2 GB (21% of quota)

**Cleanup strategy:**
- Medical PDFs: Keep all (critical health records)
- Finance statements: Keep 7 years (IRS requirement)
- Tax documents: Keep permanently
- Employment: Keep all
- ID: Keep all
- Old employer files: Archive after 3 years post-departure

**Monthly cleanup:**
- GitHub Actions scans `Medical\_REVISAR\` folder
- Suggests filing for unfiled documents
- Archives old finance statements (>7 years) on request

---

## Backup Strategy

**Primary storage:** Google Drive (cloud)

**Secondary backup:** Local git repo at `C:\Users\fmartine\Personal\repos\personal\`
- Vault metadata: Version controlled
- Scripts: Version controlled
- **Actual documents:** NOT in git (too large, sensitive)

**Tertiary backup:** Supabase for structured data
- Medical labs: Parsed into `labs` table
- Expenses: Parsed into `expenses` table
- **Original PDFs:** Remain only in Google Drive

**Future:** Periodic Google Takeout export for disaster recovery

---

## Security & Permissions

**Personal Google account:** fernandopv2655@gmail.com  
**Service account:** Used only by GitHub Actions (read/write access)  
**Shared access:** None (private personal documents)

**Sensitive documents:**
- SSN card: `ID\SSN\`
- Passports: `ID\{country}\`
- Tax returns: `Tax\Tax {YEAR}\{YEAR} Tax Return\`
- Medical records: `Medical\{YEAR}\`

**NOT in Google Drive:**
- Passwords (in Apple Keychain)
- Cryptocurrency private keys
- Banking login credentials

---

## Related Vault Documentation

**Workflow docs:**
- [[workflows/health/health-data-pipeline]] - Medical automation
- [[workflows/docs/docs-automation]] - Personal docs processing
- [[workflows/finances/finances-automation]] - Finance tracking

**Domain knowledge:**
- [[health/thyroid-cancer]] - Medical history context
- [[identity/visas]] - Visa renewal schedules
- [[identity/licenses]] - License tracking
- [[life-admin/taxes]] - Tax filing workflow

**Quick references:**
- [[quick-ref/documents-index]] - Where is document X?
- [[quick-ref/renewals]] - Upcoming renewal dates

---

**Last updated:** 2026-09-14  
**Maintained by:** Fernando Martinez
