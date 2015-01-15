#!/usr/bin/env bash

#----------------------


  #USER INSTALL PATHS
  export PATH_BASHFUL_INSTALL="$HOME"
  export PATH_BASHFUL_ROOT="${PATH_BASHFUL_INSTALL}/.bashful"
  export PATH_BASHFUL_BIN="${PATH_BASHFUL_ROOT}/bin"
  export PATH_BASHFUL_PROFILE_BAK="${PATH_BASHFUL_ROOT}/.bak"

  #USER CONFIG FILES
  export PATH_BASHFUL_USER_SETUP_FILE="${PATH_BASHFUL_INSTALL}/.bashful-setup"
  export PATH_BASHFUL_USER_SETUP_LOG="${PATH_BASHFUL_INSTALL}/bashful.log" 

  #DOWNLOAD SETUP PATHS
  export PATH_BASHFUL_SETUP_BIN="${PATH_BASHFUL_SETUP_ROOT}/bin"
#----------------------

#----------------------
  function setup_install_alias() {
    eval 'alias bashful="${PATH_BASHFUL_SETUP_BIN}/bashful"'
  }
#----------------------

