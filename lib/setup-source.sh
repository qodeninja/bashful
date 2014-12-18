#!/usr/bin/env bash

#----------------------
  export BASHFUL_SETUP_BIN="$BASHFUL_SETUP_ROOT_DIR/bin"
  export BASHFUL_SEUP_FILE=".bashful-install"
  export BASHFUL_SETUP_INCLUDE="$BASHFUL_SETUP_ROOT_DIR/$BASHFIN_SETUP_FILE"
  export BASHFUL_INSTALL_DEST="~"
#----------------------

#----------------------
  function install_alias() {
    eval 'alias bashful="$BASHFUL_SETUP_ROOT_DIR/bin/bashful"'
    eval 'alias bf="bashful"'
    eval 'alias bashfin="bashful install"'
    echo 'Bashful install aliases ready.'
  }
#----------------------
