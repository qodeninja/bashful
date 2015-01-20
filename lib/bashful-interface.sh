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
      bashful_welcome "Bashful Util"
      update_path $BASHFUL_SETUP_BIN
      update_path $PATH_BASHFUL_BIN
      backup_sys_profile 
      check_setup_state
      check_install_state
    }

    function bashful_uninstall() {
      bashful_welcome "Bashful Util"
      fake_uninstall_bashful
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
      if [ -e "$PATH_BASHFUL_USER_INSTALL_FILE" ]; then
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
    function check_setup_state() {
      STAT_SETUP_DONE=0   
      STAT_SETUP_ERROR=0
        
      if [ -n "$BASHFUL_SETUP_ROOT" ]; then
        #setup root - location of unpacked util (pwd/bashful)
        updated "[check] /pwd/bashful set"
      else
        STAT_SETUP_ERROR=1   
        recover "bashful root install location is missing"
      fi
      

      if [ -n "$BASHFUL_SETUP_BIN" ] && [ -e "$BASHFUL_SETUP_BIN" ]; then
        #setup bin - location of exec util (pwd/bashful/bin)
        updated "[check] /pwd/bashful/bin set"
      else
        STAT_SETUP_ERROR=1   
        recover "bashful root bin location is missing"
      fi


      if [ -n "$PATH_BASHFUL_INSTALL" ] && [ -e "$PATH_BASHFUL_INSTALL" ]; then 
        #install - location of user home or package dir  (~/)
         updated "[check] ~/ set"
      else
        STAT_SETUP_ERROR=1
        recover "setup install root <PATH_BASHFUL_INSTALL> is missing - usually user home directory"
      fi


      if [ -n $PATH_BASHFUL_ROOT ] && [ -e $PATH_BASHFUL_ROOT ]; then 
        #user root - need to exist before we can add stuff to it (~/.bashful)
        updated "[check] ~/.bashful set"
      else
        #doesnt exist
        STAT_SETUP_ERROR=1
        recover "setup <PATH_BASHFUL_ROOT> is missing - usually ~/.bashful"
      fi


      if [ -n $PATH_BASHFUL_BIN ] && [ -e $PATH_BASHFUL_BIN ]; then 
        #user root - need to exist before we can add stuff to it (~/.bashful/bin)
        updated "[check] ~/.bashful/bin set"
      else
        STAT_SETUP_ERROR=1
        recover "setup <PATH_BASHFUL_BIN> is missing"
      fi


      if inpath "$PATH_BASHFUL_BIN"; then 
        #setup bin - needs to be in PATH for easy execution
        updated "[check] ${PATH_BASHFUL_BIN} in PATH"
      else
        STAT_SETUP_ERROR=1
        recover "add <PATH_BASHFUL_BIN> to PATH var"
      fi

      #TODO:this is broken cuz of symlink
      if [ -L $BASHFUL_SETUP_BIN ] && inpath "$(readlink -n $BASHFUL_SETUP_BIN)"; then
        updated "[check] ${BASHFUL_SETUP_BIN} symlink in PATH"
      elif inpath "$BASHFUL_SETUP_BIN"; then 
        #setup bin - needs to be in PATH for easy execution
        updated "[check] ${BASHFUL_SETUP_BIN} in PATH"
      else
        STAT_SETUP_ERROR=1
        recover "add <BASHFUL_SETUP_BIN> to PATH var"
      fi

      if [ $STAT_SETUP_ERROR -eq 1 ]; then
        path
        failed "Setup problem in state check"
        exit 1
      fi

    }
  
  
    # function check_state() {
    #   STAT_INSTALLED=0
    #   STAT_INCOMPLETE=0
    #   STAT_PROFILE=0
    #   STAT_ERROR=0
    #   STAT_DONE=0  


    #   STAT_INSTALL_ERROR=0
    #   STAT_PROFILE=ERROR=0


    #   if [ -e $PATH_BASHFUL_ROOT ] && [ -f $PATH_BASHFUL_USER_INSTALL_FILE ] && [ ! -f $PATH_BASHFUL_USER_INCOMPLETE_FILE ]; then
    #     #install state requires ~/.bashful and ~/.bashful/.installed and not ~/.bashful/.incomplete
    #     STAT_INSTALLED=1
    #   else
    #     #otherwise install is not done
    #     STAT_INSTALLED=0

    #     #check for incomplete file -- usually when install has started and not finished
    #     if [ -f $PATH_BASHFUL_USER_INCOMPLETE_FILE ]; then
    #       STAT_INCOMPLETE=1
    #     fi

    #     #check for installed file -- should not exist if install is not done - this needs a cleanup
    #     if [ -f $PATH_BASHFUL_USER_INSTALL_FILE ]; then
    #       STAT_INSTALL_ERROR=1
    #     fi

    #   fi

    #   #PROFILES

    #   if [ -e $PATH_BASHFUL_PROFILES ]


    # }


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

          start_spinner "Installing Bashful Dirs"
            sleep 3
            make_dirs "${PATH_BASHFUL_ROOT}" "${PATH_BASHFUL_BIN}" "${PATH_BASHFUL_PROFILES}" "${PATH_BASHFUL_BACKUP}"
          stop_spinner $?

          if [ $OPT_PROFILE -eq 1 ]; then
            #build_bashful_profile
            
            start_spinner "Making Profilies"
              sleep 3
              build_bashful_profile
            stop_spinner $?

          else
            concern "Bash starter profile not created"
          fi

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


      if [ ! -d $PATH_PROFILE ]; then
        touch_dir_files "${PATH_PROFILE}" .path .alias .env .cache .project .version
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
        #if [ ${#RECOVER[@]} -gt 0 ]; then
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



  #----------------------
    function exit_signal() {
      if [ $? -ne 0 ]; then exit_error $?; 
      else 
        info "[${OPT_COMMAND}] Finished."
      fi
    }


    function throw_error() {
      ERORR_MESSAGE=$1
      #error "$1" 1>&2
      exit 1
    }


    function exit_error() {
     clean_up $1
     error "$ERORR_MESSAGE" #TODO:fix to use stderr
     recover
     bashful_usage
     return $1
    }
  #----------------------
