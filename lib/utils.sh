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
      echo -e $(date +%m%d_%I%m%S_%a)
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
    # function inpath() {
    #   for d; do

    #   done
    # }
    

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
      #local var_re="${1:-.*}"
      #eval $( set | awk -v FS="=" -v VAR="$var_re" '$1 ~ VAR { print "unset", $1 }' )
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
    # function util_extract() {
    #   if [ -f $1 ] ; then
    #     case $1 in
    #       *.tar.bz2)   tar xvjf $1    ;;
    #       *.tar.gz)    tar xvzf $1    ;;
    #       *.tgz)       tar xvzf $1    ;;
    #       *.bz2)       bunzip2 $1     ;;
    #       *.rar)       unrar x $1     ;;
    #       *.gz)        gunzip $1      ;;
    #       *.tar)       tar xvf $1     ;;
    #       *.tbz2)      tar xvjf $1    ;;
    #       *.tgz)       tar xvzf $1    ;;
    #       *.zip)       unzip $1       ;;
    #       *.Z)         uncompress $1  ;;
    #       *.7z)        7z x $1        ;;
    #       *)           echo "'$1' cannot be extracted via >extract<" ;;
    #     esac
    #   else
    #     echo "'$1' is not a valid file"
    #   fi
    # }

    function util_tarup() {
      local FILE_ID=$1
      shift
      local FILE_LIST=("${@}")
      local FILE_TIME="$(filetime)"
      local TAR_FILE="${FILE_ID}${FILE_TIME}.tar"

      #tar -cvf ${TAR_FILE} bashrc.d/
    }

    function same_file() {

      if [ -e $1 ] && [ -e $2 ]; then
        #md5 -q on mac
        hash1=$(md5 -q ${1})
        hash2=$(md5 -q ${2})
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
      sleep 0.2
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
    function spinner() {
      PROC=$1
      while [ -d /proc/$PROC ];do
        echo -n '/^H' ; sleep 0.05
        echo -n '-^H' ; sleep 0.05
        echo -n '\^H' ; sleep 0.05
        echo -n '|^H' ; sleep 0.05
      done
      return 0
    }

    function spinner2(){
        SP_STRING=${2:-"'|/=\'"}
        while [ -d /proc/$1 ]
        do
            printf "$SP_COLOUR\e7  %${SP_WIDTH}s  \e8\e[0m $SP_STRING"
            sleep ${SP_DELAY:-.2}
            #SP_STRING=${SP_STRING#"${SP_STRING%?}"}${SP_STRING%?}
        done

        ## Adjust to taste (or leave empty)
        # SP_COLOUR="\e[37;41m"
        # SP_WIDTH=1.1  ## Try: SP_WIDTH=5.5
        # SP_DELAY=.2

        # sleep 3 &
        # spinner "$!" '.o0Oo'
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
