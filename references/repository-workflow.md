# Repository Workflow

## 1. Plan

Capture:

- Repository title and topic.
- Target Feishu location: `folder_token`, `wiki_node`, `wiki_space`, or root.
- Paper source: search query, DOI/arXiv/PMID list, URLs, or existing bibliography.
- Required outputs: index only, per-paper notes, PDFs, BibTeX, Bitable.
- Access policy: private, shared folder, group, or wiki space.

If the user gives only a broad request such as "搜索 2024 年以来大模型可解释性相关的顶会和高分论文", infer an initial plan:

- Expand the query into 2-3 variants.
- Search first, then filter by venue, citation, recency, and topic fit.
- Save a full candidate list locally.
- Download only the selected/top papers.
- Upload PDFs and an index to the appropriate Feishu category folder.

Default category folders:

- AI/ML/LLM topics: `论文仓库/人工智能与机器学习/`
- Bioinformatics and computational biology: `论文仓库/生物信息学/`
- Medicine and clinical topics: `论文仓库/医学与临床/`
- Other topics: create a topic-specific subfolder after confirming name/access.

## 2. Create Index Document

Use `feishu_create_doc`.

Recommended title:

```text
Paper Repository - <topic>
```

Recommended index sections:

```markdown
<callout emoji="📚" background-color="light-blue">
Scope, date created, owner, and update policy.
</callout>

## Repository Summary

## Paper Table

| Status | Title | Year | Venue | Authors | Citation | PDF | Notes |
|---|---|---:|---|---|---:|---|---|

## Reading Plan

## Open Questions

## Change Log
```

Do not put the same H1 title in the Markdown body; Feishu Doc title is separate.

## 3. Create Per-Paper Notes

For each selected paper, create a Doc under the repository target when a folder/wiki target is available. Otherwise create under root and link from the index.

Per-paper note template:

```markdown
<callout emoji="🧾" background-color="light-yellow">
Source: <source platform>; retrieved: <YYYY-MM-DD>; confidence: <high/medium/low>
</callout>

## Metadata

| Field | Value |
|---|---|
| Title | |
| Authors | |
| Year | |
| Venue | |
| DOI | |
| arXiv | |
| PMID | |
| Semantic Scholar ID | |
| PDF | |
| Code | |
| BibTeX | |

## Abstract

## Why It Matters

## Methods

## Key Results

## Limitations

## Reading Notes

## Follow-up
```

## 4. Create Optional Bitable

Use `feishu_bitable_app` to create an app in the same folder when the user wants a sortable database. Create fields from [paper-schema.md](paper-schema.md).

Operational rules:

- Create fields first when requirements are clear.
- After app creation, list fields before writing records.
- Batch create records in chunks of at most 500.
- Write serially with a small delay to avoid `1254291` conflicts.
- If Bitable fails, preserve repository usability by updating the index Doc table.

## 5. PDF and File Handling

Allowed:

- Open-access PDF from arXiv, PubMed Central, publisher OA link, or author-provided link.
- User-provided PDF when the user confirms it may be stored.

Not allowed:

- Paywall bypass.
- Sci-Hub or piracy mirrors.
- Uploading copyrighted PDFs to shared Feishu locations without user confirmation.

Prefer storing PDF URLs in metadata. Upload files only when requested or needed for repository completeness.

When using `lark-cli`, prefer the high-level Drive commands that accept folder tokens directly:

```bash
lark-cli drive +upload --file "<local-file>" --folder-token "<folder_token>"
lark-cli drive +move --file-token "<doc_or_file_token>" --type docx --folder-token "<folder_token>"
```

Do not use `lark-cli drive files list --folder-token`; prior sessions showed this command rejects `--folder-token`. Use `lark-cli drive +move --help`, `lark-cli drive +upload --help`, or OpenClaw `feishu_drive_file` metadata/list actions to discover the correct command shape.

## 6. Update Existing Repository

When updating:

1. Fetch the index Doc or Bitable records.
2. Normalize new candidate papers.
3. Deduplicate by DOI, arXiv ID, PMID, Semantic Scholar ID, then normalized title.
4. Append only new papers.
5. Add a change log entry with date, query/source, and count added/skipped.

## 7. Final Report

Return:

- Repository index URL.
- Bitable URL/token if created.
- Number of papers added, skipped duplicates, and failed imports.
- Permission or PDF limitations.
- Suggested next maintenance action.

For paper-search repository tasks, include:

- Search scope and platforms.
- Query variants used.
- Total candidates found and selected papers uploaded.
- Feishu folder/doc URLs.
- Local cache paths if temporary PDFs or metadata were produced.
