# Prerequisites

Run:

```bash
bash skills/feishu-paper-repository/scripts/check-prereqs.sh
```

## Required Local Tools

- `openclaw`: required.
- Node.js `>=22`: required by OpenClaw and OpenClaw Lark/Feishu tooling.
- `curl`: required for academic APIs.
- `npm`: required if Feishu CLI or browser helpers need installation.
- `lark-cli`: required for the Feishu CLI workflow used in prior OpenClaw sessions.
- A Chromium-family browser: `google-chrome`, `chromium`, or `chromium-browser`.

Install examples:

```bash
npm install -g openclaw @larksuite/cli
sudo apt-get install -y curl chromium-browser
```

`@larksuite/openclaw-lark` is the OpenClaw plugin, not the CLI. The CLI executable should be `lark-cli`.

If Chrome is installed instead of Chromium, configure OpenClaw with its path:

```bash
openclaw config set browser.enabled true
openclaw config set browser.executablePath /usr/bin/google-chrome
openclaw plugins enable browser
```

## OpenClaw Config Requirements

The OpenClaw config should have:

```json
{
  "plugins": {
    "allow": ["openclaw-lark", "browser", "openai", "memory-core"],
    "entries": {
      "openclaw-lark": { "enabled": true },
      "browser": { "enabled": true }
    }
  },
  "browser": {
    "enabled": true,
    "executablePath": "/usr/bin/google-chrome"
  },
  "channels": {
    "feishu": { "enabled": true }
  }
}
```

Required Feishu tool allowlist entries:

- `feishu_create_doc`
- `feishu_update_doc`
- `feishu_fetch_doc`
- `feishu_drive_file`
- `feishu_doc_media`
- `feishu_search_doc_wiki`
- `feishu_wiki_space`
- `feishu_wiki_space_node`
- `feishu_bitable_app`
- `feishu_bitable_app_table`
- `feishu_bitable_app_table_field`
- `feishu_bitable_app_table_record`
- `feishu_bitable_app_table_view`

## Feishu Permission Checks

Before repository creation, verify:

- Feishu channel is enabled.
- App secret provider path exists.
- User authorization is complete for the account that will create/update docs.
- The target folder/wiki space is writable by the authorized user or app.
- Bitable permissions are available if metadata tables are requested.
- Drive file upload permissions are available if PDFs/files will be uploaded.

Typical failure handling:

- Missing auth: run Feishu OAuth/onboarding for OpenClaw Lark.
- Permission denied on target folder/wiki: ask user for a different target or admin grant.
- Upload denied: create metadata-only repository and record PDF URLs instead.
- Bitable creation denied: fall back to index Doc table.

## Feishu CLI Setup

Use this when the user explicitly wants CLI-backed Feishu operations or when OpenClaw Feishu tools are unavailable.

1. Install the CLI and official Feishu skills:

```bash
npm install -g @larksuite/cli
npx -y skills add https://open.feishu.cn --skill -y
```

2. Bind to OpenClaw credentials. Prefer `user-default` for personal Drive paper repositories; use `bot-only` only when the repository is owned by a bot/shared app.

```bash
lark-cli config bind --identity user-default
```

If multiple apps are configured, do not choose blindly. Show the app list from the CLI error and ask the user which app to bind.

3. Login for user mode. Start login, send the verification URL to the user, then wait for user confirmation before completing the device-code step.

```bash
lark-cli auth login --recommend --no-wait
lark-cli auth login --device-code <device_code>
```

Never open the authorization URL yourself; the user must authorize in their own browser.

4. Verify:

```bash
lark-cli auth status
```

For user mode, require `identity == "user"` and `tokenStatus` of `valid` or `needs_refresh`.

CLI security notes:

- If the CLI warns that `https_proxy` is set, tell the user credentials may transit the proxy. They can set `LARK_CLI_NO_PROXY=1` to disable proxy usage for the CLI.
- Do not store tokens, device codes, verification URLs, app secrets, or user IDs in skill files.
- If `bot-only` hits permission errors, stop and show the error. Switch to `user-default` only after explicit user confirmation.

## Browser/CDP Checks

Academic APIs do not require browser automation. Browser/CDP is required for:

- Google Scholar
- CNKI
- login-gated pages
- pages where API/static fetch fails

For OpenClaw browser tools, `browser.enabled` and `browser.executablePath` must be set and the `browser` plugin loaded.

For the upstream `academic-search` CDP proxy workflow, Chrome remote debugging may also be needed. Prefer OpenClaw browser tools when available; use upstream CDP proxy only if a task specifically requires it.

## Optional Academic API Keys

Semantic Scholar works without a key but rate limits quickly. If the user has one, use it through environment variable or request header:

```bash
export S2_API_KEY="..."
```

Never store API keys in skill files.
