---
tags: [ops, operations, admin, workflow]
---

# Ops

Operational folders for vault workflows: incoming files, generated outputs, and outstanding action items.

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                          VAULT OPS FLOW                              │
└─────────────────────────────────────────────────────────────────────┘

┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   INCOMING   │         │   OUTGOING   │         │ OUTSTANDING  │
│              │         │              │         │              │
│  Drop Zone   │         │   Reports    │         │ Action Items │
└──────────────┘         └──────────────┘         └──────────────┘
       │                        ▲                        │
       │ Files dropped          │ Scripts generate       │ Quarterly
       │ by you                 │ automatically          │ audit finds
       ▼                        │                        ▼
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   CLASSIFY   │         │    CREATE    │         │   RESEARCH   │
│              │         │              │         │              │
│ Pattern      │         │ Generated    │         │ Gather       │
│ matching,    │         │ reports,     │         │ missing      │
│ extract      │         │ processing   │         │ info from    │
│ dates,       │         │ logs,        │         │ statements,  │
│ rename       │         │ travel       │         │ accounts,    │
│              │         │ docs         │         │ family       │
└──────────────┘         └──────────────┘         └──────────────┘
       │                        │                        │
       │ Move to                │ Review &               │ Update
       │ Google Drive           │ archive                │ vault notes
       ▼                        ▼                        ▼
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│ GOOGLE DRIVE │         │ GOOGLE DRIVE │         │    VAULT     │
│              │         │              │         │              │
│ Medical/     │         │ Dashboards/  │         │ Complete     │
│ Finances/    │         │ Reports/     │         │ all fields,  │
│ Tax/         │         │ Archives     │         │ cross off    │
│ ID/          │         │              │         │ items        │
│ Employment   │         │              │         │              │
└──────────────┘         └──────────────┘         └──────────────┘
       │                        │                        │
       │ Vault notes            │ Share with             │ Commit to
       │ updated                │ providers              │ repo
       ▼                        ▼                        ▼
┌──────────────────────────────────────────────────────────────────┐
│                    COMPLETE & VERSIONED                           │
└──────────────────────────────────────────────────────────────────┘
```

**Flow summary:**

- **incoming/** → Scripts classify & move → Google Drive + vault notes updated
- **outgoing/** → Scripts generate → Review & archive → Share with providers
- **outstanding/** → Quarterly audit → Research & update → Complete vault entries

---

## Folders

### [[incoming/]]
Drop zone for all incoming documents and files to be processed, sorted, and filed.

**Purpose:** Central inbox for documents before automation classifies, renames, and moves them to Google Drive.

**Contents:** Lab PDFs, bill statements, tax docs, ID scans, employment papers, insurance docs.

---

### [[outgoing/]]
Generated reports, logs, and documents produced by automation workflows or Claude.

**Purpose:** Machine-generated outputs ready for review, archival, or sharing.

**Contents:** Document processing logs, expiration reports, trip planning documents, any generated visualizations or reports.

---

### [[outstanding/]]
Action items and incomplete vault entries to be filled in during quarterly reviews.

**Purpose:** Tracks all missing information, blanks to fill, research needed, or pending decisions.

**Contents:** Quarterly review checklist, completion tracking.

---

## Workflow

**Incoming →** Files dropped here → Scripts classify & move to Google Drive → Vault notes updated

**Outgoing →** Scripts/Claude generate outputs here → Review & archive to Google Drive → Share with family/providers

**Outstanding →** Quarterly audit identifies gaps → Research & update vault notes → Cross off completed items

---

## Related

- [[workflows/README]] - full workflow status dashboard
- [[workflows/docs/docs-automation]] - document processing workflow
- [[workflows/travel/travel-automation]] - trip planning workflow
- [[ops/outgoing/README]] - output folder documentation
- [[ops/outstanding/README]] - action items tracker
