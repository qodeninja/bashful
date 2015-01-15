#!/usr/bin/env bash


source "./inc/terminal-exports.sh"
source "./lib/common.sh"

#----------------------
alias line="echo ${liner}"

#----------------------

function color_support() {
  support_colors=$(tput colors)
  if [ $support_colors -ge 8 ]; then
    if [ $1 -gt 1 ]; then
      if [ -t 1 ]; then OPT_COLOR=1; else OPT_COLOR=0; fi 
    else
      OPT_COLOR=${1-1} #defualt is 1/on
    fi
  else
    OPT_COLOR=0
  fi
}

function strip_escape(){
  sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"
}

function header() { 
  local color=${!2-$grey}
  console "\n${bold}${color}==========  $1  ==========${reset}\n"  
}

function pass() { 
  console "${green}${pass2} %s${reset}\n" "$@"
  return 0
}

function warn() { 
  console "${orange}${delta} %s${reset}\n" "$@"
  return 1
}

function fail() { 
  console "${red}${fail2}${fail2} %s${reset}\n" "$@"
  return 1
}

function note() { 
  console "${blue}${arrow} ${underline}${bold}${blue}Note:${reset} ${blue}%s${reset}\n" "$@"
  return 1
}


function wait() { 
  console "${grey}... %s${reset}\n" "$@"
  return 1
}


function info() { 
  console "${blue}%s${reset}\n" "$@"
  return 1
}

function red(){
  console "${red}${1}${reset}"
}

function green(){
  console "${green}${1}${reset}"
}

function orange(){
  console "${orange}${1}${reset}"
}

function cyan(){
  console "${cyan}${1}${reset}"
}

function grey(){
  console "${grey}${1}${reset}"
}

function purple(){
  console "${purple}${1}${reset}"
}
