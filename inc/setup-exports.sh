#!/usr/bin/env bash

  #----------------------
    
    if [ -n $BASHFUL_EXPORT_MD5 ]; then
      NEW_MD5="$(md5 -q ${BASH_SOURCE[0]})"
      if [ ! "$NEW_MD5" = "$BASHFUL_EXPORT_MD5" ]; then
        export BASHFUL_EXPORT_MD5="$NEW_MD5"
      fi
    fi


    if [ $STAT_BASHFUL_EXPORT -eq 1 ]; then
      gunset 'PATH_BASHFUL.*'
    fi
  #----------------------


  #----------------------
    #USER INSTALL PATHS
    export PATH_BASHFUL_INSTALL="$HOME"                               ## ~/
    export PATH_BASHFUL_ROOT="${PATH_BASHFUL_INSTALL}/.bashful"       ## ~/.bashful
    export PATH_BASHFUL_BIN="${PATH_BASHFUL_ROOT}/bin"                ## ~/.bashful/bin
    export PATH_BASHFUL_PROFILES="${PATH_BASHFUL_ROOT}/profiles"      ## ~/.bashful/profiles
    export PATH_BASHFUL_BACKUP="${PATH_BASHFUL_ROOT}/bak"             ## ~/.bashful/bak

    #USER CONFIG FILES
    export PATH_BASHFUL_INSTALL_FILE="${PATH_BASHFUL_ROOT}/.installed"
    export PATH_BASHFUL_INCOMPLETE_FILE="${PATH_BASHFUL_ROOT}/.incomplete"
    export PATH_BASHFUL_LOG="${PATH_BASHFUL_INSTALL}/bashful.log" 

    #DOWNLOAD SETUP PATHS
    #      BASHFUL_SETUP_ROOT                                   ## $PWD/bashful 
    export BASHFUL_SETUP_BIN="${BASHFUL_SETUP_ROOT}/bin"        ## $PWD/bashful/bin
    export BASHFUL_SETUP_LIB="${BASHFUL_SETUP_ROOT}/lib"        ## $PWD/bashful/lib
    export BASHFUL_SETUP_INC="${BASHFUL_SETUP_ROOT}/inc"        ## $PWD/bashful/bin

    #PROFILES
    export BASHFUL_PROFILE="default"

  #----------------------


  #----------------------
    function bashful_cmd(){
      local CMD="$1"
      local BASHFUL="${BASHFUL_SETUP_BIN}/bashful"
      shift
      $BASHFUL $CMD "$@"
    }

    alias bashful="bashful_cmd"
    alias bf="bashful_cmd"
    alias bfdir="cd ${BASHFUL_SETUP_ROOT}"
  #----------------------


  export STAT_BASHFUL_EXPORT=1