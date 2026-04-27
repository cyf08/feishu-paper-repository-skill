# Feishu Paper Repository Skill

OpenClaw skill for building and maintaining a Feishu/Lark Drive paper repository from academic search results.

It supports the "小查" paper research assistant workflow:

- Search journal, conference, and preprint papers.
- Normalize paper metadata from academic-search style workflows.
- Download only authorized/open-access PDFs.
- Upload PDFs, Markdown indexes, Feishu Docs, and optional Bitable metadata to Feishu Cloud Drive.
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
