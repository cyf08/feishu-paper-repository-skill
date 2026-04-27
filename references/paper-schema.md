# Paper Schema

Use these fields consistently in Feishu Docs and Bitable.

## Canonical Metadata

| Field | Type | Notes |
|---|---|---|
| title | text | Required |
| authors | text/list | Preserve order |
| year | number | Publication year |
| venue | text | Conference/journal/preprint server |
| venue_rank | text | CCF/JCR/etc. if available |
| citation_count | number | Include source and retrieval date |
| doi | text | Normalize case and prefix |
| arxiv_id | text | Version optional; canonical ID preferred |
| pmid | text | PubMed ID |
| semantic_scholar_id | text | S2 paperId |
| url | url | Primary landing page |
| pdf_url | url | Open-access PDF or user-provided file |
| code_url | url | Papers with Code/GitHub/etc. |
| abstract | text | Optional in index, recommended in paper note |
| bibtex | text | Store raw BibTeX in paper note or long text field |
| keywords | multi_select/text | User/topic tags |
| status | single_select | `To read`, `Reading`, `Read`, `Skimmed`, `Archived` |
| priority | single_select | `High`, `Medium`, `Low` |
| repository_note_url | url | Feishu per-paper note |
| local_file_or_feishu_file | url/text | Uploaded file link/token if any |
| source | text | arXiv/S2/PubMed/CNKI/manual/etc. |
| retrieved_at | date/text | ISO date |
| confidence | single_select | `High`, `Medium`, `Low` |
| notes | text | Freeform curator notes |

## Bitable Field Suggestions

Minimum fields:

- `Status`: SingleSelect
- `Priority`: SingleSelect
- `Title`: Text
- `Authors`: Text
- `Year`: Number
- `Venue`: Text
- `Citation Count`: Number
- `DOI`: Text
- `arXiv ID`: Text
- `URL`: Url
- `PDF`: Url
- `Code`: Url
- `Note`: Url
- `Tags`: MultiSelect
- `Retrieved At`: DateTime

Date values in Feishu Bitable must be millisecond timestamps. URL values should use:

```json
{ "text": "PDF", "link": "https://..." }
```

## Deduplication

Deduplicate in this order:

1. DOI exact match after normalization.
2. arXiv ID without version.
3. PMID.
4. Semantic Scholar paperId.
5. Lowercased title with punctuation and repeated spaces removed.

When fields conflict, preserve both source values in notes and prefer DOI/arXiv/PubMed official metadata over scraped page metadata.
