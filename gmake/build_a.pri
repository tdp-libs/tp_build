ROOT = $(CURDIR)/../

TP_BUILD_TYPE = emcc
-include $(ROOT)toolchain.pri

include $(ROOT)tp_build/gmake/$(TP_BUILD_TYPE)/common.pri

# Bring in project wide config
include $(ROOT)project.inc
include $(ROOT)$(PROJECT_DIR)/project.conf

ifeq ($(BUILD_DIR),)
BUILD_DIR = $(DEFAULT_BUILD_DIR)
export BUILD_DIR
endif

# Bring in the dependencies tree 
include dependencies.pri
include $(ROOT)tp_build/gmake/parse_dependencies.pri

# Bring in the source files for this module
include vars.pri

DEFINES += TP_GIT_BRANCH="$(TP_GIT_BRANCH)"
DEFINES += TP_GIT_COMMIT="$(TP_GIT_COMMIT)"
DEFINES += TP_GIT_COMMIT_NUMBER="$(TP_GIT_COMMIT_NUMBER)"

#All must be the first target in the makefile
.PHONY: all
all: pages tp_copy all_a

TARGET_BUILD_DIR := $(shell realpath --relative-to . $(ROOT)$(BUILD_DIR)$(TARGET))

include $(ROOT)tp_build/gmake/common/pages.pri
include $(ROOT)tp_build/gmake/common/tp_copy.pri

include $(ROOT)tp_build/gmake/$(TP_BUILD_TYPE)/build_a.pri

