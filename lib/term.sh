#!/usr/bin/env bash


#----------------------
  pass='\xE2\x9C\x93';
  pass2='\xE2\x9C\x94';
  pass3='\xE2\x88\x9A';
  fail='\xE2\x9C\x97';
  fail2='\xE2\x9C\x95';
  arrow='\xE2\x9E\x9C';
  delta='\xE2\x96\xB3';

  # if command_exists tput && [ ! -z $len ]; then

  #back
  bold=$(tput bold)
  underline=$(tput sgr 0 1)
  clear_eol=$(tput el)
  #el(from curr) el1(from beggining) el2(whole line)
  reset=$(tput sgr0)

  purple=$(tput setaf 5)
  red=$(tput setaf 1)
  yellow=$(tput setaf 11)
  green=$(tput setaf 2)
  orange=$(tput setaf 3)
  blue=$(tput setaf 12)
  cyan=$(tput setaf 14)
  grey=$(tput setaf 247)
  white=$(tput setaf 15)
  whitedim=$(tput setaf 243)
  liner="---------------------------------------------------------"

#----------------------


#----------------------
alias line="echo ${liner}"

function log()   { printf '%s\n' "$*"; }
function error() { log "ERROR: $*" >&2; }
function fatal() { error "$@"; exit 1; }

#----------------------

function color_support() {
  support_colors=$(tput colors)
  if [ $support_colors -ge 8 ]; then
    if [ $1 -gt 1 ]; then
      if [ -t 1 ]; then use_color=1; else use_color=0; fi 
    else
      use_color=${1-1} #defualt is 1/on
    fi
  else
    use_color=0
  fi
}


function header() { 
  local color=${!2-$grey}
  echo -e "\n${bold}${color}==========  $1  ==========${reset}\n"  
}

function pass() { 
  printf "${green}${pass2} %s${reset}\n" "$@"
  return 0
}

function warn() { 
  printf "${orange}${delta} %s${reset}\n" "$@"
  return 1
}

function fail() { 
  printf "${red}${fail2}${fail2} %s${reset}\n" "$@"
  return 1
}

function note() { 
  printf "${blue}${arrow} ${underline}${bold}${blue}Note:${reset} ${blue}%s${reset}\n" "$@"
  return 1
}

function msg(){
  echo -e ${1}
}

function wait() { 
  printf "${grey}... %s${reset}\n" "$@"
  return 1
}


function info() { 
  printf "${blue}%s${reset}\n" "$@"
  return 1
}

function red(){
  echo -e "${red}${1}${reset}"
}

function green(){
  echo -e "${green}${1}${reset}"
}

function orange(){
  echo -e "${orange}${1}${reset}"
}

function cyan(){
  echo -e "${cyan}${1}${reset}"
}

function grey(){
  echo -e "${grey}${1}${reset}"
}

function purple(){
  echo -e "${purple}${1}${reset}"
}
