#!/usr/bin/env bash

# INSTALL NIX PORTABLE
mkdir ~/bin
cd ~/bin
wget https://github.com/DavHau/nix-portable/releases/download/v009/nix-portable
chmod +x nix-portable
ln -s ./nix-portable ./nix

cat << 'EOF' >> ~/.bashrc

PATH="${PATH:+${PATH}:}~/bin"
alias enter-dev='NP_RUNTIME=bwrap nix shell github:nixos/nixpkgs/nixos-22.11#{ripgrep,sd,fd,as-tree,fzf,abduco,lazygit,du-dust,bat,btop,libqalculate,difftastic,neovim,tree-sitter,nodejs,gcc}'
# github:nixos/nixpkgs/nixos-unstable
alias machine-clean='~/bin/nix-portable nix-collect-garbage -d'
EOF

# USE DIFFTASTIC
cat << 'EOF' >> ~/.gitconfig

[core]
  pager = "less -XF"

[diff]
  external = "difft --color auto --background dark --display inline"
EOF