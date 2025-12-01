#!/usr/bin/env bash

run() {
  printf '%s ' "run $@?" > /dev/tty
  IFS= read -r answer < /dev/tty
  case $answer in
    [yY]*) eval "$@";;
  esac
}

if [[ $# -eq 0 ]] ; then
  echo './.setup-portable.sh x86_64/arm64'
  exit 1
fi

arch=$1

run cat << EOF >> ~/.bashrc

# Source bashrc files and add nvim to path
export PATH="\${PATH:+\${PATH}:}~/bin:~/bin/nvim-linux-$arch/bin:~/go/bin"
source ~/.bashrc-portable

EOF

run git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
run ~/.fzf/install
run cargo install ripgrep sd fd-find du-dust hexyl zoxide git-delta
run cargo install -f --git https://github.com/jez/as-tree
run go install github.com/joshmedeski/sesh/v2@latest
run sudo apt install btop tmuxinator

git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.line-numbers true
git config --global merge.conflictStyle zdiff3

# Install lazygit

# Install nvim
run mkdir ~/bin
run cd ~/bin
run wget https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-$arch.tar.gz
run tar xvf nvim-linux-$arch.tar.gz
run rm nvim-linux-$arch.tar.gz
