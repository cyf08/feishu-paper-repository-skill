# Academic Search Integration

This skill is based on the workflow style of `ustc-ai4science/academic-search`.

Use the upstream `academic-search` skill when it is installed and the task includes discovery, filtering, citation analysis, PDF discovery, BibTeX export, Google Scholar, CNKI, or multi-platform metadata merging.

## Borrowed Operating Principles

- Define the success criteria before searching.
- Use API platforms first, browser automation only when needed.
- Run a lightweight first pass before deep metadata extraction.
- Expand queries into 2-3 complementary variants.
- Deduplicate across platforms by DOI/arXiv/PMID/S2 ID/title.
- Treat 429, empty results, and timeouts as routing signals, not reasons to retry the same path repeatedly.
- Convert all outputs into a normalized schema before writing to Feishu.

## Platform Choices

- arXiv: CS/math/physics/statistics preprints and direct PDFs.
- Semantic Scholar: citation counts, author profiles, DOI/arXiv lookup.
- PubMed: biomedical/life-science papers.
- Papers with Code: ML paper-to-code links.
- Google Scholar: broad citation counts, browser required.
- CNKI: Chinese literature, browser/login likely required.

## Repository-Specific Additions

After academic-search returns candidates:

1. Convert records to [paper-schema.md](paper-schema.md).
2. Ask the user to confirm the final set if the search produced more than the requested count.
3. Create/update Feishu repository artifacts.
4. Record provenance and source-specific confidence.
5. Store PDFs only when rights/permissions are clear.

## Prior Session Search Lessons

- Broad arXiv queries can return unrelated recent papers. If the first result page is off-topic, tighten the query immediately with phrases such as `"large language model" AND interpretability`, `"mechanistic interpretability"`, `"LLM explainability"`, and `"transformer explanation"`.
- Semantic Scholar may rate-limit without `S2_API_KEY`. Treat 429 as a route-change signal: reduce calls, use batch lookup where possible, or switch to arXiv/OpenAlex/PubMed depending on domain.
- For "top conference / high-score" requests, do not equate arXiv recency with quality. Use venue, citation count, author/institution signal, code availability, and survey status as ranking features, then state when venue metadata is missing.
- Save a full candidate list locally before selecting PDFs. A prior run created both a Markdown index and an online Feishu Doc, but the current repository policy is stricter: upload/maintain only the Feishu Doc index for the category unless the user explicitly requests a Markdown export.
