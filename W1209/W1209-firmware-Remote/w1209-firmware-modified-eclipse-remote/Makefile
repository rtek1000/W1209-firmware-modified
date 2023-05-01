##
## Edited manually by RTEK1000 (Mar/31/2023)
## Based in: https://github.com/mister-grumbler/w1209-firmware/blob/master/Makefile
##

BuildDirectory         :=Release
IncludeDirectory       :=Core/Inc
IncludeSwitch          :=-I
LibrarySwitch          :=-l stm8
LibraryPathSwitch      :=-L
LinkerName             :=/usr/bin/sdcc
LinkOptions            :=--out-fmt-ihx -mstm8
MakeDirCommand         :=mkdir -p
mkfile_path            :=$(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir             :=$(dir $(mkfile_path))
ObjectSuffix           :=.rel
OutputSwitch           :=-o
ObjectSwitch           :=-o
ProjectName            :=$(project_name)
OutputFile             :=$(BuildDirectory)/$(ProjectName).ihx
OutputFileBin          :=$(BuildDirectory)/$(ProjectName).bin
SourceDirectory        :=Core/Src
SourceDirectoryRule    :=$(SourceDirectory)/
GccSourceDirectory     :=$(SourceDirectory)
IncludePath            :=$(IncludeSwitch)$(SourceDirectory) $(IncludeSwitch)$(IncludeDirectory)
SourceSwitch           :=-c
SOURCES                :=$(call rwildcard,$(SourceDirectory),*.c)

##
## Common variables
## CC and CFLAGS can be overriden using an environment variables
##
CC                     := /usr/bin/sdcc
CFLAGS                 := $(LibrarySwitch) -mstm8


##
## User defined environment variables
##
list_files_c           := $(notdir $(wildcard $(SourceDirectory)/*.c))
list_files_rel         := $(addprefix $(BuildDirectory)/,$(patsubst %,%.rel,$(list_files_c)))
		
##
## Main Build Targets 
##
.PHONY: clean makeBuildDirectory all

all:
	@echo Compiling files:;
	@for i in $(list_files_c); do \
		echo Compiling: $$i to $$i.rel; \
		$(CC) \
		$(SourceSwitch) $(SourceDirectoryRule)"$$i" \
		$(CFLAGS) \
		$(ObjectSwitch)$(BuildDirectory)/$$i$(ObjectSuffix) \
		$(IncludePath); \
	done
	@echo Done.;
	@echo Linking all *.rel files. Generating $(project_name).ihx file:;
	$(LinkerName) $(OutputSwitch)$(OutputFile) $(list_files_rel) $(LinkOptions)
	@echo Done.;
	@echo Generating $(project_name).bin file:;
	objcopy -Iihex -Obinary $(OutputFile) $(OutputFileBin)
	@echo Done.;

##
## Make Build Directory
##

makeBuildDirectory:
	@echo Checking build directory.
	@test -d $(BuildDirectory) || $(MakeDirCommand) $(BuildDirectory)

$(BuildDirectory)/.d:
	@test -d $(BuildDirectory) || $(MakeDirCommand) $(BuildDirectory)
	@echo Done.;

##
## Clean
##
clean:
	@echo Cleaning up build directory...
	$(RM) $(BuildDirectory)/*.*
	@echo Done.;