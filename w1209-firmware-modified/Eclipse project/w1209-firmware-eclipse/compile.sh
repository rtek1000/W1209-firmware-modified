#! /bin/sh

## remove files before compile, to get errors
make clean

make

## Instructions for Empty C Project
## Add compiler Make for Makefile
## Select the Project in Project Explorer
## Project-Properties (Alt+Enter)
## - Go to Builders
## - Uncheck all native builders (CDT or Scanner etc)
## - Click in New
## - - Click in OK (Program)
## - - Put a name ("make_w1209")
## - - In Location put: /usr/bin/sh
## - - In Working directory put: ${project_loc}
## - - In Arguments put: compile.sh
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
## - - Put a name ("flash_w1209")
## - - In Location put: /usr/local/bin/stm8flash
## - - In Working directory put: ${project_loc}/Build
## - - In Arguments put: -c stlinkv2 -p stm8s003?3 -w thermostat.ihx
## - - Click in OK
## - - Click in Apply and Close
##
## Select the Project in Project Explorer
## Project-Properties (Alt+Enter)
## - Go to Builders
## [x] make_w1209
## [ ] flash_w1209
##
## Configure Run As
## Menu Run
## Click in Run Configurations
## Add new launch configuration in Launch Group
## Set name ("launch_w1209")
## Click in Add
## Select "flash_w1209" in "Program"
## Click Ok
## Click Apply and Close
##
## Usage
## Click in Build 'Release' icon (Hammer)
## Click in Run icon near menu "Edit" to burn the w1209