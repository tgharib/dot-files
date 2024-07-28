bindkey -v
bindkey ^R history-incremental-search-backward
bindkey ^S history-incremental-search-forward

alias s='kitten ssh'
alias r="tput reset"
cheat() {
  curl cheat.sh/"$1"
}
spwd() {
  echo $(whoami)@$(hostname):$(pwd)
}

