#!/usr/bin/env bash

#----------------------
  export BASHFUL_INSTALL="$HOME"
  export BASHFUL_HOME="$BASHFUL_INSTALL/.bashful"
  export BASHFUL_BIN="$BASHFUL_HOME/bin"
  export BASHFUL_INCLUDE="$BASHFUL_HOME/.bashful-profile"
#----------------------

#----------------------
  function install_alias() {
    eval 'alias bashful="$BASHFUL_SETUP_DIR/bin/bashful"'
  }
#----------------------

install_alias