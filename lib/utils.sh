#!/usr/bin/env bash

set -o pipefail

source "./lib/term.sh"

#----------------------
  MOD_LOADED=()
#----------------------

#----------------------

  function add_path() {
    for d; do
      d=$(cd -- "$d" && { pwd -P || pwd; }) 2>/dev/null  # canonicalize symbolic links
      if [ -z "$d" ]; then continue; fi  # skip nonexistent directory
      case ":$PATH:" in
        *":$d:"*) :;;
        *) PATH=$PATH:$d;;
      esac
    done
  }

  function timestamp() {
    echo -e $(date +%s) 
  }
#----------------------


#----------------------

  function inpath () { 
    case ":$PATH:" in
      *":$1:"*) return 0;;
      *) return 1;;
    esac
  }

 alias path='echo -e ${PATH//:/\\n}'
  # function inpath() {
  #   for d; do

  #   done
  # }
#----------------------


#----------------------

  function strip_comments(){
    sed '/^#/ d' $1
  }

#----------------------


#----------------------

  function command_exists() {
      type "$1" &> /dev/null ;
  }

#----------------------


#----------------------

  function xtitle() { 
    echo -en  "\033]0;$*\007" ; 
  }

#----------------------


#----------------------

  function colorgrid() {
      def=$(tput colors)
      len=${1:-$def}  
      if command_exists tput && [ ! -z $len ]; then
        for i in $(seq 1 $len); do tput setab $i; echo -n "  $i "; done; tput setab 0; echo
      else
        echo "Error - <tput> command not found"
      fi
  }

#----------------------

  function source_dep() {
    local mod_name="${1}"
    shift
    local dep_list=("${@}")
    local mods_loaded=("${MOD_LOADED[@]}")
    for dep in "${dep_list[@]}"; do
      echo $dep
    done
  }

#----------------------


#----------------------

  function remobj() {
    #echo $1
    if [ -d "$1" ]
      then
        rm -rf $1
    fi
    if [ -f "$1" ]
      then
        rm -f $1
    fi
  }


#----------------------


#----------------------

  function quicksleep(){
    sleep 0.5
  }

  function started(){
    quicksleep
    str=$1
    printf "\r${white}${str}... ${reset}" 
  }

  function updated(){
    quicksleep
    str=$1
    printf "\r${green}${pass3}${reset} ${whitedim}${str}${reset}${clear_eol}\n" 
  }

  function problem(){
    quicksleep
    str=$1
    printf "\r${orange}${fail2}${reset} ${white}${str}${reset}${clear_eol}\n" 
  }

  function failed(){
    quicksleep
    str=$1
    printf "\r${red}${fail2}${reset} ${white}${str}${reset}${clear_eol}\n" 
  }

#----------------------

function read_config() {
  ifpipe
  regex='\$\{([a-zA-Z_][a-zA-Z_0-9]*)\}'
  while read line; do
      while [[ "$line" =~ $regex ]]; do
          param="${BASH_REMATCH[1]}"
          line=${line//${BASH_REMATCH[0]}/${!param}}
      done
      echo $line
  done

}

#----------------------


#----------------------

function spinner() {
  PROC=$1
  while [ -d /proc/$PROC ];do
    echo -n '/^H' ; sleep 0.05
    echo -n '-^H' ; sleep 0.05
    echo -n '\^H' ; sleep 0.05
    echo -n '|^H' ; sleep 0.05
  done
  return 0
}

function spinner2(){
    SP_STRING=${2:-"'|/=\'"}
    while [ -d /proc/$1 ]
    do
        printf "$SP_COLOUR\e7  %${SP_WIDTH}s  \e8\e[0m $SP_STRING"
        sleep ${SP_DELAY:-.2}
        #SP_STRING=${SP_STRING#"${SP_STRING%?}"}${SP_STRING%?}
    done

    ## Adjust to taste (or leave empty)
    # SP_COLOUR="\e[37;41m"
    # SP_WIDTH=1.1  ## Try: SP_WIDTH=5.5
    # SP_DELAY=.2

    # sleep 3 &
    # spinner "$!" '.o0Oo'
}


#----------------------


#----------------------

function ifpipe() {
  #echo "pipehi" | ifpipe
  #ifpipe "hi" 
  #ifpipe < ./default.cfg
  if [[ -p /dev/stdin ]]
  then
      echo "stdin is coming from a pipe"
  fi
  if [[ -t 0 ]]
  then
      echo "stdin is coming from the terminal"
  fi
  if [[ ! -t 0 && ! -p /dev/stdin ]]
  then
      echo "stdin is redirected"
  fi
}

#----------------------

  function stack_trap() {
      trap_add_cmd=$1; shift || fatal "${FUNCNAME} usage error"
      for trap_add_name in "$@"; do
          trap -- "$(
              # helper fn to get existing trap command from output
              # of trap -p
              extract_trap_cmd() { printf '%s\n' "$3"; }
              # print existing trap command with newline
              eval "extract_trap_cmd $(trap -p "${trap_add_name}")"
              # print the new trap command
              printf '%s\n' "${trap_add_cmd}"
          )" "${trap_add_name}" \
              || fatal "unable to add to trap ${trap_add_name}"
      done
  }

#----------------------