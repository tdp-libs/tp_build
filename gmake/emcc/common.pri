AR = $(CROSS_COMPILE)emcc
CC = $(CROSS_COMPILE)emcc
CXX = $(CROSS_COMPILE)emcc
CPP = $(CROSS_COMPILE)emcc
NM = $(CROSS_COMPILE)nm
LKELF = $(CROSS_COMPILE)emcc
OBJCOPY = $(CROSS_COMPILE)objcopy
RM=rm -Rf
MKDIR=mkdir -p
HOST_CXX=g++

CXXFLAGS += -std=c++1z
LDFLAGS += -std=c++1z
INCLUDES += -I/opt/tools/emsdk-portable/include/

DEFINES += TP_EMSCRIPTEN
