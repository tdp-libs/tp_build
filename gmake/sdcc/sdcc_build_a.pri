
include ../tdp_build/uc/sdcc_common.pri

#Sort to remove duplicates
BUILD_DIRS = $(sort $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(dir $(SOURCES))))

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

