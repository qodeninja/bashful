#!/usr/bin/env bash



  #----------------------
    source "./lib/utils.sh";
  #----------------------


  #----------------------
    USER_PROFILE_FILES=(.profile .bash_profile .bash_login .bashrc .bash_alias .alias .dircolors .bash_completion)
    PATH_SYSTEM_PROFILE="/etc/profile"
    PATH_BASH_PROFILE="$HOME/.bash_profile"
    PATH_BASH_RC="$HOME/.bashrc"
    TEMP_DIR=''
  #----------------------



  #-----------------------------------------------------------------
    function bashful_welcome() {
      welcome_banner "$1"
    }

    function bashful_config() {

      check_startup_profile
    }

    function bashful_install() {
      bashful_welcome "Bashful Install"
      update_path $BASHFUL_SETUP_BIN
      #check_install_state
      backup_user_profile 
      #check_startup_profile
    }

    function bashful_clean() {
      warn "Bashful Clean is not implemented yet"
    }

    function bashful_nuke() {
      warn "Bashful Nuke is not implemented yet"
    }

    function bashful_usage() {
			cat <<-EOF
				Usage: bashful [-cdnt] <command> [subcommand]
			EOF
    }
  #-----------------------------------------------------------------


  #-----------------------------------------------------------------
    function bashful_test() {

      #SETUP
      if [ -n "$BASHFUL_SETUP_BIN" ]; then
        updated "Setup variable ready"
      else
        failed "Setup variable is missing"
      fi

      #SETUP CWD
      if ! inpath "$BASHFUL_SETUP_BIN"; then
        updated "PATH variable ready"
      else 
        failed "PATH missing setup bin path"
      fi

      #BASHFUL INSTALLED
      if [ -e "$PATH_BASHFUL_ROOT" ]; then
        updated "Bashful root ready"
      else
        concern "Bashful root not found"
      fi

      #BASHFUL SETUPFILE
      if [ -e "$PATH_BASHFUL_USER_SETUP_FILE" ]; then
        updated "Bashful setup file ready"
      else
        concern "Bashful setup file not created"
      fi

      if [ "$OPT_DEBUG" = 1 ]; then 
        updated "Debug On"
      else
        concern "Debug Off"
      fi

      if [ "$OPT_AUTO" = 1 ]; then 
        updated "Automate On"
      else
        concern "Auto Off"
      fi

      if [ "$OPT_CLEAN" = 1 ]; then 
        updated "Clean On"
      else
        concern "Clean Off"
      fi 

      if [ "$OPT_NUKE" = 1 ]; then 
        updated "Nuke On"
      else
        concern "Nuke Off"
      fi 

    }
  #-----------------------------------------------------------------



  #-----------------------------------------------------------------
    function check_install_state() {
      #check if ~/.bashful exists
      started "Checking Bashful install state"
      if [ -e $PATH_BASHFUL_ROOT ] && [ ! -f $PATH_BASHFUL_USER_SETUP_FILE ]; then
        #install is done
        updated "Bashful is fully installed."
      else
        #not installed yet
        if [ ! -f $PATH_BASHFUL_USER_SETUP_FILE ]; then
          #new install
          failed "Bashful not installed."
          fake_install_bashful
        else
          #unfinished install
          problem "Bashful has not finished installing."
        fi
      fi
    }


    function check_startup_profile() {
      if [ -e $PATH_SYSTEM_PROFILE ]; then 
        info "System profile found" 
        true
      fi 
    }

  #-----------------------------------------------------------------



  #-----------------------------------------------------------------
    function welcome_banner() {
      echo ${purple};
      command_exists xtitle && xtitle $1
      command_exists figlet && figlet $1 || header $1
      echo ${reset};
    }
  #-----------------------------------------------------------------
  


  #-----------------------------------------------------------------
    function fake_install_bashful(){
      info "Fake installing bashful"
      mkdir -p $PATH_BASHFUL_ROOT
      touch $PATH_BASHFUL_USER_SETUP_FILE
    }

    function fake_uninstall_bashful(){
      remobj $PATH_BASHFUL_ROOT
      remobj $PATH_BASHFUL_USER_SETUP_FILE
    }
  #-----------------------------------------------------------------

  #-----------------------------------------------------------------
    function build_bin_install() {
        local BUILD_DIR=$1
        started "Bashful install directory is missing"
        mkdir -p "$BUILD_DIR"
        if [ $? -eq 0 ]
          then
            updated "Bashful install directory created!"
          else
            problem "Cannot build bashful install directory"
        fi 
    }


    function backup_user_profile() {
      local FILES=("${USER_PROFILE_FILES[@]}")
      started "Backing up user files"
      for i in ${!FILES[@]}; do
        file="$HOME/${FILES[$i]}"
        if [ ! -f "$file" ]; then
          #debug "$file doesnt exist"
          unset FILES[$i]
        else
          FILES[$i]=$file
        fi
      done
      #debug '%s exists\n' "${FILES[@]}"

      util_tarup "profile-original" "${FILES[@]}"

      updated "Back up user files done. $TAR_FILE"
    }
  #-----------------------------------------------------------------
  


  #-----------------------------------------------------------------
    function clean_up() {
      if [ $1 -eq 0 ]; then 
        started "Cleaning up"
        clean
      else
        started "Recovery cleanup"
        clean
        recover "Cleanup rolled back previously installed files"
        recover "Correct any errors and try again $1"
      fi
      updated "Done cleaning up!"
    }

    function clean_vars(){
      started "Removing Bashful VARS"
      gunset 'PATH_BASHFUL.*'
      gunset '*BASHFUL.*'
    }

    function clean() {
      remobj $BASHFUL_BIN
    }
  #-----------------------------------------------------------------



