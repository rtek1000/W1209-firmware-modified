#! /bin/sh

## remove files before compile, to get errors
make clean

## https://unix.stackexchange.com/questions/31414/how-can-i-pass-a-command-line-argument-into-a-shell-script
## ./myscript myargument
## myargument becomes $1 inside myscript.

make project_name=$1

## Instructions for Empty C Project
## Add compiler Make for Makefile
## Select the Project in Project Explorer
## Project-Properties (Alt+Enter)
## - Go to Builders
## - Uncheck all native builders (CDT or Scanner etc)
## - Click in New
## - - Click in OK (Program)
## - - Put a name ("Make"???)
## - - In Location put: /usr/bin/sh
## - - In Working directory put: ${project_loc}
## - - In Arguments put: compile.sh ${project_name}
## - - Click in OK
## - - Click in Apply and Close
##
## Instructions for STM8S003?3
## - - Add programmer STM8SFLASH
## Select the Project in Project Explorer
## Project-Properties (Alt+Enter)
## - Go to Builders
## - Uncheck all native builders (CDT or Scanner etc)
## - Click in New
## - - Click in OK (Program)
## - - Put a name ("STM8SFLASH"???)
## - - In Location put: /usr/local/bin/stm8flash
## - - In Working directory put: ${project_loc}/Release
## - - In Arguments put: -c stlinkv2 -p stm8s003?3 -w ${project_name}.ihx
## - - Click in OK
## - - Click in Apply and Close
