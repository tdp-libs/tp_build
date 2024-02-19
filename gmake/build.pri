ROOT = ./
TP_BUILD_TYPE = static
-include $(ROOT)toolchain.pri

TP_GIT_BRANCH := $(shell cd tp_build ; tp_git/extract_git_branch.sh)
TP_GIT_COMMIT := $(shell cd tp_build ; tp_git/extract_git_commit.sh)
TP_GIT_COMMIT_NUMBER := $(shell cd tp_build ; tp_git/extract_git_commit_number.sh)

export TP_GIT_BRANCH
export TP_GIT_COMMIT
export TP_GIT_COMMIT_NUMBER

include $(ROOT)tp_build/gmake/$(TP_BUILD_TYPE)/common.pri

# Bring in project wide config
include $(ROOT)project.inc
include $(ROOT)$(PROJECT_DIR)/project.conf

export PROJECT_DIR

include $(ROOT)$(PROJECT_DIR)/submodules.pri
include $(ROOT)tp_build/gmake/$(TP_BUILD_TYPE)/common.pri

TARGET_BUILD_DIR := $(shell realpath -m --relative-to . $(ROOT)$(BUILD_DIR)$(TARGET))

include $(ROOT)tp_build/gmake/$(TP_BUILD_TYPE)/build.pri
