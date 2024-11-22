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
source ~/.bashrc-portable

EOF

run sudo apt install curl bat kitty dex fd-find ripgrep fzf sd wl-clipboard sway build-essential btop i3status wlr-randr pulsemixer gammastep swayidle lxqt-policykit remind buku syncthing neovim keepassxc light slurp grim kolourpaint imv zathura nodejs npm mako-notifier
run cargo install pazi
run cargo install -f --git https://github.com/jez/as-tree
run sudo adduser owner video
run sudo ln -s /usr/bin/fdfind /usr/bin/fd
run sudo ln -s /usr/bin/batcat /usr/bin/bat
run sudo ln -s /usr/bin/imv-wayland /usr/bin/imv

run mkdir ~/.fonts/
run cd ~/Downloads/

run wget https://github.com/be5invis/Iosevka/releases/download/v31.5.0/SuperTTC-Iosevka-31.5.0.zip
run unzip SuperTTC-Iosevka-31.5.0.zip
run rm SuperTTC-Iosevka-31.5.0.zip
run mv Iosevka.ttc ~/.fonts/

run wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/NerdFontsSymbolsOnly.tar.xz
run tar xvf NerdFontsSymbolsOnly.tar.xz
run rm NerdFontsSymbolsOnly.tar.xz LICENSE README.md 10-nerd-font-symbols.conf
run mv SymbolsNerdFontMono-Regular.ttf ~/.fonts/
run mv SymbolsNerdFont-Regular.ttf ~/.fonts/

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

sudo add-apt-repository ppa:linrunner/tlp
sudo apt update
sudo apt install tlp tlp-rdw powertop
sudo systemctl enable tlp.service
# disable bluetooth and enable battery cary in /etc/tlp.conf
# add acpi.ec_no_wakeup=1 kernel parameter
# sudo powertop to check wattage
# https://old.reddit.com/r/thinkpad/comments/1dvw8gp/thinkpad_t14_gen_5_amd_on_ubuntu_2204_2404/
