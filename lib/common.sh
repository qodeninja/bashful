#!/usr/bin/env bash

set -o pipefail


  #----------------------
    function console(){
      if [ -t 1 ] || [ -z $OPT_QUIET ]; then 
        printf "${1}" "${2}"
      fi
    }

    function debug(){
      if [ -t 1 ] && [ $OPT_DEBUG -eq 1 ]; then 
        printf "${1}\n" "${2}"
      fi
    }
  #----------------------


  #----------------------
    function log()     { printf '%s\n' "$*"; }
    function error()   { log "$*" >&2; } #google recommended
    function fatal()   { error "$@"; exit 1; }
    #function debug_log { if [ $OPT_LOGFILE -eq 1 ]; then log "$*" 2>&1 | tee $OPT_LOGFILENAME; }
  #----------------------

