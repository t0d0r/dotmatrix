# Security audit fixes — dotmatrix

- **Date:** 2026-09-30
- **Branch:** `fix/security-audit`
- **Regression tests:** `tests/security/run.sh` (offline, 17 checks)

## Context

The repository was given a full security audit: every tracked file (except the
vim colour schemes and the `.hg` binary stores) plus the complete git history
(356 commits). This dotfiles repo is public on GitHub, so everything in it,
including its history, should be treated as readable by anyone.

The audit found attacker-controlled input reaching tracked code through these
paths:

- remote git repositories (branch and file names);
- incoming email (mutt);
- the NVD CVE feed;
- the network path (plain HTTP, SSH host keys);
- the separately managed `~/.ssh` repository (`.pub` files, customer ssh configs);
- the public git history itself.

This branch fixes everything that can be fixed in code. Anything that needs
the owner to act, such as rotating credentials or rewriting history, is listed
under [Manual actions](#manual-actions-required). Secret values are never
reproduced in this document.

## Summary

| # | Severity | Finding | Status |
|---|----------|---------|--------|
| 1 | High | Credentials in public git history (`.netrc` 2014, `blog.vim` 2012–2015) | Rotated long ago (confirmed by owner); optional history purge |
| 2 | Medium | `git sh` tab completion executes `$(…)` in fetched ref/file names | Fixed + test |
| 3 | Medium | Hardcoded iodine password, passed via argv (`bin/ioclient`) | Script removed; password already rotated |
| 4 | Medium | Unvalidated `.pub` content embedded in generated root script (`bin/ssh.config`) | Fixed + test |
| 5 | Medium | SMS API credentials over plain HTTP and in argv (`bin/sms`) | Fixed + test |
| 6 | Medium | Ansible `host_key_checking = False` | Fixed + test |
| 7 | Medium (cond.) | Root backup archive world-readable (`bin/backup-daily.sh`) | Fixed + test |
| 8 | Medium (cond.) | mutt auto-runs many parsers on attachments when a message is opened | Fixed + test |
| 9 | Low | Ref name spliced into sed script (`bin/git-ls-object-refs`) | Fixed + test |
| 10 | Low | `git-prune-merged-branches -r X` deletes on `origin` | Fixed |
| 11 | Low | `eval` of git alias values incl. repo-local config (`bin/git-sh`) | Fixed |
| 12 | Low | vim `set modeline` | Fixed + test |
| 13 | Low | `.hgrc` trusts numeric uid 2000 | Fixed |
| 14 | Low | `.screenrc` spawns persistent root shell | Fixed |
| 15 | Low | cve-monitor fails open / truncates / stale cache / prints raw escapes / key in argv | Fixed + test |
| 16 | Low | mutt `query_command` double quoting | Fixed + test |
| 17 | Low | `git://` / `http://` fetches, `curl \| sh` in README | Fixed |
| 18 | Low | `terraform.docker` mounts `~/.ssh` read-write | Fixed (ro) |
| 19 | Low | `borg.REDACTED` continues after failed rsync; passphrase in env | Fixed |
| 20 | Low | Predictable `/tmp` log (`bin/checkup.sh`), `ssh $@` unquoted (`bin/ssh-retry`) | Fixed; `checkup.sh` later removed |
| 21 | Low | `bin/timehack`, `bin/cht.sh`, `bin/vimr`, `.mutt/offlineimap.py` | Removed |
| — | Low/Info | Items deliberately left unchanged | See [Not changed](#not-changed-deliberately) |

## Fixes in detail

### 1. Credentials in git history (manual)

**Root cause.** Several credential files were committed before `.gitignore`
excluded them. Deleting a file later does not remove it from history.

- `.netrc`, added in `f48a62d` and deleted in `87608cb` (2014-08-04), held:
  - a Google account password (two successive values);
  - Heroku API credentials.
- `.janus/blog/plugin/blog.vim`, present from `6f7c50a` to `aa2052f`, held a
  WordPress XML-RPC password, which the plugin also sent over `http://`.

**Fix.** This cannot be fixed in code. The owner confirmed (2026-09-30) that all of these credentials were rotated long ago, so they are no longer usable. Purging them from history is optional.

### 2. `git sh` completion code execution — `bin/git-sh`

**Root cause.** `__gitcomp` and `__git_complete_file` passed ref names and
`git ls-tree` output to `compgen -W`, which expands `$(…)` and `${…}` in its
word list. Git accepts names like `x$(cmd${IFS}…)` as valid ref names.

**Attack.** Someone pushes such a branch to a repo you fetch. In `git sh`,
typing `c <TAB>` then runs their command as you. A committed file named
`$(cmd)` does the same on `git show HEAD:<TAB>`.

**Change.**
- A new helper, `__gitcomp_match prefix cur words`, fills `COMPREPLY` by
  literal prefix matching: `case "$w" in "$cur"*)`.
- Both former `compgen -W` call sites now use it. `compgen -W` is no longer
  used anywhere.

**Test.** `run.sh` creates the branch `x$(touch${IFS}PWNED_COMPGEN)`, runs the
completion functions, and checks two things:
- the marker file does not exist;
- the completion still offers the refs.

### 3. Hardcoded iodine password — `bin/ioclient`

**Root cause.**
- `IOPASS` was a literal value in a public repo.
- It was passed as `iodine -P <password>`, so it was visible in `ps`.
- The unquoted `[ -n $IOPASS ]` was always true.

**Change.**
- The literal is removed. iodine now reads `IODINE_PASS` from the environment,
  or prompts for the password when it is unset.
- Arguments are quoted.
- `kill -9 $(ps|grep iodine)` is replaced with `pkill -x iodine`.

**Usage note.** The script runs as root. `sudo` drops the environment by
default, so use `sudo -E` or `sudo --preserve-env=IODINE_PASS`.

**Update.** `bin/ioclient` was later moved to the encrypted private overlay on `master`, and then removed entirely, along with its entries in `.private-manifest`. Its test check was dropped. The old password in history had already been rotated.

### 4. Root bootstrap script injection — `bin/ssh.config` (also `bin/newssh`)

**Root cause.** `echo "echo $(cat key.pub) > ~bst/.ssh/authorized_keys"`
pasted raw key-file content into `add-bst/<dir>.sh`. That script creates a
`NOPASSWD: ALL` user and is published for execution as root. A key comment
containing `;` or `$(…)` would therefore run as root on the target host.

**Change.**
- `valid_pubkey_re` accepts only `<openssh-type> <base64> [comment]`, and the
  comment may contain only `[A-Za-z0-9@._+:=, -]`.
- Only the first line of each `.pub` file is used. Keys that don't match are
  skipped with a warning, so they are neither published nor embedded.
- The key is emitted inside single quotes. The regex guarantees it contains
  no `'`.
- `find "${base_path:?}/" -type l -delete` guards against an empty path.
- After the customer ssh configs are merged, the generated config is grepped
  for `ProxyCommand`, `LocalCommand`, `PermitLocalCommand yes`, `Match … exec`
  and `ForwardAgent yes`. Matching lines are printed as a warning so pulled
  changes get reviewed; they are not blocked.

**Test.** Real `ssh-keygen` keys, with and without a comment, are accepted.
Comments containing `; touch`, `$(id)` or `it's` are rejected.

### 5. SMS credentials in cleartext — `bin/sms`

**Root cause.** `curl -G http://api.clickatell.com/...` sent the user,
password and api_id in cleartext, in the URL. They also appeared in curl's
argv.

**Change.**
- HTTPS only (`--proto '=https'`).
- All parameters are passed through a curl config on stdin (`-K -`), with
  config-syntax escaping of `\` and `"`.
- Newlines in the message are flattened.
- `--fail --show-error` makes errors visible.

**Verification.** Against a local listener, a password containing `"`, `\`
and a space, and a message containing `$(id)`, arrived correctly URL-encoded.

**Test.** A static check that there is no `http://api.clickatell` URL.

### 6. Ansible host key checking — `.ansible.cfg`

**Change.**
- `host_key_checking = False` is removed; the default is True.
- `ssh_args` gains `-o StrictHostKeyChecking=accept-new`: new hosts are
  trusted on first use, and changed keys are refused.

**Test.** Static check.

### 7. World-readable backups — `bin/backup-daily.sh`

**Change.**
- `umask 077` before `tar`, so the archive of `/etc`, `/root` and `/home` is
  mode 0600.
- Destination paths are quoted.

**Test.** Static check.

### 8. Attachment parsers run on message open — `.mutt/general`, `.mutt/auto_views`

**Root cause.** `implicit_autoview` plus `auto_view` for Office formats and
`application/octet-stream` meant that opening a message ran word2text,
excel2text, ppt2text and `mutt.octet.filter` on attacker files.
`mutt.octet.filter` in turn dispatches to latex2html, unrar, unarj, rpm, dpkg
and others, chosen by the sender's filename.

**Change.**
- `unset implicit_autoview`.
- `auto_view` is limited to `text/html`, `application/x-pgp-message`,
  `image/*` and `application/pdf`.
- Other types can still be viewed on demand from the attachment menu; the
  mailcap is unchanged.

**Test.** Static checks.

### 9. sed script injection — `bin/git-ls-object-refs`

**Root cause.** `sed "s|…|commit referenced from $ref|"`: a ref such as
`x;cmd|e;#` would run `cmd` through GNU sed's `e` flag. BSD sed, which this
Mac uses, only errors.

**Change.** Ref names are passed to `awk -v ref="$ref"` as data.

**Test.** A branch named `y;touch${IFS}PWNED_SED|e;#` must not create the
marker file.

### 10. Wrong remote — `bin/git-prune-merged-branches`

**Change.** `git push origin …` becomes `git push "$remote" …`, so branches
merged on remote X are deleted on X, not on `origin`.

### 11. Alias `eval` — `bin/git-sh`

**Root cause.** `_git_import_aliases` ran `eval` on alias definitions built
from `git config --get-regexp`, which includes the repo-local `.git/config`.

**Change.**
- It now reads only `git config --global`.
- It skips keys outside `[A-Za-z0-9_-]`.
- It calls `alias` and `gitalias` directly, with no `eval`.

### 12–14. vim, hg, screen

- **`.vim/vimrc`:** `set nomodeline`. Opened files (mail, cloned repos) can no
  longer set options. **Test:** static check.
- **`.hgrc`:** removed `[trusted] users = 2000`. Hooks from `.hg/hgrc` in repos
  owned by that uid are no longer trusted.
- **`.screenrc`:** removed `screen -t r00t 0 su -`. With it, a root shell stayed
  alive in detached sessions and could be driven by any process running as the
  user.

### 15. cve-monitor — `cve_monitor/cve-monitor`, `setup.sh`, `README.md`

| Problem | Change |
|---------|--------|
| HTTP, network and rate-limit errors returned `{}` and were reported as "No CVEs found" | `_make_nvd_request` raises `NVDError`; `main()` exits 1 with the message |
| One page only (max 2000); longer windows were silently truncated | Pages through `startIndex` until `totalResults` |
| NVD 120-day range limit gave an error that looked like an empty result | `--days` is validated as 1..120 |
| Cache keyed only on time; cached results were already severity-filtered | The cache stores all Linux CVEs (any severity) together with `days_back`, and is reused only for the same window; severity is filtered after |
| Feed text (description, URLs) printed raw, so terminal escape injection was possible | `_clean()` strips C0/C1 control characters before printing |
| Config (API key) written with default umask | `_write_private_json()` creates the file with mode 0600 |
| `os.system(f"{editor} {CONFIG_FILE}")` | `subprocess.run(shlex.split(editor) + [path])` |
| API key passed in argv (visible in `ps` and shell history) | `--api-key -` reads the key from stdin; `setup.sh` uses `read -s` and pipes it in |

**Test.** `tests/security/test_cve_monitor.py` mocks the NVD API and checks:
- the loop fetches two pages;
- the cache is reused for a broader severity filter and refetched for a
  different window;
- no escape sequences reach the output;
- errors and out-of-range windows raise;
- the config file is 0600.

### 16. mutt `query_command` — `.mutt/general`

**Change.** `goobook query '%s'` becomes `goobook query %s`. mutt already
shell-quotes `%s`, so the extra quotes cancelled that quoting.

**Evidence.** Not reproduced: mutt isn't installed here. The change matches
goobook's documented setting.

**Test.** Static check.

### 17. Insecure fetch paths

- **`README.md`:** clone over `https://`. The oh-my-zsh installer is downloaded,
  reviewed, then run, instead of `sh -c "$(curl …)"`.
- **`bin/git-grab`:** `git://` becomes `https://`. GitHub has disabled `git://`
  anyway.
- **`vim.submodules`:** the `http://github.com/...` URL becomes `https://`.
- **`bin/webseq`:** HTTPS endpoints, and `URI.open` instead of `Kernel#open`.

### 18. Docker credential mounts — `.config/fish/conf.d/t0d0r.fish`

**Change.** `terraform.docker` mounts `$HOME/.ssh` read-only.

**Not changed.** `~/.aws` stays read-write, because AWS SSO needs to write
its cache. Images are not pinned by digest; see below.

### 19–20. Robustness fixes with security impact

- **`bin/borg.REDACTED`:**
  - `|| ( …; exit 1 )` only left a subshell, so a failed rsync still went on
    to `borg delete` and `borg create` on a partial mirror. It is now
    `|| { …; exit 1; }`.
  - The passphrase is supplied via `BORG_PASSCOMMAND` instead of
    `BORG_PASSPHRASE=$(cat …)` on each command.
- **`bin/checkup.sh`:** the log is created with `mktemp` instead of a
  predictable `/tmp/checkup_<epoch>.log`. The script was later moved to the
  private overlay on `master` and then removed entirely, along with its
  entries in `.private-manifest`.
- **`bin/ssh-retry`:** `ssh "$@"` is quoted, and the loop stops after a clean
  exit.

### 21. Removed scripts

These scripts were deleted instead of being patched:

| File | Why it was removed |
|------|--------------------|
| `bin/timehack` | Rolled the system clock back to 2005 and recommended a NOPASSWD sudo rule for `date`. TLS certificate expiry checks and TOTP are unreliable while the clock is wrong. The `Sketch.app` aliases in `.config/fish/conf.d/t0d0r.fish` and `.profile.d/aliases.sh` were removed with it. |
| `bin/cht.sh` | Vendored client. Its `--shell` mode ran `eval curl` on the query, and its self-update overwrote the script from the network with no signature check. |
| `bin/vimr` | Vendored VimR launcher. `--cur-env` wrote the whole environment to a temp file before restricting its permissions. |
| `.mutt/offlineimap.py` | Unused helper copied from someone else's config. It called `sudo -u sjl` with `shell=True`. The mutt macros invoke the `offlineimap` binary, not this file. |

### Supporting change

`bin/dotmatrix-install` now excludes `docs/` and `tests/`, so they are not
symlinked into `$HOME`.

## Manual actions required

1. ~~**Rotate the leaked credentials.**~~ Done. The owner confirmed that the
   `.netrc` (Google, Heroku), WordPress and iodine credentials were rotated
   long ago.
2. **Optional history purge**, after rotation. This rewrites history, needs a
   force-push, and does not remove existing clones or forks.
   ```sh
   git filter-repo --invert-paths --path .netrc --path .janus/blog/plugin/blog.vim
   git filter-repo --replace-text <(echo '<old-iodine-password>==>REMOVED')
   git push --force-with-lease origin master
   ```
3. **Add a secret-scanning pre-commit hook**, for example
   `gitleaks protect --staged` or `trufflehog git file://. --since-commit HEAD`.
   None of these tools is currently on PATH.
4. **Confirm the `~/.ssh` repo trust boundary.** Check who can add `.pub`
   files and `customers/*/config`, and how the `add-bst/*.sh` scripts are run.
   The fix in #4 limits the damage, but the scripts still grant
   passwordless root to whoever holds the key.

## Not changed (deliberately)

| Item | Reason |
|------|--------|
| Docker images `:latest` (`hashicorp/terraform`, `ghcr.io/anomalyco/opencode`) | Pinning needs current digests, which requires network access. Also confirm that `anomalyco` is the official opencode publisher. |
| `.mailcap` `%{charset}` in a shell pipeline | mutt uses `~/.mutt/mailcap`, not this file. Only other mailcap consumers are affected. |
| `cve_monitor/setup.sh` `notify.sh` AppleScript built from `$1`/`$2` | Not injectable today (the message holds counts only). Must be switched to `on run argv` before any feed text goes into notifications. |
| Remaining ~2400 lines of the vendored git completion in `git-sh` | Both `compgen -W` sites are fixed. Replacing it with the current `git-completion.bash` is still the long-term recommendation. |
| Infrastructure names in public files (`bin/open-catenate.sh`, `.finicky.js`, `bin/borg.REDACTED`, IPs) | Not secrets, but useful to an attacker for reconnaissance. Consider moving them to an untracked local include. |
| Unpinned vim plugins, oh-my-zsh auto-update, third-party brew taps | Normal dotfiles supply-chain trust. No specific issue found. |

## Verification

```sh
tests/security/run.sh     # 17 checks, all "ok" on this branch
```

The same suite, run against unpatched `master`, fails 13 checks. That
confirms the tests detect the original issues. The `git-ls-object-refs` check
passes on `master` too, because macOS uses BSD sed; GNU sed is required to
exploit that one.

Every modified shell script passes `bash -n` or `sh -n`. `cve-monitor`
compiles, and `webseq` passes `ruby -c`. shellcheck, gitleaks and trufflehog
are not installed, so none of them were run.

## 🔒 Security Note

The credentials found in history were rotated long ago, so what remains is
cleanup (an optional history purge) and prevention. Add a secret-scanning
pre-commit hook so a new secret never reaches the public repo. Enable 2FA on
the GitHub account: anyone who can push to this repository gets code
execution on every machine that runs `bin/dotmatrix-install`.
