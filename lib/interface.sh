#!/usr/bin/env bash


set -o pipefail

 source "./lib/utils.sh";

# #----------------------
  
#   SYSTEM_PROFILE="/etc/profile"
#   BASH_PROFILE="$HOME/.bash_profile"
#   USER_PROFILE="$HOME/.profile"
#   BASH_RC="$HOME/.bashrc"

#   TEMP_DIR=''
#   RECOVER=()
#   ERRORS=()
# #----------------------


# #-----------------------------------------------------------------
# function bashful_welcome() {
#   welcome_banner "$1"
#   purple "Configuring your environment for Bashful! \n"
#   update_path
# }

# function bashful_config() {
#   bashful_welcome "Bashful Install"
#   #init_alias
#   check_user_install
#   check_startup_profile
# }

# function bashful_install() {
#   echo 'hi'
# }

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




