#!/usr/bin/env bash



  #----------------------
    source "./lib/utils.sh";
  #----------------------


  #----------------------
    USER_PROFILE_FILES=(.profile .bash_profile .bash_login .bashrc .bash_alias .alias .dircolors .bash_completion)
    PATH_SYSTEM_PROFILE="/etc/profile"
    PATH_BASH_PROFILE="$HOME/.bash_profile"
    PATH_BASH_RC="$HOME/.bashrc"
    TEMP_DIR='/tmp/'


  #----------------------



  #-----------------------------------------------------------------
    function bashful_welcome() {
      welcome_banner "$1"
      #(sleep 60) &
      #spinner $!
    }


    function bashful_install() {
      bashful_welcome "Bashful Install"
      update_path $BASHFUL_SETUP_BIN
      backup_sys_profile 
      check_install_state
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
      if [ -e $PATH_BASHFUL_ROOT ] && [ -f $PATH_BASHFUL_USER_INSTALL_FILE ] && [ ! -f $PATH_BASHFUL_USER_INCOMPLETE_FILE ]; then
        #install is done
        updated "Bashful is fully installed."
        fake_uninstall_bashful
      else
        #not installed yet
        if [ ! -f $PATH_BASHFUL_USER_INSTALL_FILE ]; then
          #new install
          failed "Bashful not installed."
          build_dir "${PATH_BASHFUL_ROOT}"
          build_dir "${PATH_BASHFUL_BIN}"
          build_dir "${PATH_BASHFUL_PROFILES}"
          build_dir "${PATH_BASHFUL_BACKUP}"
          build_bashful_profile
          fake_install_bashful
        else
          if [ -f $PATH_BASHFUL_USER_INCOMPLETE_FILE ]; then
            #unfinished install
            problem "Bashful has not finished installing."
          fi
          fake_uninstall_bashful
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
      touch $PATH_BASHFUL_USER_INSTALL_FILE
    }

    function fake_uninstall_bashful(){
      remobj $PATH_BASHFUL_ROOT
      remobj $PATH_BASHFUL_USER_INSTALL_FILE
      remobj $PATH_BASHFUL_PROFILES
    }
  #-----------------------------------------------------------------

  #-----------------------------------------------------------------
    function build_dir() {
        local BUILD_DIR=$1
        started "Bashful looking for ${BUILD_DIR}"
        mkdir -p "$BUILD_DIR"
        if [ $? -eq 0 ]
          then
            updated "Created directory ${white}${BUILD_DIR}${reset}"
          else
            problem "Cannot build bashful ${BUILD_DIR} directory"
        fi 
    }

    function build_bashful_profile(){
      local PROFILE_NAME=${OPT_PROFILE_NAME:default}
            PATH_PROFILE="${PATH_BASHFUL_PROFILES}/${PROFILE_NAME}"

      started "Bashful creating profile ${PROFILE_NAME}"
      
      if [ -d "${PATH_BASHFUL_PROFILES}" ] && [ ! -d $PATH_PROFILE ]; then
        mkdir -p "${PATH_PROFILE}"
        touch "${PATH_PROFILE}/.path"
        touch "${PATH_PROFILE}/.alias"
        touch "${PATH_PROFILE}/.env"
        touch "${PATH_PROFILE}/.cache"
        touch "${PATH_PROFILE}/.project"
        touch "${PATH_PROFILE}/.version"
        updated "Bashful Profile (${cyan}${PROFILE_NAME}${reset}) profile started!"
      else
        warn "Careful ${PROFILE_NAME} profile already exists"
      fi
    }


    function backup_sys_profile() {
      local FILES=("${USER_PROFILE_FILES[@]}")
      started "Backing up user files"

      #keep only existing files
      for i in ${!FILES[@]}; do
        file="$HOME/${FILES[$i]}"
        if [ ! -f "$file" ]; then
          unset FILES[$i]
        else
          FILES[$i]=$file
        fi
      done

      BAK_PROFILE_ORIGINAL="${PATH_BASHFUL_BACKUP}/profile-original.tar"
      echo -e "backup file is $BAK_PROFILE_ORIGINAL"
      if [ ! -f "${BAK_PROFILE_ORIGINAL}" ] && [ ! -f "./profile-original.tar" ]; then
        warn "profile original not found at ${BAK_PROFILE_ORIGINAL}"
        util_tarup "profile-original" "${FILES[@]}"
      else
        info "making copy of profile"
        util_tarup "profile-$(filetime)" "${FILES[@]}"
      fi

      updated "Back up user files done => ${white}${TAR_FILE}${reset}"
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



