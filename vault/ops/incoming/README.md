---
tags: [inbox, incoming, automation]
---

# Incoming

Drop zone for all incoming documents and files to be processed, sorted, and filed.

## Purpose

Central inbox for all personal documents before they're processed by automation scripts. Files dropped here are:
1. Analyzed and classified by type (medical, financial, employment, tax, ID, etc.)
2. Renamed to standard format (YYYY-MM-DD_category_description.ext)
3. Moved to appropriate Google Drive folder
4. Vault notes created or updated with metadata

## Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                    INCOMING FILE FLOW                           │
└────────────────────────────────────────────────────────────────┘

    YOU DROP FILES
         │
         ▼
┌─────────────────┐
│  vault/incoming │  ← Lab PDFs, statements, tax docs, IDs,
└─────────────────┘    insurance, employment papers
         │
         │ process_personal_inbox.py
         ▼
┌─────────────────┐
│   CLASSIFY      │
│                 │
│ • Extract text  │
│ • Match         │
│   keywords      │
│ • Detect type   │
└─────────────────┘
         │
         ▼
┌─────────────────┐
│   EXTRACT       │
│                 │
│ • Find dates    │
│ • Parse vendor  │
│ • Get metadata  │
└─────────────────┘
         │
         ▼
┌─────────────────┐
│    RENAME       │
│                 │
│ YYYY-MM-DD_     │
│   category_     │
│   source_       │
│   detail.ext    │
└─────────────────┘
         │
         ├──────────────┬──────────────┬──────────────┬──────────────┐
         ▼              ▼              ▼              ▼              ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│   Medical/   │ │  Finances/   │ │    Tax/      │ │     ID/      │ │ Employment/  │
│  {year}/     │ │  {vendor}/   │ │  {year}/     │ │  {country}/  │ │   {year}/    │
│  {category}/ │ │  {year}/     │ │              │ │              │ │              │
└──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘
         │              │              │              │              │
         └──────────────┴──────────────┴──────────────┴──────────────┘
                                  │
                    GOOGLE DRIVE (filed & organized)
                                  │
                                  ▼
                          ┌───────────────┐
                          │  VAULT NOTES  │
                          │   UPDATED     │
                          │               │
                          │ • Medical     │
                          │ • Financial   │
                          │ • Tax         │
                          │ • Identity    │
                          │ • Employment  │
                          └───────────────┘
                                  │
                                  ▼
                          [ COMPLETE & TRACKED ]
```

---

## Workflow

**Manual step (you):**
1. Drop files into `vault/incoming/`
   - Lab PDFs
   - Bill statements
   - Tax documents
   - ID scans
   - Employment papers
   - Insurance docs
   - Misc personal documents

**Automated step (scripts):**
2. Classification script runs (on-demand or scheduled)
3. Files are analyzed:
   - Pattern matching on filename and content
   - PDF text extraction for keywords
   - Date extraction from filename or content
4. Files renamed to standard format:
   - Medical: `YYYY-MM-DD_labs_provider_test.pdf`
   - Financial: `YYYY-MM-DD_statement_vendor.pdf`
   - Tax: `YYYY_w2_employer.pdf`
   - ID: `YYYY-MM-DD_passport_country.pdf`
5. Files moved to Google Drive:
   - Medical → `G:\My Drive\Personal\Medical\{year}\{category}\`
   - Financial → `G:\My Drive\Personal\Finances\{vendor}\{year}\`
   - Tax → `G:\My Drive\Personal\Tax\{year}\`
   - ID → `G:\My Drive\Personal\ID\{country}\`
   - Employment → `G:\My Drive\Personal\Employment\{year}\`
6. Vault notes created/updated:
   - Medical: update [[workflows/health/test-results-tracker]]
   - Financial: create expense entry
   - Tax: update [[life-admin/taxes]]
   - ID: update [[identity/licenses]] or [[identity/visas]]

## File Types Supported

**Medical:**
- Lab results (Quest, LabCorp, Hospital Angeles)
- Radiology reports
- Ultrasound reports
- InBody composition scans
- Doctor visit summaries
- Prescriptions

**Financial:**
- Bank statements (Chase)
- Credit card statements (Chase Freedom, Chase Unlimited)
- Mortgage statements
- Property tax bills
- HOA statements
- Utility bills (ConEd, Verizon)

**Tax:**
- W-2 forms
- 1099 forms
- 1098 mortgage interest statements
- Property tax statements
- Charitable donation receipts

**Identity:**
- Passport scans
- Driver's license scans
- Visa documents
- Birth certificate
- SSN card

**Employment:**
- Offer letters
- Benefits summaries
- Pay stubs
- TN visa renewals
- Performance reviews

**Insurance:**
- Health insurance cards
- Property insurance declarations
- Auto insurance (if applicable)

**Estate Planning / Trust:**
- Revocable Living Trust documents
- Pour Over Will
- Power of Attorney
- Advance Health Care Directive
- HIPAA Authorization
- Schedule of Assets
- Certification of Trust
- Trust Funding Guides
- Bills of Transfer

## Processing Scripts

**Primary script:** `personal/docs/process_personal_inbox.py`

**What it does:**
- Scans `vault/incoming/` recursively
- Classifies each file by pattern matching
- Extracts dates and metadata
- Renames to standard format
- Moves to appropriate Google Drive folder
- Creates/updates vault notes
- Logs all actions

**Manual execution:**
```bash
cd personal/docs
python process_personal_inbox.py
```

**Or via batch file:**
```bash
PROCESS_INBOX.bat
```

**Automated execution:**
- TBD: GitHub Actions daily scan
- TBD: Watch folder trigger (if on Windows with Task Scheduler)

## Output Locations

After processing, files are moved to:

**Google Drive folders:**
- Medical: `G:\My Drive\Personal\Medical\`
- Finances: `G:\My Drive\Personal\Finances\`
- Tax: `G:\My Drive\Personal\Tax\`
- ID: `G:\My Drive\Personal\ID\`
- Employment: `G:\My Drive\Personal\Employment\`
- Insurance: `G:\My Drive\Personal\Insurance\`
- Property: `G:\My Drive\Personal\Property\`
- Trust: `G:\My Drive\Personal\Property\66 S 6th Street\Trust\`

**Vault notes updated:**
- [[workflows/health/providers]]
- [[workflows/health/insurance]]
- [[workflows/finances/credit-banking]]
- [[life-admin/taxes]]
- [[life-admin/employment]]
- [[identity/licenses]]
- [[identity/visas]]
- [[life-admin/real-estate]]

## Error Handling

**Unclassifiable files:**
- Moved to `G:\My Drive\Personal\_REVISAR\`
- Prefixed with `REVISAR_`
- Log entry created for manual review

**Duplicate files:**
- Script checks for exact filename match in destination
- Prompts for confirmation before overwrite
- Option to skip or rename with timestamp

**Missing dates:**
- Falls back to file modified date
- Logs warning for manual review
- Uses `YYYY-MM-DD_unknown_` prefix

## Manual Review

**Check these locations after processing:**
1. `G:\My Drive\Personal\_REVISAR\` - unclassified files
2. Processing log: `personal/docs/logs/YYYY-MM-DD_process_log.txt`
3. Vault notes - verify metadata updated correctly

## Related

- [[workflows/docs/docs-automation]] - full workflow documentation
- [[workflows/docs/scripts]] - script details
- [[workflows/health/health-data-pipeline]] - medical file subset
