---
tags: [docs, scripts, automation, python]
category: docs
last_updated: 2026-09-13
---

# Docs Scripts

Python scripts for personal document automation workflows.

**Location:** `C:\Users\fmartine\Personal\repos\personal\docs\`

---

## process_personal_inbox.py

**Purpose:** Classify, rename, and file personal documents to Google Drive

**Location:** `docs/process_personal_inbox.py`

**Schedule:** Manual (on-demand)

**Launcher:** `docs/PROCESS_INBOX.bat` (double-click to run)

**What it does:**
1. Scans `vault/ops/incoming/` for PDF, DOCX, PNG, JPG, XLSX files
2. Reads file content (PyPDF2 for PDFs, python-docx for DOCX)
3. Matches content against detection patterns (keywords + filename)
4. Extracts metadata (date, source, description)
5. Renames to standard format: `YYYY-MM-DD_{category}_{source}_{description}.ext`
6. Moves to appropriate Google Drive folder
7. Updates vault nodes with metadata

**Detection patterns:**

| Type | Keywords | Target Folder |
|------|----------|---------------|
| **Financial statements** | Account #6813, #5113, #4433, "chase", filename pattern Activity*.xlsx | `G:\My Drive\Personal\Finances\Chase\{YEAR}\` |
| W2 | "w-2", "w2", "wage" | `G:\My Drive\Personal\Tax\W2\` |
| Passport | "passport", "pasaporte" | `G:\My Drive\Personal\ID\{country}\` |
| Medical labs | "lab", "quest", "labcorp" | `G:\My Drive\Personal\Medical\{YEAR}\labs\` |
| Medical radiology | "radiologia", "x-ray", "scan", "pet", "ct" | `G:\My Drive\Personal\Medical\{YEAR}\radiologia\` |
| Medical ultrasound | "ultrasonido", "ultrasound" | `G:\My Drive\Personal\Medical\{YEAR}\ultrasonidos\` |
| Medical pathology | "patologia", "pathology", "biopsy" | `G:\My Drive\Personal\Medical\{YEAR}\patologia\` |
| Insurance | "insurance", "policy", "declaration" | `G:\My Drive\Personal\Insurance\` |
| Tax 1098 | "1098", "mortgage interest" | `G:\My Drive\Personal\Tax\Tax {YEAR}\Chase (Mortgage)\` |
| Tax 1099 | "1099", "investment" | `G:\My Drive\Personal\Tax\Tax {YEAR}\{source}\` |
| Tax return | "tax return", "1040" | `G:\My Drive\Personal\Tax\Tax {YEAR}\{YEAR} Tax Return\` |
| Offer letter | "offer letter", "employment agreement" | `G:\My Drive\Personal\Employment\{company}\Offer Letter\` |
| Benefits | "benefits", "401k", "insurance summary" | `G:\My Drive\Personal\Employment\{company}\Benefits\` |
| TN visa | "tn", "visa", "i-94" | `G:\My Drive\Personal\Employment\{company}\TN Visa\` |
| Property | "deed", "mortgage", "closing", "hoa" | `G:\My Drive\Personal\Property\66 S 6th Street\` |
| Driver's license | "driver", "license", "dmv" | `G:\My Drive\Personal\ID\Drivers Liscence\` |
| SSN | "social security", "ssn" | `G:\My Drive\Personal\ID\SSN\` |
| Education | "transcript", "degree", "diploma", "i-20" | `G:\My Drive\Personal\Education\` |

**Naming convention:**
```
YYYY-MM-DD_{category}_{source}_{description}.ext
```

**Examples:**
- `2026-09-13_statement_chase-checking.xlsx` (Financial)
- `2026-04-17_labs_quest-mx_general.pdf` (Medical)
- `2025-W2_paychex.pdf` (Tax)
- `2026-05-14_offer-letter_ssc.pdf` (Employment)
- `2026-01-15_passport_canada.pdf` (ID)

**Environment variables:**
- None (uses direct file system access to G:\ drive)

**Dependencies:** (`docs/requirements.txt`)
```
PyPDF2>=3.0.0
python-docx>=0.8.0
```

**Manual execution:**
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

? unknown_document.pdf
  → vault/ops/incoming/unclassified/ (manual review required)

Processed: 3 filed, 1 unclassified
```

**Error handling:**
- **Ambiguous classification:** Multiple patterns match → Prompts user to select folder
- **No match:** Unknown document type → Moves to `vault/ops/incoming/unclassified/`
- **Duplicate filename:** Appends `_2`, `_3` to avoid overwrite
- **G: drive unmounted:** Error message, exits
- **File locked:** Skips file, logs error, continues

**Ambiguity example:**
```python
# File contains both "insurance" and "mortgage"
Detected patterns: ["insurance", "property"]

Prompt user:
  1. Insurance/
  2. Property/66 S 6th Street/
  Select target folder: _
```

---

## scan_expirations.py

**Purpose:** Scan all personal documents for expiration dates

**Location:** `docs/scan_expirations.py`

**Schedule:** Manual (on-demand)

**Launcher:** `docs/SCAN_EXPIRATIONS.bat` (double-click to run)

**What it does:**
1. Recursively scans `G:\My Drive\Personal\` for PDFs
2. Focuses on folders with expirable documents:
   - `ID/` (passports, visas, licenses)
   - `Insurance/` (policies)
   - `Employment/` (TN visas, I-94)
   - `Property/` (insurance, warranties)
3. Extracts text from PDFs using PyPDF2
4. Searches for expiration dates using regex patterns
5. Generates CSV tracker and HTML report

**Expiration patterns detected:**

| Document Type | Patterns Searched |
|---------------|-------------------|
| Passports | "Valid until", "Expiry date", "Fecha de vencimiento" |
| Visas | "Valid until", "Admit until", "I-94 expiration" |
| Driver's license | "Expires", "Valid through" |
| Insurance | "Policy period", "Expires", "Renewal date" |
| TN visa | "Valid until", "I-94 admit until" |

**Environment variables:**
- None (uses direct file system access)

**Dependencies:** (`docs/requirements.txt`)
```
PyPDF2>=3.0.0
pandas>=2.0.0
```

**Manual execution:**
```bash
cd docs
python scan_expirations.py
```

Or double-click: `docs\SCAN_EXPIRATIONS.bat`

**Output files:**

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

**Status indicators:**
- 🔴 Red: Expiring within 90 days
- 🟡 Yellow: Expiring within 1 year
- ✓ Green: Valid > 1 year

**Error handling:**
- **No expiration found:** Document listed as "No expiration detected"
- **Parse error:** Document skipped, logged
- **UTF-8 encoding issue:** Fixed (uses `encoding='utf-8'` for file writes)

---

## Batch Launchers

### PROCESS_INBOX.bat

**Purpose:** One-click launcher for inbox processing

**Location:** `docs/PROCESS_INBOX.bat`

**Contents:**
```batch
@echo off
cd /d "%~dp0"
python process_personal_inbox.py
pause
```

**Usage:** Double-click to run

---

### SCAN_EXPIRATIONS.bat

**Purpose:** One-click launcher for expiration scanning

**Location:** `docs/SCAN_EXPIRATIONS.bat`

**Contents:**
```batch
@echo off
cd /d "%~dp0"
python scan_expirations.py
pause
```

**Usage:** Double-click to run

---

## Common Dependencies

**Python 3.10+**

**PyPDF2** - PDF text extraction  
**python-docx** - DOCX file reading  
**pandas** - CSV generation  

**Installation:**
```bash
cd docs
pip install -r requirements.txt
```

---

## quarterly_vault_review.py

**Purpose:** Systematic quarterly audit and completion of vault outstanding items

**Location:** `docs/quarterly_vault_review.py`

**Schedule:** Quarterly (First week of Jan, Apr, Jul, Oct)

**Launcher:** Manual execution

**What it does:**
1. Reads all vault notes systematically
2. Identifies blanks, placeholders, "(Add if known)" text
3. Generates updated outstanding items list
4. Tracks completion metrics
5. Produces prioritized action list

**6-Day Process:**

**Step 1: Audit (Day 1)**
1. Read through all vault notes systematically
2. Mark any blanks, placeholders, or "(Add if known)" text
3. Add new outstanding items to `ops/outstanding/README.md`
4. Flag any outdated information

**Step 2: Research (Day 2-3)**
1. Gather missing information:
   - Check statements, documents in Google Drive
   - Contact family for missing info
   - Log into accounts to verify details
   - Research current benefit offerings

**Step 3: Update (Day 4-5)**
1. Fill in all gathered information
2. Update vault notes
3. Cross off completed items from `ops/outstanding/`
4. Commit changes to repo

**Step 4: Review (Day 6)**
1. Final read-through of updated notes
2. Verify accuracy
3. Note any items that remain outstanding (with reason)
4. Schedule follow-up for next quarter

**Prioritization:**

**High Priority (complete ASAP):**
- Emergency contacts (family phone numbers)
- Critical financial info (account numbers, card benefits)
- Health insurance details
- Key dates and expirations

**Medium Priority (next quarter):**
- Investment portfolio details
- Employment benefit summaries
- Digital life inventory
- Estate planning status

**Low Priority (as time permits):**
- Travel preferences
- Detailed historical context
- Nice-to-have metadata

**Research Sources:**

**Financial info:**
- Bank/credit card statements: `G:\My Drive\Personal\Finances\`
- Login to Chase.com for current benefits
- Login to Morgan Stanley for holdings
- Tax returns for historical data

**Family info:**
- Ask directly via WhatsApp/phone
- Emergency contact forms (if any)
- Old emails or texts

**Employment/benefits:**
- SS&C benefits portal (check email for link)
- Offer letter: `G:\My Drive\Personal\Employment\`
- Paystubs for current deductions

**Identity/visas:**
- Physical documents
- Scans: `G:\My Drive\Personal\ID\`
- USCIS online account
- Canadian immigration portal

**Insurance:**
- Policy docs: `G:\My Drive\Personal\Insurance\`
- Provider portals (login info in password manager)

**Notes Template:**

When completing items, use this template:

```markdown
## Notes

**Last verified:** YYYY-MM-DD

**Source:** [Where you got this info]

**Updates needed when:**
- [Trigger for re-verification, e.g., "Annually", "When policy renews", "After job change"]

**Related:**
- [[other-relevant-notes]]
```

**Manual execution:**
```bash
cd docs
python quarterly_vault_review.py
```

**Output:**
```
Vault Review - Q4 2026

Scanning vault notes...

Outstanding items found: 24
  High priority: 8
  Medium priority: 10
  Low priority: 6

Updated: ops/outstanding/README.md

Next actions:
  1. Research family contact info (Diego, Mariana)
  2. Login to Chase.com for card benefits
  3. Review employment benefits portal
```

**Error handling:**
- **Missing vault notes:** Logs warning, continues scan
- **Malformed YAML:** Reports file, skips
- **Git uncommitted changes:** Warns before writing outstanding list

**Dependencies:** (none - uses standard library only)

**Future enhancements:**
- Auto-detect placeholders via regex patterns
- Priority scoring based on staleness and category
- Email digest with action items
- Integration with calendar for quarterly reminders

---

## Development

**Adding new detection pattern:**

1. Edit `process_personal_inbox.py`
2. Add pattern to `DETECTION_PATTERNS` dict:
```python
DETECTION_PATTERNS = {
    "new_type": {
        "keywords": ["keyword1", "keyword2"],
        "target_folder": "G:\\My Drive\\Personal\\NewFolder\\"
    }
}
```
3. Test with sample file
4. Update this documentation

**Adding new expiration pattern:**

1. Edit `scan_expirations.py`
2. Add regex pattern to expiration search
3. Test with sample document
4. Update this documentation

---

## Troubleshooting

**Inbox processing fails:**
- Verify G:\ drive is mounted (Google Drive for Desktop)
- Check file is not locked by another program
- Review console output for specific error

**Classification is wrong:**
- Review detection patterns in script
- Consider adding more specific keywords
- Check if multiple patterns match (causes ambiguity prompt)

**Expiration scanner fails:**
- Verify PDFs are text-based (not scanned images)
- Check date format matches regex patterns
- Consider OCR for scanned documents (future enhancement)

**Encoding errors:**
- Fixed in current version (UTF-8 encoding)
- If persists, check Python locale settings

---

## Related Files

**Workflow documentation:** [[docs/docs-automation]]

**Google Drive structure:** See workflow doc for complete folder map

**No GitHub Actions:** All scripts manual execution only

**No Supabase:** Uses local file system and Google Drive only
