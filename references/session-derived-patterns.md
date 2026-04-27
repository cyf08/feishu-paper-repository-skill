# Session-Derived Patterns

These patterns are extracted from prior OpenClaw paper-search sessions. They describe reusable workflow behavior only; do not copy sensitive tokens, user IDs, device codes, or private URLs into outputs unless the current user provides them again.

## Assistant Identity

When the user calls the assistant "小查", operate as a paper research assistant:

- Search journal and conference papers.
- Download only authorized/open PDFs.
- Classify papers by research topic.
- Upload papers to Feishu Cloud Drive.
- Build a readable index and reading plan.

Ask for missing constraints only when needed:

- Research topic or keywords.
- Venue/journal preference.
- Time range.
- Target count.
- Target Feishu folder/wiki space.

## Feishu CLI Flow That Worked

The verified CLI is `lark-cli` from `@larksuite/cli`.

Working setup sequence:

```bash
npm install -g @larksuite/cli
npx -y skills add https://open.feishu.cn --skill -y
lark-cli config bind --identity user-default
lark-cli auth login --recommend --no-wait
lark-cli auth login --device-code <device_code>
lark-cli auth status
```

Important behavior:

- User mode is appropriate for personal Feishu Drive paper repositories.
- The user must open the verification URL in their own browser.
- `lark-cli auth status` must show user identity and valid or refreshable token.
- Proxy warnings are important because credentials may transit the configured proxy.

## Paper Search Flow That Worked

A successful run for "2024 年以来大模型可解释性相关的顶会和高分论文" used:

- Query variants: LLM interpretability/explainability, mechanistic interpretability, transformer explanation.
- API-first search.
- arXiv fallback after Semantic Scholar rate limiting.
- Query tightening after broad arXiv results returned unrelated papers.
- Local full candidate list before PDF selection.
- Top-paper selection by topic fit, recency, venue/citation signals where available, and survey/core-method value.

## Feishu Repository Output That Worked

The completed repository output included:

- A main `论文仓库` folder.
- A category folder such as `人工智能与机器学习`.
- Ten selected PDF files uploaded to the category folder.
- A Markdown index file named like `README_论文索引.md`.
- A Feishu Doc index created from Markdown and moved into the same folder.
- A final report containing search scope, platforms, query terms, candidate count, selected count, Feishu locations, and local cache paths.

## CLI Command Pitfalls

Use:

```bash
lark-cli drive +upload --file "<file>" --folder-token "<folder_token>"
lark-cli docs +create --title "<title>" --markdown "<markdown-file>"
lark-cli drive +move --file-token "<doc_token>" --type docx --folder-token "<folder_token>"
```

Avoid:

```bash
lark-cli drive files list --folder-token "<folder_token>"
```

That command rejected `--folder-token` in a prior run. Inspect `--help` before using lower-level CLI subcommands.
