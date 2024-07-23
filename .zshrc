alias s='kitten ssh'
alias r="tput reset"
cheat() {
  curl cheat.sh/"$1"
}
spwd() {
  echo $(whoami)@$(hostname):$(pwd)
}

