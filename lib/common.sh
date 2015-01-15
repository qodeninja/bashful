#!/usr/bin/env bash

set -o pipefail


  #----------------------
    function console(){
      if [ -t 1 ] || [ -z $OPT_QUIET ]; then 
        printf "${1}" "${2}"
      fi
    }
  #----------------------


  #----------------------
    function log()   { printf '%s\n' "$*"; }
    function error() { log "ERROR: $*" >&2; } #google recommended
    function fatal() { error "$@"; exit 1; }
  #----------------------

