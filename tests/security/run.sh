#!/bin/bash
# Regression tests for the fixes in docs/spec_security-audit-fixes_20260930.md
# Runs offline in a throw-away directory; needs bash, git, python3, ssh-keygen.
set -u
repo=$(cd "$(dirname "$0")/../.." && pwd)
work=$(mktemp -d "${TMPDIR:-/tmp}/dotmatrix-sec.XXXXXX")
trap 'rm -rf "$work"' EXIT
fail=0
pass() { echo "ok   - $1"; }
flunk() { echo "FAIL - $1"; fail=1; }

# A repository with branch names that carry shell payloads
git init -q "$work/repo"
cd "$work/repo" || exit 1
git -c user.name=t -c user.email=t@t commit -q --allow-empty -m init
git branch 'x$(touch${IFS}PWNED_COMPGEN)'
git branch 'y;touch${IFS}PWNED_SED|e;#'
git branch main2

# 1. git-sh completion must not expand ref names
out=$(bash -c '
	eval "$(sed -n "/^__gitdir ()/,/^}/p;/^__gitcomp_1 ()/,/^}/p;/^__gitcomp ()/,/^}/p;/^__gitcomp_match ()/,/^}/p;/^__git_refs ()/,/^}/p" "$1/bin/git-sh")"
	COMP_WORDS=(git x); COMP_CWORD=1; __gitcomp "$(__git_refs)"; printf "%s\n" "${COMPREPLY[@]}"
	COMP_WORDS=(git ma); __gitcomp "$(__git_refs)"; printf "%s\n" "${COMPREPLY[@]}"
' _ "$repo")
[ ! -e PWNED_COMPGEN ] && pass "git-sh: ref name not executed" || flunk "git-sh: ref name executed"
case "$out" in *'x$(touch${IFS}PWNED_COMPGEN) '*main2*) pass "git-sh: completion still offers refs";;
*) flunk "git-sh: unexpected completion output: $out";; esac

# 2. git-ls-object-refs must not splice ref names into sed
sh "$repo/bin/git-ls-object-refs" "$(git rev-parse HEAD)" >/dev/null 2>&1
[ ! -e PWNED_SED ] && pass "git-ls-object-refs: ref name not executed" || flunk "git-ls-object-refs: ref name executed"

# 3. ssh.config only embeds well-formed public keys in add-bst scripts
eval "$(grep '^valid_pubkey_re=' "$repo/bin/ssh.config")"
ssh-keygen -q -t ed25519 -N '' -C 'user@host' -f "$work/k"
key=$(cut -d' ' -f1,2 "$work/k.pub")
check() { printf '%s\n' "$2" | grep -Eq "$valid_pubkey_re" && r=accept || r=reject
	[ "$r" = "$1" ] && pass "ssh.config: $1 $3" || flunk "ssh.config: expected $1 for $3"; }
check accept "$(cat "$work/k.pub")" "normal key"
check accept "$key" "key without comment"
check reject "$key x; touch /tmp/p" "comment with ;"
check reject "$key \$(id)" "comment with \$()"
check reject "$key it's" "comment with quote"

# 4. cve-monitor: pagination, per-window cache, escape stripping, fail loudly
if HOME="$work/home" python3 "$repo/tests/security/test_cve_monitor.py" "$repo/cve_monitor/cve-monitor" >/dev/null; then
	pass "cve-monitor"
else
	flunk "cve-monitor"
fi

# 5. static checks on configuration
grep -q '^host_key_checking *= *False' "$repo/.ansible.cfg" && flunk "ansible host key checking disabled" || pass "ansible host key checking on"
grep -q '^set modeline' "$repo/.vim/vimrc" && flunk "vim modeline enabled" || pass "vim modeline off"
grep -q '^set implicit_autoview' "$repo/.mutt/general" && flunk "mutt implicit_autoview on" || pass "mutt implicit_autoview off"
grep -q '^auto_view.*octet-stream' "$repo/.mutt/auto_views" && flunk "mutt autoviews octet-stream" || pass "mutt octet-stream not autoviewed"
grep -q "^set query_command.*'%s'" "$repo/.mutt/general" && flunk "mutt query_command double-quoted" || pass "mutt query_command quoting"
grep -q '^umask 077' "$repo/bin/backup-daily.sh" && pass "backup umask" || flunk "backup umask missing"
grep -q 'http://api.clickatell' "$repo/bin/sms" && flunk "sms uses http" || pass "sms uses https"

exit $fail
