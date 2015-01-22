#!/usr/bin/env bash


#----------------------
  pass='\xE2\x9C\x93';
  pass2='\xE2\x9C\x94';
  pass3='\xE2\x88\x9A';
  fail='\xE2\x9C\x97';
  fail2='\xE2\x9C\x95';
  arrow='\xE2\x9E\x9C';
  delta='\xE2\x96\xB3';
  longbar='\xE2\x80\x95';
  circle='\xE2\x97\xAF';
  info='\xE2\x93\x98';
  redo='\xE2\x86\xBB ';
  #arr1 0xE2 0x87 0xA7
  #arr2 0xE2 0x87 0xAA
  #redo 0xE2 0x86 0xBB 


  #back
  bold=$(tput bold)
  underline=$(tput sgr 0 1)
  clear_eol=$(tput el)
  clear_bol=$(tput el1)
  del_line=$(tput dl1)
  up_line=$(tput cuu1)
  #el(from curr) el1(from beggining) el2(whole line)
  reset=$(tput sgr0)

  purple=$(tput setaf 5)
  red=$(tput setaf 1)
  green=$(tput setaf 2)
  yellow=$(tput setaf 11)
  orange=$(tput setaf 3)
  blue=$(tput setaf 12)
  cyan=$(tput setaf 14)
  grey=$(tput setaf 247)
  white=$(tput setaf 15)
  whitedim=$(tput setaf 243)
  liner="---------------------------------------------------------"

#----------------------