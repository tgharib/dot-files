# Workflow

* Tiling wm in windows and Linux with 1 tab per terminal
* CLI tools like rg, fd, fzf, clifm for CLI
* Abduco for decoupling from ssh
* Vim has buffers

# Setup

## NixOS

Use `shells.nix` and `dev-tools.nix`.

## Other Linux

Run `setup-linux.sh`

## Windows

* Checkout windows branch
* Install wezterm, git bash (uses cygwin so Windows-only binaries) and install neovim for windows (install vim-plug, nodejs for coc, python for snippets and follow nvim-treesitter docs to install compiler). Create a symbolic link into %localappdata%/nvim/init.vim. Install sd, rg, fd, fzf, lazygit, gsudo in neovim binary directory.

# Helix

* install helix binary from github releases (comes with treesitter)
* for lsp, run `hx --health cpp`. install clangd binary from github releases and generate compile_commands.json
* run `hx -v` and `tail -f ~/.cache/helix/helix.log`
