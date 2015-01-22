#!/usr/bin/env bash

#----------------------
  #USER INSTALL PATHS
  export PATH_BASHFUL_INSTALL="$HOME"
  export PATH_BASHFUL_ROOT="${PATH_BASHFUL_INSTALL}/.bashful"
  export PATH_BASHFUL_BIN="${PATH_BASHFUL_ROOT}/bin"
  export PATH_BASHFUL_PROFILES="${PATH_BASHFUL_ROOT}/profiles"
  export PATH_BASHFUL_BACKUP="${PATH_BASHFUL_ROOT}/bak"

  #USER CONFIG FILES
  export PATH_BASHFUL_USER_INSTALL_FILE="${PATH_BASHFUL_ROOT}/.installed"
  
  export PATH_BASHFUL_USER_INCOMPLETE_FILE="${PATH_BASHFUL_INSTALL}/.incomplete"
  export PATH_BASHFUL_LOG="${PATH_BASHFUL_INSTALL}/bashful.log" 

  #DOWNLOAD SETUP PATHS
  export BASHFUL_SETUP_BIN="${BASHFUL_SETUP_ROOT}/bin"
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

