#!/usr/bin/env bash

  #----------------------
    set -o pipefail
    source "./lib/term.sh"
  #----------------------

  #----------------------
    MOD_LOADED=()
    RECOVER=()
    ERRORS=()
  #----------------------


  #----------------------
    function add_entry(){
      local etype=$1 #alias,path,env
      local ename=$2
      local ebody=$3
      local egroup=$4
    }

    function edit_entry(){
      local etype=$1 #alias,path,env
      local ename=$2
      local ebody=$3
      local egroup=$4
    }

    function del_entry(){
      local etype=$1 #alias,path,env
      local ename=$2
      local ebody=$3
      local egroup=$4
    }
  #----------------------


  #----------------------
    function add_path() {
      for d; do
        d=$(cd -- "$d" && { pwd -P || pwd; }) 2>/dev/null  # canonicalize symbolic links
        if [ -z "$d" ]; then continue; fi  # skip nonexistent directory
        case ":$PATH:" in
          *":$d:"*) :;;
          *) PATH=$PATH:$d;;
        esac
      done
    }

    function timestamp() {
      echo -e $(date +%s) 
    }

    function filetime(){
      echo -e $(date +%m%d%Y)
    }
  #----------------------


  #----------------------
    function inpath () { 
      case ":$PATH:" in
        *":$1:"*) return 0;;
        *) return 1;;
      esac
    }

    alias path='echo -e ${PATH//:/\\n}'

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
  #----------------------


  #----------------------
    function strip_comments(){
      sed '/^#/ d' $1
    }

    function gunset(){
      local PATTERN=$1
      if [ -n $PATTERN ]; then
        env | grep ${PATTERN} | while read -r line ; do
          echo -e "\nGrep on $line"
        done
      fi
    }
  #----------------------


  #----------------------
    function command_exists() {
        type "$1" &> /dev/null ;
    }
  #----------------------


  #----------------------
  #install 
  function touch_dir_files(){
    local base=$1; shift
    local files=("${@}")
    if [ ! -d "${base}" ]; then
      make_dir "$base"
    fi
    if [ $? -eq 0 ]; then
      for f in "${files[@]}"; do
        local fullpath="${base}/${f}"
        #started "Looking for ${fullpath}"
        if [ ! -f "${fullpath}" ]; then
          touch "${fullpath}"
        fi
      done
    fi
  }



  function make_dir() {
      local BUILD_DIR=$1
      started "Looking for ${BUILD_DIR}"
      mkdir -p "$BUILD_DIR"
      if [ $? -eq 0 ]
        then
          updated "Created directory ${white}${BUILD_DIR}${reset}"
          true
        else
          problem "Cannot build ${BUILD_DIR} directory"
          false
      fi 
  }

  #----------------------

  #----------------------

    function safename(){
      local name=$1
      local ext=${2-""}
      local cache=${3-""}
      local count=0
      #extension is optional but if provied adds dot
      if [ -n "${cache}" ]; then ext="-${cache}"; fi
      if [ -n "${ext}"   ]; then ext=".${ext}"; fi
      local temp="${name}${cache}"
      local base="${temp}"
      #increment file
      while [ -f "${temp}${ext}" ] || [ -f "${base}-${count}${ext}" ]; do
        count=$[count + 1]
        temp="${base}-${count}"
      done
      temp="${temp}${ext}"
      printf "${temp}"
    }


    #macos -H option?
    function util_tarup() {
      local name=$1; shift
      local list=("${@}")
      local tarfile="$(safename ${name} tar)"
      local tarcmd="tar -Hcf ${tarfile} ${list[@]}" #store symlink deref
      ${tarcmd} 2>&1 | grep -v "Removing leading"
      #retun value
      TAR_FILE=${tarfile}
    }

    function same_file() {
      if [ -e $1 ] && [ -e $2 ]; then
        #md5 -q on mac
        hash1=$(md5 -q ${1}); hash2=$(md5 -q ${2})
        if [ "${hash1}" = "${hash2}" ]; then
          true
        else
          echo "$hash1 = $hash2 ?"
          false
        fi
      else
        false
      fi
    }

    function source_dep() {
      local mod_name="$1"
      shift
      local dep_list=("${@}")
      local mods_loaded=("${MOD_LOADED[@]}")
      for dep in "${dep_list[@]}"; do
        echo $dep
      done
    }
  #----------------------


  #----------------------
    function util_keygen() {
      echo "What's the name of the Key (no spaced please) ? ";
      read name;
      echo "What's the email associated with it? ";
      read email;
      `ssh-keygen -t rsa -f ~/.ssh/id_rsa_$name -C "$email"`;
      ssh-add ~/.ssh/id_rsa_$name
      pbcopy < ~/.ssh/id_rsa_$name.pub;
      echo "SSH Key copied in your clipboard";
    }
  #----------------------



  #----------------------
    function xtitle() { 
      echo -en  "\033]0;$*\007" ; 
    }
  #----------------------


  #----------------------
    function colorgrid() {
        def=$(tput colors)
        len=${1:-$def}  
        if command_exists tput && [ ! -z $len ]; then
          for i in $(seq 1 $len); do tput setab $i; echo -n "  $i "; done; tput setab 0; echo
        else
          echo "Error - <tput> command not found"
        fi
    }
  #----------------------


  #----------------------
    function remobj() {
      #echo $1
      if [ -d "$1" ]
        then
          rm -rf $1
      fi
      if [ -f "$1" ]
        then
          rm -f $1
      fi
    }

    function quicksleep(){
      sleep 0.1
    }
  #----------------------


  #----------------------
    function started(){
      quicksleep
      str=$1
      printf "\r${white}${str}... ${reset}" 
    }

    function updated(){
      quicksleep
      str=$1
      printf "\r${green}${pass3}${reset} ${whitedim}${str}${reset}${clear_eol}\n" 
    }

    function problem(){
      quicksleep
      str=$1
      printf "\r${orange}${delta}${reset} ${white}${str}${reset}${clear_eol}\n" 
    }

    function concern(){
      quicksleep
      str=$1
      printf "\r${whitedim}${longbar}${reset} ${whitedim}${str}${reset}${clear_eol}\n" 
    }


    function failed(){
      quicksleep
      str=$1
      printf "\r${red}${fail2}${reset} ${white}${str}${reset}${clear_eol}\n" 
    }
  #----------------------


  #----------------------
    function read_config() {
      ifpipe
      regex='\$\{([a-zA-Z_][a-zA-Z_0-9]*)\}'
      while read line; do
          while [[ "$line" =~ $regex ]]; do
              param="${BASH_REMATCH[1]}"
              line=${line//${BASH_REMATCH[0]}/${!param}}
          done
          echo $line
      done

    }
  #----------------------


  #----------------------
    SPINNER_STAT=""
    function _spinner() {
        # $1 start/stop
        #
        # on start: $2 display message
        # on stop : $2 process exit status
        #           $3 spinner function pid (supplied from stop_spinner)        
        case $1 in
            start)
              i=1
              sp='\|/-'
              delay=0.15
              # calculate the column where spinner and status msg will be displayed
              #let column=$(tput cols)-${#2}-8
              let column=4

              # display message and position the cursor in $column column
              started "${SPINNER_STAT}"
              printf "%${column}s"
              # start spinner
              while :
              do
                printf "\b${sp:i++%${#sp}:1}"
                sleep $delay
              done
              ;;
            stop)
              if [[ -z ${3} ]]; then
                  echo "spinner is not running.."
                  exit 1
              fi
              kill $3 > /dev/null 2>&1
              if [[ $2 -eq 0 ]]; then
                  updated "${SPINNER_STAT} - DONE"
              else
                  failed "${SPINNER_STAT} - FAILED"
              fi
              ;;
            *)
              echo "invalid argument, try {start/stop}"
              exit 1
              ;;
        esac
    }

    function start_spinner {
        # $1 : msg to display
        SPINNER_STAT="${1}"
        _spinner "start" &
        # set global spinner pid
        _sp_pid=$!
        disown
    }

    function stop_spinner {
        # $1 : command exit status
        _spinner "stop" $1 $_sp_pid
        unset _sp_pid
    }


    function spinner() { 
      local pid=$1 
      local msg=${2-""}
      local end=${3-""}
      local delay=0.25 
      while [ $(ps -eo pid | grep $pid) ]; do 
        for i in \| / - \\; do 
          printf ' [%c]\b\b\b\b' $i
          sleep $delay 
        done 
      done 
      printf '\b\b\b\b'
    }

    function download(){
        local url=$1
        echo -n "    "
        wget --progress=dot $url 2>&1 | grep --line-buffered "%" | \
            sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
        echo -ne "\b\b\b\b"
        echo " DONE"
    }


  #----------------------


  #----------------------
    function ifpipe() {
      #echo "pipehi" | ifpipe
      #ifpipe "hi" 
      #ifpipe < ./default.cfg
      if [[ -p /dev/stdin ]]
      then
          echo "stdin is coming from a pipe"
      fi
      if [[ -t 0 ]]
      then
          echo "stdin is coming from the terminal"
      fi
      if [[ ! -t 0 && ! -p /dev/stdin ]]
      then
          echo "stdin is redirected"
      fi
    }
  #----------------------


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
     #clean_up $1
     error "$ERORR_MESSAGE" #TODO:fix to use stderr
     recover
     bashful_usage
     return $1
    }
  #----------------------
