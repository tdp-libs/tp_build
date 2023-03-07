#Sort to remove duplicates
BUILD_DIRS = $(sort $(addprefix $(TARGET_BUILD_DIR)/,$(dir $(SOURCES))))

DEFINES  := $(foreach DEFINE,$(DEFINES),-D$(DEFINE))
INCLUDES += $(foreach INCLUDE,$(INCLUDEPATHS),-I../$(INCLUDE))

DEFINES += -DTP_SDCC

SOBJECTS = $(filter %.rel,$(SOURCES:.S=.rel))
CCOBJECTS = $(filter %.rel,$(SOURCES:.c=.rel))

all_a: $(BUILD_DIRS) $(TARGET_BUILD_DIR).lib

$(TARGET_BUILD_DIR).lib: $(addprefix $(TARGET_BUILD_DIR)/,$(SOBJECTS)) $(addprefix $(TARGET_BUILD_DIR)/,$(CCOBJECTS)) $(addprefix $(TARGET_BUILD_DIR)/,$(CXXOBJECTS))
	"$(AR)" -rc $@ $^

$(TARGET_BUILD_DIR)/%.rel: %.S $(ASM_PART)
	"$(AS)" -c $(CFLAGS) $(CCFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(TARGET_BUILD_DIR)/%.rel: %.c
	"$(CC)" -c $(CFLAGS) $(CCFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(BUILD_DIRS):
	$(MKDIR) $@

