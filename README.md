# Info

My dot files. Primarily written on macOS, also used on Linux (Debian).

A number of scripts under `bin/` are macOS-only -- anything using `defaults
write`, `osascript`, `brew` or `/Users/...` paths (`disable_all_animation.sh`,
`osa-notify`, `mailmate-backup`, the JetBrains launchers, ...). They are kept in
the repo but simply do nothing useful on Linux.

# How to install it

```bash
  mkdir github
  cd github
  git clone https://github.com/t0d0r/dotmatrix.git
  cd dotmatrix && ./bin/dotmatrix-install
```

The installer symlinks every top-level dotfile into `$HOME`, every directory
under `.config/` into `~/.config/`, and the contents of `dot.claude/` into
`~/.claude/`. Existing files are never overwritten -- they are reported and
skipped. Entries that must not be linked are listed in
`bin/dotmatrix-exclude.sh`, which both the installer and the uninstaller source,
so the two can't drift apart.

To remove the symlinks again (only those pointing back into this repo):

```bash
  cd dotmatrix && ./bin/dotmatrix-uninstall
```

Vim plugins are managed by [vim-plug](https://github.com/junegunn/vim-plug); the
installer runs `PlugInstall`/`PlugUpdate` for you. Git submodules are no longer
used.

If you prefer zsh, here is how to install it:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

# Private overlay

Some scripts here reference hosts and infrastructure that are not mine to
publish. They are not in this repo in plaintext -- they ship as a single
encrypted archive, `private.tar.gz.gpg`, and are restored to their normal
paths on install, so anything calling them keeps working:

```bash
  ./bin/private-unseal        # decrypt (dotmatrix-install runs this)
  ./bin/private-seal          # re-encrypt after editing, then commit the .gpg
```

`bin/private-seal` reads the path list from `.private-manifest`. Both the
manifest and the decrypted files stay out of git via `.git/info/exclude`,
which `private-unseal` maintains -- deliberately not `.gitignore`, since
that file is public and the paths themselves are the thing being hidden.

Encryption is `gpg --symmetric --cipher-algo AES256`; you are prompted for
the passphrase. One archive rather than per-file `.gpg`s, so no filename
discloses what it protects.

# Notes
  * .netrc - part of goobook mutt helper
  * `bin/` is symlinked to `~/bin` and lands on `$PATH`, so anything added there
    is executable as you -- review changes before pulling.

# Lint

Shell scripts are checked with [shellcheck](https://www.shellcheck.net/) in CI
(`.github/workflows/shellcheck.yml`). Vendored third-party scripts are listed in
the workflow's exclude list. To run it locally:

```bash
  shellcheck bin/git-pull-dir bin/dotmatrix-install bin/dotmatrix-uninstall
```
