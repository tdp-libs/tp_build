ROOT = ./

TDP_BUILD_TYPE = emcc
-include $(ROOT)toolchain.pri

include $(ROOT)tdp_build/gmake/$(TDP_BUILD_TYPE)/build.pri


