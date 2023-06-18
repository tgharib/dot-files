#!/usr/bin/env bash

# SOURCE BASHRC FILES
cat << 'EOF' >> ~/.bashrc

alias vim='nvim'
source ~/.bashrc-vanilla
source ~/.bashrc-dev
source ~/.bashrc-aliases
EOF
