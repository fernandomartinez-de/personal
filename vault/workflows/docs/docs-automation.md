---
tags: [personal, docs, automation, manual]
category: personal
status: active
last_updated: 2026-09-13
repo: personal
---

# Personal Docs Automation

Automated inbox processing for personal documents with classification, renaming, and filing to Google Drive.

## Repository

`C:\Users\fmartine\Personal\repos\personal\docs\`

GitHub: `https://github.com/fernandomartinez-de/personal` (docs/ folder)

## Scripts

**→ [[docs/scripts]]**

Python automation scripts (manual execution):
- process_personal_inbox.py (document classification and filing)
- scan_expirations.py (expiration date scanning)

## Overview

```
vault/ops/incoming/ (local drop zone)
  ↓
process_personal_inbox.py (pattern matching)
  ↓
G:\My Drive\Personal\{category}\ (permanent storage)
```

Manual on-demand workflow - no GitHub Actions schedule.

## Workflows

### 1. Inbox Processing

**Schedule:** Manual (on-demand)  
**Script:** `docs/process_personal_inbox.py`  
**Launcher:** `docs/PROCESS_INBOX.bat` (double-click)

**Data Flow:**
```
User drops files into vault/ops/incoming/
  ↓
process_personal_inbox.py
  ├─> Read PDF/DOCX/XLSX content
  ├─> Pattern matching (keywords + filename)
  ├─> Extract metadata (date, source, description)
  ├─> Rename to standard format
  ├─> Move to Google Drive target folder
  └─> Update vault nodes with metadata
```

**Detection Patterns:**

| Pattern | Keywords | Target Folder |
|---------|----------|---------------|
| **Financial statements** | Account #6813, #5113, #4433, "chase", filename Activity*.xlsx | `Finances/Chase/{YEAR}/` |
| **W2** | "w-2", "w2", "wage" | `Tax/W2/` |
| **Passport** | "passport", "pasaporte" | `ID/{country}/` |
| **Medical labs** | "lab", "quest", "labcorp" | `Medical/{YEAR}/labs/` |
| **Medical radiology** | "radiologia", "x-ray", "scan", "pet", "ct" | `Medical/{YEAR}/radiologia/` |
| **Medical ultrasound** | "ultrasonido", "ultrasound" | `Medical/{YEAR}/ultrasonidos/` |
| **Medical pathology** | "patologia", "pathology", "biopsy" | `Medical/{YEAR}/patologia/` |
| **Insurance** | "insurance", "policy", "declaration" | `Insurance/` |
| **Tax 1098** | "1098", "mortgage interest" | `Tax/Tax {YEAR}/Chase (Mortgage)/` |
| **Tax 1099** | "1099", "investment", "coinbase", "morgan stanley" | `Tax/Tax {YEAR}/{source}/` |
| **Tax return** | "tax return", "1040" | `Tax/Tax {YEAR}/{YEAR} Tax Return/` |
| **Offer letter** | "offer letter", "employment agreement" | `Employment/{company}/Offer Letter/` |
| **Benefits** | "benefits", "401k", "insurance summary" | `Employment/{company}/Benefits/` |
| **TN visa** | "tn", "visa", "i-94" | `Employment/{company}/TN Visa/` |
| **Property/deed** | "deed", "mortgage", "closing", "hoa" | `Property/66 S 6th Street/` |
| **Driver's license** | "driver", "license", "dmv" | `ID/Drivers Liscence/` |
| **SSN** | "social security", "ssn" | `ID/SSN/` |
| **Education** | "transcript", "degree", "diploma", "i-20" | `Education/` |

**Naming Convention:**

Output: `YYYY-MM-DD_{category}_{source}_{description}.{ext}`

Examples:
- `2026-09-13_statement_chase-checking.xlsx` (Financial)
- `2026-04-17_labs_quest-mx_general.pdf` (Medical)
- `2025-W2_paychex.pdf` (Tax)
- `2026-05-14_offer-letter_ssc.pdf` (Employment)
- `2026-01-15_passport_canada.pdf` (ID)

**Ambiguity Handling:**

If multiple patterns match:
```python
# Example: File contains both "insurance" and "mortgage"
Detected patterns: ["insurance", "property"]

Prompt user:
  1. Insurance/
  2. Property/66 S 6th Street/
  Select target folder: _
```

**No Match:**
```
No classification pattern matched.
Moving to: vault/ops/incoming/unclassified/
Manual review required.
```

**Manual Execution:**
```bash
cd docs
python process_personal_inbox.py
```

Or double-click: `docs\PROCESS_INBOX.bat`

**Output:**
```
Processing inbox...

✓ Activity6813.xlsx
  → G:\My Drive\Personal\Finances\Chase\2026\2026-09-13_statement_chase-checking.xlsx

✓ passport_canada_2025.pdf
  → G:\My Drive\Personal\ID\Canada\2025-01-15_passport_canada.pdf

✓ quest_lab_results.pdf
  → G:\My Drive\Personal\Medical\2026\labs\2026-04-17_labs_quest-mx_general.pdf

✓ w2_paychex.pdf
  → G:\My Drive\Personal\Tax\W2\2025-W2_paychex.pdf

? unknown_document.pdf
  → vault/ops/incoming/unclassified/ (manual review required)

Processed: 4 filed, 1 unclassified
```

---

### 2. Expiration Scanner

**Schedule:** Manual (on-demand)  
**Script:** `docs/scan_expirations.py`  
**Launcher:** `docs\SCAN_EXPIRATIONS.bat` (double-click)

**Purpose:** Scan all personal documents for expiration dates and generate tracking report

**Data Flow:**
```
scan_expirations.py
  ↓
Recursively scan G:\My Drive\Personal\
  ├─> ID\ (passports, visas, licenses)
  ├─> Insurance\ (policies)
  ├─> Employment\ (TN visas, I-94)
  └─> Property\ (insurance, warranties)
  ↓
PyPDF2 text extraction + regex for dates
  ↓
CSV: expirations_tracker.csv
HTML: expirations_report.html
```

**Expiration Patterns Detected:**

- **Passports:** "Valid until", "Expiry date", "Fecha de vencimiento"
- **Visas:** "Valid until", "Admit until", "I-94 expiration"
- **Driver's license:** "Expires", "Valid through"
- **Insurance:** "Policy period", "Expires", "Renewal date"
- **TN visa:** "Valid until", "I-94 admit until"

**Output Files:**

**expirations_tracker.csv:**
```csv
document_type,file_path,expiration_date,days_until_expiry,status
Passport,ID/Canada/Canada Passport 2025.pdf,2035-01-15,3219,✓
TN Visa,Employment/SS&C/TN Visa/I-94/I-94 FernandoMartinez.pdf,2027-05-14,609,✓
Insurance,Insurance/Home Policy Declaration 2026.pdf,2027-01-01,475,✓
Driver's License,ID/Drivers Liscence/NEW YORK STATE USA.pdf,2028-09-15,1098,✓
```

**expirations_report.html:**
```
🔴 EXPIRING SOON (< 90 days)
  (none)

🟡 EXPIRING WITHIN 1 YEAR
  - TN Visa: 609 days (2027-05-14)
  - Home Insurance: 475 days (2027-01-01)

✓ VALID (> 1 year)
  - Canada Passport: 3219 days (2035-01-15)
  - Driver's License: 1098 days (2028-09-15)
```

**Manual Execution:**
```bash
cd docs
python scan_expirations.py
```

Or double-click: `docs\SCAN_EXPIRATIONS.bat`

---

## Google Drive Target Structure

Complete folder map at [[workflows/tables/gdrive-folders]].

**Key destinations:**

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
│   ├── 2021\labs\
│   ├── 2022\labs\
│   ├── 2023\labs\
│   ├── 2024\labs\
│   ├── 2025\labs\
│   └── 2026\
│       ├── labs\                    # Lab results (thyroglobulin, TSH, free T4)
│       ├── radiologia\              # X-rays, CT, PET scans
│       ├── ultrasonidos\            # Ultrasound reports
│       └── inbody\                  # Body composition scans
├── Finances\
│   ├── Chase\
│   │   ├── 2024\
│   │   ├── 2025\
│   │   └── 2026\
│   ├── Verizon\
│   ├── Con Edison\
│   ├── HOA\
│   └── Chase Mortgage\
├── Tax\
│   ├── W2\                          # All W2s (any year)
│   └── Tax 2025\
│       ├── 2025 Tax Return\
│       ├── W2\
│       ├── Coinbase\
│       ├── Morgan Stanley\
│       └── Chase (Mortgage)\
├── Employment\
│   ├── Resume\
│   ├── Kyriba\
│   ├── NYDIS\
│   └── SS&C\
│       ├── Offer Letter\
│       ├── Benefits\
│       └── TN Visa\
├── ID\
│   ├── SSN\
│   ├── Visa\
│   ├── Canada\
│   ├── Drivers Liscence\
│   ├── Spain\
│   └── Mexico\
├── Education\
├── Insurance\
└── Property\
    └── 66 S 6th Street\
```

---

## Dependencies

**Python Packages** (`docs/requirements.txt`):
```
PyPDF2>=3.0.0
python-docx>=0.8.0
pandas>=2.0.0
```

**External Access:**
- Google Drive (G:\ must be mounted via Google Drive for Desktop)
- No API credentials required (direct file system access)

---

## Failure Modes

**Ambiguous classification:**
- Multiple pattern matches
- Action: Prompt user to select target folder

**No match:**
- Unknown document type
- Action: Move to `vault/ops/incoming/unclassified/` for manual review

**Duplicate filename:**
- Target file already exists
- Action: Append counter `_2`, `_3`, etc. to avoid overwrite

**G: drive unmounted:**
- Google Drive not accessible
- Action: Error message, exit script

**Permission denied:**
- File locked by another process
- Action: Skip file, log error, continue

---

## Vault Cross-References

**Domain knowledge:**
- [[identity/visas]] - Visa types and renewal schedules
- [[identity/licenses]] - Driver's license details
- [[identity/citizenship]] - Passport tracking
- [[life-admin/taxes]] - Tax filing workflow
- [[life-admin/employment]] - Employment document organization
- [[workflows/health/insurance]] - Insurance document handling

**Related workflows:**
- [[workflows/health/health-data-pipeline]] - For medical lab PDFs (automated via Google Drive API)
- [[workflows/finances/finances-automation]] - For financial statements

**Quick references:**
- [[quick-ref/renewals]] - Renewal schedule tracker
- [[quick-ref/documents-index]] - Document location index

---

## Future Enhancements

1. **Automated scanning:** Watch `vault/ops/incoming/` folder and auto-process on file drop
2. **Email integration:** Auto-download attachments from email to inbox
3. **OCR:** Extract text from scanned/image PDFs
4. **Smart date extraction:** Improve expiration date detection accuracy
5. **Notification system:** Email/SMS alerts 90 days before expiration
6. **Cloud sync:** Process directly from Google Drive instead of local inbox
7. **Vault node auto-update:** Automatically update vault nodes with extracted metadata (partially implemented)
