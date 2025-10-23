#!/usr/bin/env zsh

# Install homebrew (macos user needs to be an admin)
# Install Karabiner, f.lux, VS Code, mpv, obs, neovim, lazygit
# Optional: AltTab, Smooze Pro
# Follow .setup-ubuntu.sh to install Iosevka.ttc and SymbolsNerdFontMono-Regular.ttf and SymbolsNerdFont-Regular.ttf

# https://stackoverflow.com/questions/77052638/changing-default-shell-from-zsh-to-bash-on-macos-catalina-and-beyond
# Changing shell to bash requires a restart
# Add `source ~/.bashrc-portable` to ~/.bash_profile

brew install --cask --no-quarantine middleclick

# https://www.npmjs.com/package/gitsm
npm install -g gitsm
