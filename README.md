# Feishu Paper Repository Skill

OpenClaw skill for building and maintaining a Feishu/Lark Drive paper repository from academic search results.

It supports the "小查" paper research assistant workflow:

- Search journal, conference, and preprint papers.
- Normalize paper metadata from academic-search style workflows.
- Download only authorized/open-access PDFs.
- Upload PDFs, maintain one Feishu Doc index per category folder, and optionally maintain Bitable metadata.
- Check prerequisites for `lark-cli`, OpenClaw Lark plugin permissions, Feishu tool allowlists, and browser/Chrome configuration.

## Install

Copy or clone this directory into an OpenClaw workspace skills directory:

```bash
mkdir -p "$HOME/.openclaw/workspace/skills"
git clone https://github.com/cyf08/feishu-paper-repository-skill \
  "$HOME/.openclaw/workspace/skills/feishu-paper-repository"
```

If your active OpenClaw agent uses a custom workspace, clone it into that workspace's `skills/` directory instead.

## Validate

```bash
python "$(npm root -g)/openclaw/skills/skill-creator/scripts/quick_validate.py" \
  "$HOME/.openclaw/workspace/skills/feishu-paper-repository"

bash "$HOME/.openclaw/workspace/skills/feishu-paper-repository/scripts/check-prereqs.sh"
```

## Requirements

- OpenClaw
- Node.js 22+
- `lark-cli` from `@larksuite/cli`
- OpenClaw `openclaw-lark` plugin enabled
- Feishu channel credentials and write permissions
- Chrome/Chromium for browser-backed academic search fallbacks

See `references/prerequisites.md` for full setup details.

## Related Work

This skill builds on the search strategy patterns from
[`ustc-ai4science/academic-search`](https://github.com/ustc-ai4science/academic-search),
including API-first paper discovery, query expansion, lightweight first-pass
screening, multi-source metadata normalization, PDF discovery, and fallback
browser/CDP workflows for sources such as Google Scholar and CNKI.

`feishu-paper-repository` adds the Feishu/OpenClaw repository layer on top:
permission checks, `lark-cli` setup, Feishu Drive upload/move workflows,
single-index Doc maintenance, optional Bitable metadata, and paper-library
organization.
