ROOT = ./

TP_BUILD_TYPE = static
-include $(ROOT)toolchain.pri

include $(ROOT)tp_build/gmake/$(TP_BUILD_TYPE)/common.pri

# Bring in project wide config
include $(ROOT)project.inc
include $(ROOT)$(PROJECT_DIR)/project.conf

include $(ROOT)$(PROJECT_DIR)/submodules.pri
include $(ROOT)tp_build/gmake/$(TP_BUILD_TYPE)/common.pri
include $(ROOT)tp_build/gmake/$(TP_BUILD_TYPE)/build.pri
