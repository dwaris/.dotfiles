# Dotfiles Repo Rules

Stow packages live at the repo root (`nvim`, `shell`, `mise`, `vscode`, ...). Private packages (`agents`, `git`, `ssh`) live in the `private/` submodule and are stowed with `stow -d private -t ~ --no-folding <pkg>`.
Every config must stay portable across NixOS, Arch, and Debian/RHEL servers.

## Mise
- **Desktop** (`mise/.config/mise/config.toml`): agent CLIs (`agy`, pi) plus dotfile tooling: `lua-language-server`, `stylua`, `shfmt`, `shellcheck`, `marksman`, `taplo`, `node`, `bash-language-server`, `biome`, `uv`.
- **Server** (`server/.config/mise/config.toml`): standalone no-root environment, `stow shell nvim server && mise install`. Adds `neovim`, `starship`, `lazygit`, `lazydocker`, `bottom`, `zoxide`, `eza`, `bat`, `delta`, `dust`, `tree-sitter`, `ripgrep`, `fd`, `fzf` on top of the desktop tooling.
- Keep the two configs in sync when adding dotfile LSPs/formatters.

## Neovim (`nvim/`)
- `init.lua` guards with `if vim.g.vscode then ... else require 'dwaris' end`; UI plugins, Snacks, and LSPs must never load inside VS Code.
- LSP servers are registered in the `servers` table in `lua/dwaris/plugins/lsp.lua` and only attach when the binary is on `$PATH`.
- Formatting is `conform.nvim` format-on-save; add new formatters to `formatters_by_ft` in `lsp.lua`.
- File management is `oil.nvim` (`q` closes, `delete_to_trash = true`). No sidebar tree explorers.
- Undo history is `Snacks.picker.undo()` on `<leader>u`. Do not add `mbbill/undotree`.
- Enabled Snacks modules are listed in `lua/dwaris/plugins/snacks.lua`; check there before adding a plugin that duplicates one.

## VS Code (`vscode/`)
- Stow with `stow -t ~ --no-folding vscode`.
- Global extensions stay minimal: `asvetliakov.vscode-neovim`, Catppuccin theme and icons, `google.google-antigravity`, `jnoortheen.nix-ide`, `sumneko.lua`, `johnnymorganz.stylua`, `davidanson.vscode-markdownlint`, `mkhl.direnv`, `ms-vscode.hexeditor`, `ms-vscode-remote`. JSON uses the built-in formatter.
- Language-heavy extensions (`rust-analyzer`, `cpptools`, Python/Pylance, `golang.go`, `latex-workshop`, `elixir-ls`, `redhat.vscode-yaml`, `biomejs.biome`) are disabled globally and enabled per workspace.

## Verification
- Lua: `stylua --check <files>`
- Shell: `shellcheck <file>` and `shfmt -d <file>`
- Nix: `alejandra --check <files>`
- TOML: `taplo check <files>`
