#!/usr/bin/env bash


set -o pipefail

 source "./lib/utils.sh";

#----------------------
  
  SYSTEM_PROFILE="/etc/profile"
  BASH_PROFILE="$HOME/.bash_profile"
  USER_PROFILE="$HOME/.profile"
  BASH_RC="$HOME/.bashrc"

  TEMP_DIR=''
  RECOVER=()
  ERRORS=()
#----------------------


#-----------------------------------------------------------------
function bashful_welcome() {
  welcome_banner "$1"
  purple "Configuring your environment for Bashful! \n"
  update_path
}

function bashful_config() {
  bashful_welcome "Bashful Install"
  #init_alias
  check_user_install
  check_startup_profile
}

function bashful_install() {
  echo 'hi'
}

function bashful_confirm_vars(){
  grey 'confirm variables'
  #echo $VERBOSE
  cyan "home $BF_USER_HOME_DIR"
  cyan "build $BF_BUILD_DIR"
  cyan "profile $BF_PROFILE_NAME"
}

#-----------------------------------------------------------------

function check_user_install() {
  if [ -e $BASHFUL_HOME ]; then
    info "Bashful install directory exists"
    true
  else
    build_bin_install $BASHFUL_HOME
  fi
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

function check_startup_profile() {
  if [ -e $SYSTEM_PROFILE ]; then 
    info "System profile found" 
    true
  fi 
}

function backup_system_profile() {
  echo hi

}
#-----------------------------------------------------------------


function check_build_dir() {
  started "Setting up build directory"
  if [ ! -d $BASHFUL_BUILD_PATH ]
  then
    if [ -w $INSTALL_DIR ]
      then
       mkdir -p $WP_ROBOT_SETUP_PATH
       #info "Setup directory created! ${WP_ROBOT_SETUP_PATH}"
       updated "Build directory created"
      else
       recover "Sorry, You dont have sufficient permission to build Bashful here!"
       exit 1;
    fi
  else
    if [ -z $OPT_FORCE ]; then
      problem "Build directory already exists"
      recover 'Use <clean> before reinstalling $WP_ROBOT_SETUP_PATH'
      exit 1
    fi
  fi
}



function check_named_install() {
  started "Verify insance installs"
  if [ -z "$1" ]; 
    problem "Missing name parameter"
    recover "You must specify the name of the install instance"
    exit 1
    then continue; 
  fi 

}



function init_menu() {


  if [ ! -d $BASHFUL_EXPECTED_DIR ]
      then
        grey '>  bf         (bashful utility)'
        warn ' bf install (setup and install bashful) '
        grey '>  bf clean   (nuke installed and generated files)'
      else
        cyan '>  bf         (bashful utility)'
        grey '>  bf install (setup and install bashful)'
        cyan '>  bf clean   (nuke installed and generated files)'
  fi

  cyan '>  bf conf    (re-source config and show this message again)'
  cyan '>  bf help    (bashful manual and help doc)'
}




#-----------------------------------------------------------------

function welcome_banner() {
  echo ${purple};
  command_exists xtitle && xtitle $1
  command_exists figlet && figlet $1 || header $1
  echo ${reset};
}

#-----------------------------------------------------------------

function update_path() {
  started "Updating PATH"
  if ! inpath ${NEW_PATH}; then
    add_path $NEW_PATH
  fi
  updated "Updated PATH variable"
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



#-----------------------------------------------------------------
# exit functions

function exit_signal() {
  if [ $? -ne 0 ]; then exit_error $?; 
  else 
    info "Done"
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