ROOT = ../

TP_BUILD_TYPE = emcc
-include $(ROOT)toolchain.pri

include $(ROOT)tp_build/gmake/$(TP_BUILD_TYPE)/common.pri

# Bring in project wide config
include $(ROOT)project.inc
include $(ROOT)$(PROJECT_DIR)/project.conf

# Bring in the dependencies tree 
include dependencies.pri
include $(ROOT)tp_build/gmake/parse_dependencies.pri

# Bring in the source files for this module
include vars.pri

#All must be the first target in the makefile
.PHONY: all
all: pages tp_copy all_a

include $(ROOT)tp_build/gmake/common/pages.pri
include $(ROOT)tp_build/gmake/common/tp_copy.pri

include $(ROOT)tp_build/gmake/$(TP_BUILD_TYPE)/build_a.pri

