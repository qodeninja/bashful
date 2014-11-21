#!/usr/bin/env bash

#----------------------

  pass='\xE2\x9C\x93';
  fail='\xE2\x9C\x97';
  arrow='\xE2\x9E\x9C';
  delta='\xE2\x96\xB3';

  bold=$(tput bold)
  underline=$(tput sgr 0 1)
  reset=$(tput sgr0)

  purple=$(tput setaf 5)
  red=$(tput setaf 1)
  yellow=$(tput setaf 11)
  green=$(tput setaf 2)
  orange=$(tput setaf 3)
  blue=$(tput setaf 12)
  grey=$(tput setaf 238)
#----------------------


#----------------------

function header() { 
  printf "\n${bold}${grey}==========  %s  ==========${reset}\n" "$@"  
}

function pass() { 
  printf "${green}${pass} %s${reset}\n" "$@"
  return 0
}

function warn() { 
  printf "${orange}${delta} %s${reset}\n" "$@"
  return 1
}

function fail() { 
  printf "${red}${fail} %s${reset}\n" "$@"
  return 1
}

function info() { 
  printf "${blue}${arrow} ${underline}${bold}${blue}Note:${reset} ${blue}%s${reset}\n" "$@"
  return 1
}
