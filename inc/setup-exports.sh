#!/usr/bin/env bash

#----------------------
  export BASHFUL_INSTALL="$HOME"
  export BASHFUL_HOME="$BASHFUL_INSTALL/.bashful"
  export BASHFUL_BIN="$BASHFUL_HOME/bin"
  export BASHFUL_INC="$BASHFUL_HOME/inc"
  export BASHFUL_LIB="$BASHFUL_HOME/lib" 
  export BASHFUL_INCLUDE="$BASHFUL_HOME/.bashful-profile"
#----------------------

#----------------------
  function setup_install_alias() {
    eval 'alias bashful="$BASHFUL_SETUP_DIR/bin/bashful"'
  }
#----------------------

