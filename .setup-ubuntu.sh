#!/usr/bin/env bash

run() {
  printf '%s ' "run $@?" > /dev/tty
  IFS= read -r answer < /dev/tty
  case $answer in
    [yY]*) eval "$@";;
  esac
}

run cat << 'EOF' >> ~/.bashrc

# Source bashrc files
source ~/.bashrc-nonix
source ~/.bashrc-dev
EOF

run sudo apt install kitty dex fd-find ripgrep fzf sd wl-clipboard sway build-essential btop i3status wlr-randr pulsemixer gammastep swayidle lxqt-policykit remind buku syncthing neovim keepassxc light
# mako, pazi
run sudo adduser owner video
run sudo ln -s /usr/bin/fdfind /usr/bin/fd

run cd ~/Downloads/
run wget https://github.com/be5invis/Iosevka/releases/download/v31.5.0/SuperTTC-Iosevka-31.5.0.zip
run unzip SuperTTC-Iosevka-31.5.0.zip
run mkdir ~/.fonts/
run mv Iosevka.ttc ~/.fonts/

# Setup firefox by logging into firefox account

# Laptop only below

run mkdir /etc/keyd/
run tee /etc/keyd/default.conf <<EOF
[ids]
*

[main]
# Maps capslock to escape when pressed and meta when held.
capslock = overload(meta, esc)
# Maps tab to tab when pressed and alt when held.
tab = overload(alt, tab)

# Remaps keys
leftalt = leftcontrol
# esc = capslock
EOF

run sudo add-apt-repository ppa:keyd-team/ppa
run sudo apt update
run sudo apt install keyd
