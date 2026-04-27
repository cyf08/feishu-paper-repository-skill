---
name: feishu-paper-repository
description: |
  Build and maintain a Feishu/Lark Drive paper repository from academic search results. Use when the user wants a paper research assistant such as "小查"; wants to collect, organize, archive, or curate papers in Feishu Cloud Drive, Feishu Docs, Wiki, or Bitable; create a paper reading library; save PDFs/metadata/BibTeX/notes to Feishu; or automate literature repository management. Includes prerequisite checks for Feishu permissions, lark-cli, OpenClaw Lark plugin, Feishu tool allowlist, browser/Chromium configuration, and academic-search integration.
metadata:
  source: "built from ustc-ai4science/academic-search patterns plus OpenClaw Feishu tools"
---

# Feishu Paper Repository

Use this skill to create and maintain a Feishu paper repository: a Drive/Wiki folder or space with one maintained Feishu Doc index per category folder, per-paper notes when requested, optional PDF/file uploads, and an optional Bitable metadata database.

If the user calls the assistant "小查", adopt that role as a paper research assistant: search papers, download only authorized PDFs, classify by topic, save to Feishu Cloud Drive, and maintain a readable index.

## Required First Step

Before creating or updating any repository, run the prerequisite checker:

```bash
SKILL_DIR="${OPENCLAW_WORKSPACE:-$HOME/.openclaw/workspace}/skills/feishu-paper-repository"
bash "$SKILL_DIR/scripts/check-prereqs.sh"
```

If it reports missing Feishu auth, browser, CLI, or tool allowlist problems, fix those first. Read [prerequisites.md](references/prerequisites.md) for remediation.

## Core Workflow

1. Clarify repository target:
   - New repository or update existing one?
   - Target location: `folder_token`, `wiki_node`, `wiki_space`, or personal root.
   - Scope: topic, paper list, author, venue, year range, DOI/arXiv IDs, or URLs.
   - Output depth: metadata only, notes, PDFs, BibTeX, tags, reading status.
2. Search and normalize papers:
   - If the `academic-search` skill is available and the task includes paper discovery, use it for search strategy, platform selection, PDF/BibTeX resolution, and metadata normalization.
   - Prefer API sources first: arXiv, Semantic Scholar, PubMed, Papers with Code.
   - Use browser/CDP only for Google Scholar, CNKI, login-gated pages, or API failures.
3. Create or update repository structure:
   - Create or update the category's single Feishu Doc index with repository purpose, scope, and paper table.
   - For each selected paper, create a per-paper note Doc using the paper template in [repository-workflow.md](references/repository-workflow.md).
   - When requested, create a Feishu Bitable app/table for sortable metadata.
   - Upload PDFs or source files only when public/open-access or explicitly provided/authorized by the user.
4. Record provenance:
   - Store source URL, DOI/arXiv/PMID/S2 ID, retrieval date, PDF source, BibTeX source, and confidence notes.
   - Mark missing or uncertain fields explicitly.

## Feishu Tool Mapping

Use existing Feishu skills/tool docs when needed:

- Create repository docs: `feishu-create-doc` / `feishu_create_doc`
- Append or update the category index Doc: `feishu-update-doc` / `feishu_update_doc`
- Upload/download PDFs/files: `feishu_drive_file`, `feishu_doc_media`
- Create/query metadata tables: `feishu-bitable` tools
- Locate existing docs/wiki nodes: `feishu_search_doc_wiki`, `feishu_wiki_space_node`, `feishu_wiki_space`

Never guess Feishu tokens. Extract `folder_token`, `wiki_node`, or `wiki_space` from URLs, or ask the user for the target location.

## Repository Defaults

Default structure:

```text
Paper Repository - <topic>
├── <Category>/          one folder per topic/category
│   ├── <Category>论文索引 Feishu Doc, maintained in place
│   └── PDFs/files       uploaded PDFs when authorized
└── Metadata             optional Feishu Bitable
```

Default fields are defined in [paper-schema.md](references/paper-schema.md). Use them consistently for Docs and Bitable records.

Do not upload Markdown index files by default. Generate temporary Markdown locally only as an intermediate format for creating/updating the Feishu Doc, then leave it local unless the user explicitly asks for a Markdown export.

## Safety Rules

- Do not bypass paywalls or use piracy mirrors.
- Do not upload licensed PDFs unless the user confirms they have the right to store/share them in Feishu.
- For private Feishu spaces, confirm who should have access before creating or sharing a repository.
- If Feishu tools return permission errors, stop and report the missing capability instead of retrying blindly.

## When More Detail Is Needed

- Prerequisite installation/configuration: [prerequisites.md](references/prerequisites.md)
- Feishu repository creation/update flow: [repository-workflow.md](references/repository-workflow.md)
- Paper metadata schema and Bitable fields: [paper-schema.md](references/paper-schema.md)
- Academic-search integration notes: [academic-search-integration.md](references/academic-search-integration.md)
- Patterns extracted from prior OpenClaw paper-search sessions: [session-derived-patterns.md](references/session-derived-patterns.md)
