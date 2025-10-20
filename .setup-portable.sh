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

# Add to bashrc
run cat << EOF >> ~/.bashrc

export PATH="\${PATH:+\${PATH}:}~/bin:~/.cargo/bin:~/bin/nvim-linux-$arch/bin"
source ~/.bashrc-portable
EOF

# Install rustup and use cargo to install: ripgrep, sd, fd-find, skim, du-dust, astree, pazi
# Install lazygit and btop

# Install nodejs
run curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
## restart terminal
run nvm install node
run nvm use node

# Install nvim
run mkdir ~/bin
run cd ~/bin
run wget https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-$arch.tar.gz
run tar xvf nvim-linux-$arch.tar.gz
run rm nvim-linux-$arch.tar.gz
