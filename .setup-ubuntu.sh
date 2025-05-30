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

run sudo apt install curl bat kitty dex fd-find ripgrep fzf sd wl-clipboard cliphist sway build-essential btop i3status wlr-randr pulsemixer gammastep swayidle lxqt-policykit remind buku syncthing keepassxc light slurp grim kolourpaint imv zathura zathura-djvu nodejs npm mako-notifier pandoc texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra texlive-science rubber entr wireguard-tools ufw mpv restic gparted
# entr for triggering commands on file changes
# install nvim appimage to /usr/bin/nvim and edit `/etc/environment` to set $EDITOR and follow https://askubuntu.com/a/1390401
run cargo install pazi
run cargo install du-dust
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

run LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*') && curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && tar xf lazygit.tar.gz lazygit && sudo install lazygit -D -t /usr/local/bin/ && rm lazygit && rm lazygit.tar.gz

run xdg-mime default org.pwmt.zathura.desktop application/pdf

# Disable ipv6 in /etc/default/ufw
run sudo tee /etc/systemd/system/vpn.service <<EOF
[Unit]
Description=VPN
Wants=network-online.target
After=network-online.target

[Service]
RemainAfterExit=yes
ExecStartPre=/bin/sh -c 'until ping -c1 google.com; do sleep 1; done;'
ExecStart=/home/owner/personal-only/misc/scripts/my_start_vpn.sh
ExecStop=sh -c "wg-quick down pia; ufw disable; echo 'DONE STOPPING VPN'"

[Install]
WantedBy=multi-user.target
EOF
# For VPN with obfuscation, use PIA linux app: https://www.privateinternetaccess.com/download/linux-vpn

# Setup firefox by logging into firefox account
# https://medium.com/@Aenon/firefox-hide-native-tabs-and-titlebar-f0b00bdbb88b
# https://github.com/pixeltris/TwitchAdSolutions (use vaft)
# Firefox tridactyl has binds:
# * `;u`, `;U`, `;;` to hover
# * `s` and `S` to search DDG
# * `b` to search tabs
# * Ctrl+I in textbox to edit with editorcmd (`:set editorcmd`)

# Desktop only below

run sudo tee /etc/modprobe.d/blacklist-intelwifi.conf <<EOF
blacklist iwlwifi
EOF

# Laptop only below

cd .kanata
run wget https://github.com/jtroo/kanata/releases/download/v1.8.0/kanata
cd ..
run sudo tee /etc/systemd/system/kanata.service <<EOF
[Unit]
Description=Kanata keyboard remapper
Documentation=https://github.com/jtroo/kanata

[Service]
Type=simple
ExecStart=/home/owner/.kanata/kanata --cfg /home/owner/.kanata/kanata.kbd
Restart=never

[Install]
WantedBy=default.target
EOF

run sudo add-apt-repository ppa:linrunner/tlp
run sudo apt update
run sudo apt install tlp tlp-rdw powertop
run sudo systemctl enable tlp.service
run sudo tee /etc/tlp.d/laptop.conf <<EOF
DEVICES_TO_DISABLE_ON_STARTUP="bluetooth nfc wwan"
START_CHARGE_THRESH_BAT0=75
STOP_CHARGE_THRESH_BAT0=80
RESTORE_THRESHOLDS_ON_BAT=1
EOF

# add acpi.ec_no_wakeup=1 kernel parameter
# other hacks: https://old.reddit.com/r/thinkpad/comments/1dvw8gp/thinkpad_t14_gen_5_amd_on_ubuntu_2204_2404/
# sudo powertop to check wattage
# limit TDP when on battery
# install special Ubuntu software package oem-kernel
# use a battery bank for extended battery life
