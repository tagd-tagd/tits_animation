#!/bin/bash
# https://github.com/tagd-tagd/tits_animation
declare -r LOG=$(mktemp)
declare JP PID
trap 'echo
      tput cnorm #restore terminal
      # test -s "$LOG" && cat "$LOG" 
      test -s "$LOG" && less "$LOG"
      rm "$LOG"
      exit' EXIT
trap 'exit' INT TERM HUP QUIT ERR
function TITS(){
  declare N P T=${1:-21}
  case "${T:0:1}" in
    1) N='(.)';;
    2) N='(o)';;
    *) N='(*)';;
  esac
  case "${T:1:1}" in
    1) P=${N}${N}' ';;
    2) P=${N}' '${N};;
    *) P=' '${N}${N};;
  esac
  printf "\r%s" "$P"
}

tput civis # hide cursor
# help and demo
if [[ $# -eq 0 ]];then
  echo "animate long foreground process execution"
  echo "usage $0 command"
  echo "for example $0 sleep 10"
fi
${@:-sleep 10} > "$LOG" 2>&1 &
PID=$!
while :;do
  for i in 21 12 23 33 23 12 21 31;do
    TITS  $i
    sleep .3
    for JP in $(jobs -pr);do 
      if [[ "$PID" == "$JP" ]];then # PID running
        continue 2
      fi
    done
    exit
  done
done
