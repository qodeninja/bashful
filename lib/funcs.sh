#!/usr/bin/env bash

source "./lib/term.sh"

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
