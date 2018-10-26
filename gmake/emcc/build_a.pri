ROOT = ../

include $(ROOT)tdp_build/gmake/emcc/common.pri

# Bring in project wide config
include $(ROOT)project.inc
include $(ROOT)$(PROJECT_DIR)/project.conf

# Bring in the dependencies tree 
include dependencies.pri
include $(ROOT)tdp_build/gmake/parse_dependencies.pri

# Bring in the source files for this module
include vars.pri


#Sort to remove duplicates
BUILD_DIRS = $(sort $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(dir $(SOURCES))))

CCOBJECTS = $(filter %.bc,$(SOURCES:.c=.c.bc))
CXXOBJECTS = $(filter %.bc,$(SOURCES:.cpp=.cpp.bc))

DEFINES  := $(foreach DEFINE,$(DEFINES),-D$(DEFINE))
INCLUDES += $(foreach INCLUDE,$(INCLUDEPATHS),-I../$(INCLUDE))

all: $(BUILD_DIRS) $(ROOT)$(BUILD_DIR)$(TARGET).bc

$(ROOT)$(BUILD_DIR)$(TARGET).bc: $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(CCOBJECTS)) $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(CXXOBJECTS))
	"$(AR)" $^ -o $@

$(ROOT)$(BUILD_DIR)$(TARGET)/%.c.bc: %.c
	"$(CC)" -c $(CFLAGS) $(CCFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(ROOT)$(BUILD_DIR)$(TARGET)/%.cpp.bc: %.cpp
	"$(CXX)" -c $(CFLAGS) $(CXXFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(BUILD_DIRS):
	$(MKDIR) $@

