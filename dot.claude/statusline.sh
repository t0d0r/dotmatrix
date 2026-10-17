#!/bin/sh
# Claude Code status line: model | effort | account | context usage | session cost | dir | git branch.
# Reads the statusline JSON on stdin. Fail-safe: never errors out.
# ANSI colors; set NO_COLOR=1 to disable.

input=$(cat 2>/dev/null)

if ! command -v jq >/dev/null 2>&1; then
  echo "statusline: jq missing"
  exit 0
fi

if [ -n "$NO_COLOR" ]; then
  RST= DIM= CYN= GRN= YEL= RED= MAG= BLU= BLD=
else
  e=$(printf '\033')
  RST="${e}[0m" DIM="${e}[2m" CYN="${e}[36m" GRN="${e}[32m"
  YEL="${e}[33m" RED="${e}[31m" MAG="${e}[35m" BLU="${e}[34m" BLD="${e}[1m"
fi

# One jq call; @sh quotes every value so eval is safe.
vars=$(printf '%s' "$input" | jq -r '
  def human: if . == null then "?"
    elif . >= 1000000 then ((. / 100000 | floor) / 10 | tostring) + "M"
    elif . >= 1000 then ((. / 100 | floor) / 10 | tostring) + "k"
    else tostring end;
  def money: . * 100 | round / 100 | tostring
    | if test("\\.") then . else . + ".0" end
    | if test("\\.[0-9]$") then . + "0" else . end;
  (.context_window.total_input_tokens) as $in
  | (.context_window.total_output_tokens) as $o
  | (.context_window.context_window_size) as $size
  | (.context_window.used_percentage) as $pct
  | "model=" + ((.model.display_name // .model.id // "unknown model") | @sh),
    "effort=" + ((.effort.level // "") | @sh),
    "ctx=" + ((if $pct != null and $size != null and $in != null then
        "ctx " + ($in | human) + "/" + ($size | human)
          + " (" + ($pct | floor | tostring) + "%)"
      elif $in != null or $o != null then
        "in " + ($in | human) + " out " + ($o | human)
      else "ctx n/a" end) | @sh),
    "pct=" + (($pct // "" | if . == "" then "" else floor | tostring end) | @sh),
    "cost=" + ((.cost.total_cost_usd // null | if . == null then "" else money end) | @sh),
    "dir=" + ((.workspace.current_dir // .cwd // "") | @sh),
    "tp=" + ((.transcript_path // "") | @sh)
' 2>/dev/null)

if [ -z "$vars" ]; then
  echo "Claude"
  exit 0
fi
eval "$vars"

# Context color by fill: green < 50 %, yellow < 80 %, red >= 80 %.
ctxc=$DIM
if [ -n "$pct" ]; then
  if [ "$pct" -ge 80 ]; then ctxc=$RED
  elif [ "$pct" -ge 50 ]; then ctxc=$YEL
  else ctxc=$GRN; fi
fi

# Account: org name, or display name for a personal org. Config dir comes
# from CLAUDE_CONFIG_DIR, else from the transcript path (<cfg>/projects/...),
# so one script serves ~/.claude and ~/.claude-bst alike.
cfg=${CLAUDE_CONFIG_DIR:-}
if [ -z "$cfg" ]; then
  case $tp in */projects/*) cfg=${tp%%/projects/*} ;; esac
fi
acct_json="$HOME/.claude.json"
[ -n "$cfg" ] && [ -f "$cfg/.claude.json" ] && acct_json="$cfg/.claude.json"
acct=$(jq -r '.oauthAccount // empty
  | (.organizationName // "") as $o
  | if $o == "" or ($o | endswith("'"'"'s Organization")) then
      .displayName // .emailAddress // empty
    else $o end' "$acct_json" 2>/dev/null)

sep="${DIM} | ${RST}"
out="${CYN}${model}${RST}"
[ -n "$effort" ] && out="${out}${sep}${DIM}${effort}${RST}"
[ -n "$acct" ] && out="${out}${sep}${BLD}${acct}${RST}"
out="${out}${sep}${ctxc}${ctx}${RST}"
[ -n "$cost" ] && out="${out}${sep}${YEL}\$${cost}${RST}"

# Working dir, last two components only ($HOME shown as ~).
if [ -n "$dir" ]; then
  p=${dir%/}
  if [ "$p" = "$HOME" ]; then
    pwd_s="~"
  else
    last=${p##*/}
    parent=${p%/*}; parent=${parent##*/}
    if [ -n "$parent" ]; then pwd_s="$parent/$last"; else pwd_s="/$last"; fi
  fi
  out="${out}${sep}${BLU}${pwd_s}${RST}"
fi

# Git branch of the session's working dir (local read, no fetch, no locks).
if [ -n "$dir" ] && command -v git >/dev/null 2>&1; then
  branch=$(git --no-optional-locks -C "$dir" branch --show-current 2>/dev/null)
  [ -z "$branch" ] && branch=$(git --no-optional-locks -C "$dir" rev-parse --short HEAD 2>/dev/null)
  [ -n "$branch" ] && out="${out}${sep}${MAG}${branch}${RST}"
fi

printf '%s\n' "$out"
