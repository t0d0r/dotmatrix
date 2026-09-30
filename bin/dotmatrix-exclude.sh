# Shared by dotmatrix-install and dotmatrix-uninstall -- sourced, not executed.
#
# Top-level entries that must NOT be symlinked into $HOME:
#   - repo plumbing (.git, .gitignore, .gitmodules, .github, README.md)
#   - vim.d / vim.submodules      : aliases of .vim, handled by vim-plug
#   - dot.claude                  : its *contents* are linked into ~/.claude
#   - brew.leaves, cve_monitor    : repo data, not dotfiles
#   - private.tar.gz.gpg, .private-manifest, .shellcheck-exclude : repo data
#   - docs, tests                 : documentation and regression tests
EXCLUDE='^\.$|^\.git$|^\.github$|^\.gitignore$|^\.gitmodules$|^README\.md$|^vim\.d$|^vim\.submodules$|^dot\.claude$|^brew\.leaves$|^cve_monitor$|^private\.tar\.gz(\.gpg)?$|^\.private-manifest$|^\.shellcheck-exclude$|^docs$|^tests$'
