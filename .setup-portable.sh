#!/usr/bin/env bash

run() {
  printf '%s ' "run $@?" > /dev/tty
  IFS= read -r answer < /dev/tty
  case $answer in
    [yY]*) eval "$@";;
  esac
}

# Add to bashrc
run cat << 'EOF' >> ~/.bashrc

export PATH="${PATH:+${PATH}:}~/bin:~/.cargo/bin:~/bin/nvim-linux-x86_64/bin"
source ~/.bashrc-portable
EOF

# Install rustup for cargo, rg, sd, fd, fzf, lazygit, dust, as-tree, btop, pazi, nodejs

# Install nvim
run mkdir ~/bin
run cd ~/bin
run wget https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz
run tar xvf nvim-linux-x86_64.tar.gz
run rm nvim-linux-x86_64.tar.gz
