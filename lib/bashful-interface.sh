#!/usr/bin/env bash



  #----------------------
    source "./lib/utils.sh";
  #----------------------


  #----------------------
    USER_PROFILE_FILES=(.profile .bash_profile .bash_login .bashrc .bash_alias .alias .dircolors .bash_completion)
    TEMP_DIR='/tmp/'
    VAR_TAR_NAME='profile-original'
  #----------------------



  #-----------------------------------------------------------------
    function bashful_welcome() {
      welcome_banner "$1"
      #(sleep 60) &
      #spinner $!
    }


    function bashful_install() {
      bashful_welcome "Bashful Util"

      backup_sys_profile
      do_setup
      do_install

      check_profile_state
      echo $SECONDS
      if [ $? -ne 0 ]; then
        bashful_profile
      fi

      #rmobj $PATH_BASHFUL_USER_INCOMPLETE_FILE
      #if SETUP_DONE && INSTALL_DONE => REMOVE INC
      #
      bashful_exit
    }



    function bashful_profile() {
      if [ $OPT_PROFILE -eq 1 ]; then
        start_spinner "Making Profilies"
          sleep 3
          build_bashful_profile
        stop_spinner $?
      else
        concern "Bash starter profile not created"
      fi
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

    function bashful_exit() {
      warn "Bashful Exit"
    }

    function bashful_usage() {
			cat <<-EOF
				Usage: bashful [-cdnt] <command> [subcommand]
			EOF
    }
  #-----------------------------------------------------------------


  #-----------------------------------------------------------------
    
    function check_run() {
      #name=$1;flag=$2;tester=$3;runner=$4
      local try=0;
      local param=("${@}")
      #debug "${param[0]} ${!param[1]} ${param[1]} ${param[3]} $SECONDS"
      if "${param[2]}" $try; then pass "${param[0]} OK"
      else
        warn "${param[0]} not complete, attempting recovery"
        #lazy setup
        while [ "${!param[1]}" -ne 1 ] && [ $try -lt 1 ]; do
          try=$((try + 1))
          ${param[3]}
          ${param[2]} $try
          info "Rechecking ${param[1]} try:$try done:${!param[1]}"
          if [ ${!param[1]} -eq 1 ]; then
            pass "${param[0]} OK"
            break
          fi
        done
      fi
    }


    function check_paths() {
      local retry=$1
      local name=$2
      [ $retry -eq 0 ] && header "$name Check" || header "Retry $name Check (${retry})" 

      local ERROR_MSG=()
      local lbl="setup"
      local err="not ready"
      local paths=("${@}")

      if [ ${#ERROR_MSG[@]} -gt 0 ]; then
        for data in "${ERROR_MSG[@]}"
        do
          if [ -n "$data" ]; then
            failed "[$lbl] $data $err"
            #add to repair list
          fi
        done
        #fail "Setup validation failed"
        return 1
      else
        #pass "Setup Check Done!"
        STAT_SETUP_DONE=1
        return 0
      fi 

    }
  #-----------------------------------------------------------------


  #-----------------------------------------------------------------

    function run_setup() {
      start_spinner "Verifying Bashful Dirs"
        sleep 3
        make_dirs "${PATH_BASHFUL_ROOT}" "${PATH_BASHFUL_BIN}" "${PATH_BASHFUL_PROFILES}" "${PATH_BASHFUL_BACKUP}"
        update_path "${BASHFUL_SETUP_BIN}"
        update_path "${PATH_BASHFUL_BIN}"
        touch $PATH_BASHFUL_INCOMPLETE_FILE
      stop_spinner $?
    }

    function do_setup() {
      check_run "setup" "STAT_SETUP_DONE" check_setup_state run_setup
    }

    function check_setup_state() {
      local retry=$1
      [ $retry -eq 0 ] && header "Setup Check" || header "Retry Setup Check (${retry})" 
      STAT_SETUP_DONE=0  
      local ERROR_MSG=()
      local lbl="setup"
      local err="not ready"
      local sv=( "BASHFUL_SETUP_ROOT" "BASHFUL_SETUP_BIN" "PATH_BASHFUL_INSTALL" "PATH_BASHFUL_ROOT" "PATH_BASHFUL_BIN" )

      #bash deref ${!var}
      for data in "${sv[@]}"
      do
        [ -n "${!data}" ] && [ -r "${!data}" ] && updated "[$lbl] ${!data} set" || ERROR_MSG+=("${data}")
      done
      #last check
      inpath "${!sv[4]}" && updated "[setup] ~/.bashful/bin in PATH" || ERROR_MSG+=("[setup] <${sv[4]}> to PATH var")
      #dump on error
      if [ ${#ERROR_MSG[@]} -gt 0 ]; then
        for data in "${ERROR_MSG[@]}"
        do
          if [ -n "$data" ]; then
            failed "[$lbl] $data $err"
            #add to repair list
          fi
        done
        #fail "Setup validation failed"
        return 1
      else
        #pass "Setup Check Done!"
        STAT_SETUP_DONE=1
        return 0
      fi 

    }
  #-----------------------------------------------------------------




  #-----------------------------------------------------------------
    function run_install() {
      start_spinner "Verifying Install Dirs"
        sleep 3
        make_dirs "${PATH_BASHFUL_ROOT}" "${PATH_BASHFUL_BIN}" "${PATH_BASHFUL_PROFILES}" "${PATH_BASHFUL_BACKUP}"
        update_path "${PATH_BASHFUL_BIN}"
        touch $PATH_BASHFUL_INSTALL_FILE 
        rm $PATH_BASHFUL_INCOMPLETE_FILE
      stop_spinner $?
    }


    function do_install() {
      check_run "install" "STAT_INSTALL_DONE" check_install_state run_install
    }

    function check_install_state() {
      local retry=$1
      [ $retry -eq 0 ] && header "Install Check" || header "Retry Install Check (${retry})" 
      STAT_INSTALL_DONE=0   
      local ERROR_MSG=()
      local lbl="install"
      local err="not ready"
      local sv=( "PATH_BASHFUL_BACKUP" "PATH_BASHFUL_INSTALL"  \
                 "PATH_BASHFUL_ROOT"     \
                 "PATH_BASHFUL_BIN"      \
                 "PATH_BASHFUL_INSTALL_FILE" \
                 "PATH_BASHFUL_PROFILES" )

      #export OK
      #setup OK
      #profile backup OK
      #install OK
      #profile OK

      for data in "${sv[@]}"
      do
        #echo "data( ${data} )"
        [ ! -z "${data}" ] && [ -n "${!data}" ] && [ -r "${!data}" ] && updated "[$lbl] ${!data} set" || ERROR_MSG+=("${data}")
      done

      #do we need this?
      if [ ! -f $PATH_BASHFUL_INCOMPLETE_FILE ]; then
          updated "[install] No incomplete marker ~/.bashful/.incomplete"
        else
          STAT_INSTALL_DONE=0
          ERROR_MSG+=("PATH_BASHFUL_INCOMPLETE_FILE") 
          echo "$PATH_BASHFUL_INCOMPLETE_FILE"
      fi

      #dump on error
      if [ ${#ERROR_MSG[@]} -gt 0 ]; then
        for data in "${ERROR_MSG[@]}"
        do
          if [ -n "$data" ]; then
            failed "[$lbl] $data $err"
            #add to repair list
          fi
        done
        #fail "Install validation failed"
        return 1
      else
        #pass "Setup Check Done!"
        STAT_INSTALL_DONE=1
        return 0
      fi 

    }

    function check_profile_state() {
      STAT_PROFILE_DONE=0
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
      rm -f ./prof*.tar
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
        problem "Careful ${PROFILE_NAME} profile already exists"
      fi
    }


    function backup_sys_profile() {
      local FILES=("${USER_PROFILE_FILES[@]}")
      header "Backup Bash Profile"
      #keep only existing files
      for i in ${!FILES[@]}; do
        file="$HOME/${FILES[$i]}"
        if [ ! -f "$file" ]; then
          unset FILES[$i]
        else
          FILES[$i]=$file
        fi
      done

      BAK_PROFILE_ORIGINAL="${PATH_BASHFUL_BACKUP}/${VAR_TAR_NAME}.tar"
      #echo -e "\nbackup file is $BAK_PROFILE_ORIGINAL"

      if [ ! -f "${BAK_PROFILE_ORIGINAL}" ] && [ ! -f "./${VAR_TAR_NAME}.tar" ]; then
        warn "profile original not found at ${BAK_PROFILE_ORIGINAL}"
        util_tarup "${VAR_TAR_NAME}" "${FILES[@]}"

        if [ $? -eq 0 ]; then
          updated "Back up user files done => ${white}${TAR_FILE}${reset}"
          true
        else
          problem "Problem creating profile backup"
          false
        fi

      else
        updated "Found original profile backup"
      #  util_tarup "profile-$(filetime)" "${FILES[@]}"
      fi


      
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
     force_stop_spinner
     error "$ERORR_MESSAGE" #TODO:fix to use stderr
     recover
     bashful_usage
     return $1
    }
  #----------------------



