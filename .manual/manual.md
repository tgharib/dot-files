Workflow:
* Tiling wm in windows and Linux with 1 tab per terminal
* CLI tools like rg, fd, fzf, clifm for CLI
* Abduco for decoupling from ssh
* Vim has buffers

NixOS machine uses `shells.nix` and `dev-tools.nix`.

On non-nixos machine:
* Install nix-portable (github) to ~/bin/:

```
mkdir ~/bin
cd ~/bin
wget nix-portable
chmod +x nix-portable
ln -s ./nix-portable ./nix
```

* Append to .bashrc:

```
PATH="${PATH:+${PATH}:}~/bin"
alias enter-dev='NP_RUNTIME=bwrap nix shell github:nixos/nixpkgs/nixos-22.05#{ripgrep,sd,fd,fzf,abduco,lazygit,du-dust,bat,btop,libqalculate,clifm,neovim,tree-sitter,nodejs}'
# github:nixos/nixpkgs/nixos-unstable
alias machine-clean='~/bin/nix-portable nix-collect-garbage -d'
alias vim='nvim'
source ~/.dev-bashrc
```

On windows machine:
* Checkout windows branch
* Install wezterm, git bash (uses cygwin so Windows-only binaries) and install neovim for windows (install vim-plug, nodejs for coc, python for snippets and follow nvim-treesitter docs to install compiler). Create a symbolic link into %localappdata%/nvim/init.vim. Install sd, rg, fd, fzf, lazygit, gsudo in neovim binary directory.

Helix:
* install helix binary from github releases (comes with treesitter)
* for lsp, run `hx --health cpp`. install clangd binary from github releases and generate compile_commands.json
* run `hx -v` and `tail -f ~/.cache/helix/helix.log`