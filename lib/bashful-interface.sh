#!/usr/bin/env bash



  #----------------------
    source "./lib/utils.sh";
  #----------------------


  #---------------------- 
  # echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  #---------------------- 


  #----------------------
    PATH_SYSTEM_PROFILE="/etc/profile"
    PATH_BASH_PROFILE="$HOME/.bash_profile"
    PATH_USER_PROFILE="$HOME/.profile"
    PATH_BASH_RC="$HOME/.bashrc"

    TEMP_DIR=''
    RECOVER=()
    ERRORS=()
  #----------------------



  #-----------------------------------------------------------------
    function bashful_welcome() {
      welcome_banner "$1"
      purple "Configuring your environment for Bashful! \n"
      update_path $PATH_BASHFUL_SETUP_BIN
    }

    function bashful_config() {
      bashful_welcome "Bashful Install"
      #init_alias
      check_install_state
      check_startup_profile
    }


  #-----------------------------------------------------------------



  #-----------------------------------------------------------------
    # function check_setup() {
    #   if [ -n "$BASHFUL_HOME" ]; then
    #     export BASHFUL_SETUP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    #     source "./inc/setup-exports.sh"
    #   fi
    # }

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
      #check if ~/.bashful-setup exists
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

    function build_user_install() {
      local BUILD_FILE=$1
      local TIMESTAMP=$(timestamp)
      started "Setting up build install file"

      echo -e "#!/usr/bin/env bash" > $BUILD_FILE
      echo -e "# GENERATED BASHFIN INSTALL FILE - Last Built $(date)" >> $BUILD_FILE
      echo -e "export BASHFUL_INCLUDE_FILE=$BUILD_FILE" >> $BUILD_FILE
      echo -e "export BASHFUL_BUILD_TIME=$TIMESTAMP" >> $BUILD_FILE
      echo -e "export BASHFUL_BIN=$BASHFUL_SETUP_DIR/bin" >> $BUILD_FILE
      echo -e "export BASHFUL_STATUS=INSTALL" >> $BUILD_FILE
      #mv -f $BUILD_FILE $BASHFIN_INCLUDE_INSTALL_DIR/$BUILD_FILE

      #cat $BUILD_FILE;
      updated "Build install file created!"
    }
  #-----------------------------------------------------------------
  


  #-----------------------------------------------------------------
    function update_path() {
      local NEW_PATH=$1
      started "Adding new PATH"
      if ! inpath ${NEW_PATH}; then
        add_path $NEW_PATH
      fi
      updated "Added PATH => ${NEW_PATH}"
    }


    function recover() {
      if [ -n "$1" ]; then
        RECOVER+=("$1")
      else
        if [ ${#RECOVER[@]} -gt 0 ]; then
          echo -e ''
          header 'Help' 
          for data in "${RECOVER[@]}"
          do
            info "  - ${data}"
            # do something on $var
          done
        fi
      fi
    }


    function clean_up() {
      if [ $1 -ne 0 ]; then 
        started "Cleaning up"
        clean
      else
        started "Recovery cleanup"
        clean
        recover "Cleanup rolled back previously installed files"
        recover "Correct any errors and try again"
      fi
      updated "Done cleaning up!"
    }


    function clean() {
      remobj $BASHFUL_BIN
    }

  #-----------------------------------------------------------------



  #-----------------------------------------------------------------
    function exit_signal() {
      if [ $? -ne 0 ]; then exit_error $?; 
      else 
        info "Done"
      fi
    }


    function throw_error() {
      echo "$1" 1>&2
      exit 1
    }


    function exit_error() {
     clean_up $1
     echo -e  "\n\n"
     fail "An error occurred which prevented the install from running."
     recover
     return $1
    }
  #-----------------------------------------------------------------
