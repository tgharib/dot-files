#!/usr/bin/env zsh

# Install homebrew (macos user needs to be an admin)
brew install karabiner flux mpv obs neovim lazygit btop tmuxinator
# Optional: AltTab, Smooze Pro
brew install --cask --no-quarantine middleclick

# Follow .setup-ubuntu.sh to install Iosevka.ttc and SymbolsNerdFontMono-Regular.ttf and SymbolsNerdFont-Regular.ttf

# https://stackoverflow.com/questions/77052638/changing-default-shell-from-zsh-to-bash-on-macos-catalina-and-beyond
# Changing shell to bash requires a restart
# Add `source ~/.bashrc-portable and PATH export` to ~/.bash_profile

# https://www.npmjs.com/package/gitsm
npm install -g gitsm
