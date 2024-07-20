#!/usr/bin/env bash

# INSTALL NIX PORTABLE
mkdir ~/bin
cd ~/bin
wget https://github.com/DavHau/nix-portable/releases/download/v012/nix-portable-x86_64 -O nix-portable
chmod +x nix-portable

# ADD TO BASHRC
cat << 'EOF' >> ~/.bashrc

# Nix-portable
export PATH="${PATH:+${PATH}:}~/bin"
alias enter-dev='nix-portable nix shell github:nixos/nixpkgs/nixos-24.05#{ripgrep,sd,fd,as-tree,fzf,lazygit,du-dust,bat,btop,difftastic,hexyl,pazi,minicom,yazi,neovim,tree-sitter,nodejs}'
alias machine-clean='nix-portable nix-collect-garbage -d'

# Source bashrc files
alias vim='nvim'
source ~/.bashrc-vanilla
if [[ $NIX_PATH ]]; then
  source ~/.bashrc-dev
fi
source ~/.bashrc-aliases
EOF

# USE DIFFTASTIC
cat << 'EOF' >> ~/.gitconfig

[core]
  pager = "less -XF"

[diff]
  external = "difft --color auto --background dark --display inline"
EOF
