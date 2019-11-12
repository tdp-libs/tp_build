ROOT = ./

TP_BUILD_TYPE = static
-include $(ROOT)toolchain.pri

include $(ROOT)$(PROJECT_DIR)/submodules.pri
include $(ROOT)tp_build/gmake/$(TP_BUILD_TYPE)/common.pri
include $(ROOT)tp_build/gmake/$(TP_BUILD_TYPE)/build.pri
