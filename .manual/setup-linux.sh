#!/usr/bin/env bash

mkdir ~/bin
cd ~/bin
wget https://github.com/DavHau/nix-portable/releases/download/v009/nix-portable
chmod +x nix-portable
ln -s ./nix-portable ./nix

cat << 'EOF' > ~/.bashrc

PATH="${PATH:+${PATH}:}~/bin"
alias enter-dev='NP_RUNTIME=bwrap nix shell github:nixos/nixpkgs/nixos-22.05#{ripgrep,sd,fd,fzf,abduco,lazygit,du-dust,bat,btop,libqalculate,clifm,watchexec,neovim,tree-sitter,nodejs}'
# github:nixos/nixpkgs/nixos-unstable
alias machine-clean='~/bin/nix-portable nix-collect-garbage -d'
alias vim='nvim'
source ~/.dev-bashrc
EOF
