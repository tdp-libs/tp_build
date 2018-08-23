ROOT = ../

include $(ROOT)tdp_build/gmake/sdcc/common.pri

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

DEFINES  := $(foreach DEFINE,$(DEFINES),-D$(DEFINE))
INCLUDES += $(foreach INCLUDE,$(INCLUDEPATHS),-I../$(INCLUDE))

DEFINES += -DTDP_SDCC

SOBJECTS = $(filter %.rel,$(SOURCES:.S=.rel))
CCOBJECTS = $(filter %.rel,$(SOURCES:.c=.rel))

all: $(BUILD_DIRS) $(ROOT)$(BUILD_DIR)$(TARGET).lib

$(ROOT)$(BUILD_DIR)$(TARGET).lib: $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(SOBJECTS)) $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(CCOBJECTS)) $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(CXXOBJECTS))
	"$(AR)" -rc $@ $^

$(ROOT)$(BUILD_DIR)$(TARGET)/%.rel: %.S $(ASM_PART)
	"$(AS)" -c $(CFLAGS) $(CCFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(ROOT)$(BUILD_DIR)$(TARGET)/%.rel: %.c
	"$(CC)" -c $(CFLAGS) $(CCFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(BUILD_DIRS):
	$(MKDIR) $@

