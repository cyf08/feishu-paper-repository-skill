#!/usr/bin/env bash
set -u

CONFIG="${OPENCLAW_CONFIG_PATH:-$HOME/.openclaw/openclaw.json}"
STATUS=0

ok() { printf 'ok: %s\n' "$*"; }
warn() { printf 'warn: %s\n' "$*"; }
fail() { printf 'missing: %s\n' "$*"; STATUS=1; }

has_cmd() { command -v "$1" >/dev/null 2>&1; }

echo "== Feishu paper repository prerequisite check =="

if has_cmd openclaw; then
  ok "openclaw: $(openclaw --version 2>/dev/null | head -n1)"
else
  fail "openclaw CLI. Install with: npm install -g openclaw"
fi

if has_cmd node; then
  NODE_VERSION="$(node --version 2>/dev/null)"
  NODE_MAJOR="$(printf '%s' "$NODE_VERSION" | sed 's/^v//' | cut -d. -f1)"
  if [ "${NODE_MAJOR:-0}" -ge 22 ] 2>/dev/null; then
    ok "node: $NODE_VERSION"
  else
    fail "Node.js >=22 required; found ${NODE_VERSION:-unknown}"
  fi
else
  fail "node >=22"
fi

if has_cmd npm; then ok "npm: $(npm --version 2>/dev/null)"; else fail "npm"; fi
if has_cmd curl; then ok "curl"; else fail "curl"; fi

if has_cmd lark-cli; then
  ok "lark-cli: $(lark-cli --version 2>/dev/null | head -n1)"
else
  warn "lark-cli not on PATH. Install with: npm install -g @larksuite/cli"
fi

BROWSER_PATH=""
for p in "${CHROME_PATH:-}" /usr/bin/google-chrome /usr/bin/google-chrome-stable /usr/bin/chromium /usr/bin/chromium-browser /snap/bin/chromium /opt/google/chrome/chrome; do
  [ -n "$p" ] && [ -x "$p" ] && BROWSER_PATH="$p" && break
done
if [ -n "$BROWSER_PATH" ]; then
  ok "browser executable: $BROWSER_PATH"
else
  fail "Chromium/Chrome executable. Install chromium or google-chrome."
fi

if [ ! -f "$CONFIG" ]; then
  fail "OpenClaw config not found: $CONFIG"
  exit "$STATUS"
fi
ok "config: $CONFIG"

node - "$CONFIG" <<'NODE'
const fs = require('fs');
const cfgPath = process.argv[2];
const cfg = JSON.parse(fs.readFileSync(cfgPath, 'utf8'));
let status = 0;
const ok = (m) => console.log(`ok: ${m}`);
const warn = (m) => console.log(`warn: ${m}`);
const fail = (m) => { console.log(`missing: ${m}`); status = 1; };
const get = (path) => path.split('.').reduce((o, k) => o && o[k], cfg);
const arr = (v) => Array.isArray(v) ? v : [];

if (arr(get('plugins.allow')).includes('openclaw-lark')) ok('plugins.allow includes openclaw-lark');
else fail('plugins.allow should include "openclaw-lark"');

if (arr(get('plugins.allow')).includes('browser')) ok('plugins.allow includes browser');
else warn('plugins.allow does not include "browser"; browser automation may be unavailable');

if (get('plugins.entries.openclaw-lark.enabled') === true) ok('openclaw-lark plugin enabled');
else fail('plugins.entries.openclaw-lark.enabled should be true');

if (get('plugins.entries.browser.enabled') === true || get('browser.enabled') === true) ok('browser enabled in config');
else warn('browser.enabled or plugins.entries.browser.enabled is not true');

if (get('channels.feishu.enabled') === true) ok('Feishu channel enabled');
else fail('channels.feishu.enabled should be true');

const secretPath = get('secrets.providers.lark-secrets.path');
if (secretPath) ok(`lark secret provider configured: ${secretPath}`);
else warn('lark secret provider path missing');

const tools = arr(get('tools.alsoAllow'));
const requiredTools = [
  'feishu_create_doc',
  'feishu_update_doc',
  'feishu_fetch_doc',
  'feishu_drive_file',
  'feishu_doc_media',
  'feishu_search_doc_wiki',
  'feishu_wiki_space',
  'feishu_wiki_space_node',
  'feishu_bitable_app',
  'feishu_bitable_app_table',
  'feishu_bitable_app_table_field',
  'feishu_bitable_app_table_record',
  'feishu_bitable_app_table_view',
];
const missingTools = requiredTools.filter((t) => !tools.includes(t));
if (missingTools.length === 0) ok('Feishu repository tools are in tools.alsoAllow');
else fail(`tools.alsoAllow missing: ${missingTools.join(', ')}`);

const browserPath = get('browser.executablePath');
if (browserPath) ok(`browser.executablePath configured: ${browserPath}`);
else warn('browser.executablePath missing; set it to google-chrome/chromium path for deterministic browser automation');

process.exit(status);
NODE
NODE_STATUS=$?
[ "$NODE_STATUS" -ne 0 ] && STATUS=1

if has_cmd openclaw; then
  if openclaw config validate >/tmp/feishu-paper-repo-config-validate.log 2>&1; then
    ok "openclaw config validate"
  else
    fail "openclaw config validate failed; see /tmp/feishu-paper-repo-config-validate.log"
  fi

  if openclaw plugins list 2>/dev/null | grep -E 'browser.+loaded|browser  .*loaded' >/dev/null; then
    ok "browser plugin loaded"
  else
    warn "browser plugin not reported as loaded; restart gateway or run openclaw plugins list to inspect"
  fi

  if openclaw skills info feishu-create-doc >/tmp/feishu-paper-repo-skill-check.log 2>&1; then
    ok "feishu-create-doc skill visible"
  else
    fail "feishu-create-doc skill not visible; see /tmp/feishu-paper-repo-skill-check.log"
  fi
fi

if [ -n "${S2_API_KEY:-}" ]; then ok "S2_API_KEY set"; else warn "S2_API_KEY not set; Semantic Scholar rate limits may be low"; fi

if [ "$STATUS" -eq 0 ]; then
  echo "== prerequisite check passed =="
else
  echo "== prerequisite check found blockers =="
fi
exit "$STATUS"
