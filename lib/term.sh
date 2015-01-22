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
      return 0
    }

    function fail() { 
      console "${red}${fail2} %s${reset}\n" "$@"
      return 1
    }

    function note() { 
      console "${blue}${arrow} ${underline}${bold}${blue}Note:${reset} ${blue}%s${reset}\n" "$@"
      return 0
    }


    function wait() { 
      console "${grey}... %s${reset}\n" "$@"
      return 0
    }


    function info() { 
      console "${blue}${redo}%s${reset}\n" "$@"
      return 0
    }
  #----------------------
  
  #----------------------

    function label(){
      quicksleep
      str=$1
      printf "\r${purple}${str}${reset}${clear_eol}" 
    }

    function labeldone(){
      quicksleep
      str=$1
      printf "\r${whitedim}${str}${reset}${clear_eol}" 
    }

    function new_set(){
      lines=0
    }

    function end_set(){
      qline
      lines=0
    }


    function started(){
      #lines=$((lines + 1))
      quicksleep
      str=$1
      quiet=$2
      printf "\r${white}${str}... ${reset}" 
    }

    function updated(){
      quicksleep
      str=$1
      quiet=$2
      printf "\r${green}${pass3}${reset} ${whitedim}${str}${reset}${clear_eol}\n" 
    }

    function problem(){
      quicksleep
      str=$1
      quiet=$2
      printf "\r${orange}${delta}${reset} ${white}${str}${reset}${clear_eol}\n" 
    }

    function concern(){
      quicksleep
      str=$1
      quiet=$2
      printf "\r${whitedim}${longbar}${reset} ${whitedim}${str}${reset}${clear_eol}\n" 
    }


    function failed(){
      quicksleep
      str=$1
      quiet=$2
      printf "\r${red}${fail2}${reset} ${white}${str}${reset}${clear_eol}\n" 
    }

    function rline(){
      quicksleep
      printf "${clear_bol}"
    }

    function dline(){
      quicksleep
      printf "\r${up_line}${clear_eol}"
    }

    function qline(){
      quicksleep
       local counter=0
       while [ $counter -lt $lines ]; do
         printf "\r${up_line}${clear_eol}"
         counter=$((counter + 1))
       done
      
    }
  #----------------------