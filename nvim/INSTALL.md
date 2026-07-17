# Installation Guide

## Prerequisites

- **Neovim 0.11+** — the LSP config uses the new `vim.lsp.config` API introduced in 0.11.
- **Git** — required by lazy.nvim to clone plugins and itself.
- **ripgrep** (`rg`) — required by Telescope live-grep / grep search.
- **make** + a C compiler (`gcc` or `clang`) — required to build some Tree-sitter parsers and `telescope-fzf-native.nvim`.
- **Tree-sitter CLI** — required by `nvim-treesitter` to compile/install parsers.
- **Node.js / npm** — required by the `ts_ls` language server.
- **Go** — required by `gopls` and the `templ` language server.
- **Rust** — required by `rust-analyzer`.
- (Optional) **tmux** — if you want to use the `<C-f>` tmux-sessionizer keymap.

## Installing prerequisites

### macOS (Homebrew)

```bash
brew install neovim git ripgrep make gcc tree-sitter node go tmux
```

Install Rust via [rustup](https://rustup.rs/):

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Ubuntu / Debian

```bash
sudo apt update
sudo apt install neovim git ripgrep make gcc g++ tree-sitter-cli nodejs npm golang-go tmux
```

Install Rust via [rustup](https://rustup.rs/):

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Arch Linux

```bash
sudo pacman -S neovim git ripgrep make gcc tree-sitter nodejs npm go tmux
```

Install Rust via [rustup](https://rustup.rs/):

```bash
sudo pacman -S rustup
rustup default stable
```

### Notes

- **Neovim 0.11+** is required. Check your version with `nvim --version`. If your package manager provides an older release, install it from a [release binary](https://github.com/neovim/neovim/releases) or build from source.
- **Node.js** can also be installed via [nvm](https://github.com/nvm-sh/nvm).
- **Go** can also be installed from the [official Go downloads](https://go.dev/dl/).
- **Tree-sitter CLI** can also be installed with npm if your package manager does not ship it: `npm install -g tree-sitter-cli`.

## Install

### 1. Backup your existing config

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

### 2. Clone this config

If this repo is already on your machine at `~/dotfiles/nvim`, symlink it to the standard Neovim config location:

```bash
mkdir -p ~/.config
ln -s ~/dotfiles/nvim ~/.config/nvim
```

Otherwise, clone it directly:

```bash
git clone <repo-url> ~/.config/nvim
```

### 3. Create the undo directory

This config stores persistent undo history in `~/.vim/undodir`:

```bash
mkdir -p ~/.vim/undodir
```

### 4. Install language servers

The config uses Mason to manage LSP servers. Open Neovim and run:

```vim
:Mason
```

Install the following packages:

- `ts_ls` (TypeScript)
- `rust_analyzer` (Rust)
- `gopls` (Go)
- `templ` (Templ)
- `html` (HTML)
- `htmx` (HTMX)

Alternatively, install the binaries via your system package manager (e.g., `npm install -g typescript-language-server`, `rustup component add rust-analyzer`, `go install golang.org/x/tools/gopls@latest`).

### 5. First launch

Open Neovim:

```bash
nvim
```

lazy.nvim will bootstrap itself, then download and install all plugins. This may take a minute or two. After plugins are installed, Tree-sitter will automatically install the configured parsers.

## Post-install

- **Rose Pine** is the default colorscheme.
- **Leader key** is set to `<Space>`.
- See [`lua/config/remap.lua`](lua/config/remap.lua) and [`lua/config/lsp.lua`](lua/config/lsp.lua) for the full keymap list.

## Troubleshooting

- **Telescope grep fails**: make sure `ripgrep` is installed and on your `$PATH`.
- **Tree-sitter build errors**: install `tree-sitter` CLI, a C compiler, and `make`.
- **No completions**: verify the language servers are installed and running with `:Mason` or `:LspInfo`.
- **`<C-f>` tmux-sessionizer does nothing**: this keymap calls an external `tmux-sessionizer` script; install it separately if you want to use it.
- **`<leader>vpp` error**: this keymap points to a personal file path that may not exist on your machine; edit it in `lua/config/remap.lua` if needed.
