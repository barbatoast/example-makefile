##############################################################################
# Makefile
#
# Description:
#    Build binaries and place them in the build folder.
#
# Usage:
#    make RULES_FILE=rules-ubuntu-amd64-debug.mk
#    or
#    make BOARD=ubuntu ARCH=amd64 VER=all MODE=debug
#
# Build Script usage
#    ./build.sh all - builds the project for all of the rules in order
#    ./build.sh allFast - builds the project for all of the rules with -j option to parallelize
#    ./build.sh clean - cleans the build directory
#
# To add a new module:
#    - add a module to modules_to_build list below
#    - add a module.mk to your module folder, see existing modules for example
#
##############################################################################

# get the list of modules to build
modules:=$(shell find . -name project.mk)

# get a list of source files
allsources:=$(subst ./,,$(shell find . -name '*.c'))

# set include dir
WORKSPACE:=$(shell pwd)
PROJECT_INCLUDE_DIR:=src/include

# include rules for building on this platform
RULES_FILE?=rules/rules-ubuntu-amd64-debug.mk
include $(RULES_FILE)

######################################
# Modules for all to build
######################################
projects_to_build:=packetdump

#  filter out sources that shouldn't get compiled
o_path_sources:=$(filter-out $(exclude_source), $(allsources))

.PHONY: all

all: alldebug $(BUILD) $(projects_to_build)
	@echo "####################################################################"
	@echo "################### FINISHED BUILDING PROJECT ######################"
	@echo "####################################################################"

alldebug:
	@echo "WORKSPACE = $(WORKSPACE)"
	@echo "projects to build = $(projects_to_build)"

$(BUILD):
	@echo "#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#"
	@echo "#>>> Building $@"
	@echo "#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#"
	-mkdir -p $(BUILD)

# include rules for building modules
include $(modules)

clean:
	@echo "####################################################################"
	@echo "################### STARTED CLEANING PROJECT #######################"
	@echo "####################################################################"
	-rm -rf $(BUILD)
	@echo "####################################################################"
	@echo "################### FINISHED CLEANING PROJECT ######################"
