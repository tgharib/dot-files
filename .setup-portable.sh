#!/usr/bin/env bash

# ADD TO BASHRC
cat << 'EOF' >> ~/.bashrc

export PATH="${PATH:+${PATH}:}~/bin:~/.cargo/bin:~/bin/nvim/usr/bin"
# install rustup for cargo, rg, sd, fd, fzf, lazygit, dust, as-tree, btop, pazi, nvim, nodejs

# Source bashrc files
source ~/.bashrc-portable
EOF
