#Sort to remove duplicates
BUILD_DIRS = $(sort $(addprefix $(TARGET_BUILD_DIR)/,$(dir $(SOURCES))))

DEFINES  := $(foreach DEFINE,$(DEFINES),-D$(DEFINE))
INCLUDES += $(foreach INCLUDE,$(INCLUDEPATHS),-I../$(INCLUDE))

SOBJECTS = $(filter %.o,$(SOURCES:.S=.S.o))
CCOBJECTS = $(filter %.o,$(SOURCES:.c=.c.o))
CXXOBJECTS = $(filter %.o,$(SOURCES:.cpp=.cpp.o))

all_a: $(BUILD_DIRS) $(TARGET_BUILD_DIR).a

$(TARGET_BUILD_DIR).a: $(addprefix $(TARGET_BUILD_DIR)/,$(SOBJECTS)) $(addprefix $(TARGET_BUILD_DIR)/,$(CCOBJECTS)) $(addprefix $(TARGET_BUILD_DIR)/,$(CXXOBJECTS))
	"$(AR)" rcs $@ $^
	"$(NM)" $@ > $@.txt

$(TARGET_BUILD_DIR)/%.S.o: %.S $(ASM_PART)
	"$(CPP)" $(INCLUDES) $(DEFINES) $< > $@.s
	"$(CC)" -c $(CFLAGS) $(CCFLAGS) $(INCLUDES) $(DEFINES) $@.s -o $@

$(TARGET_BUILD_DIR)/%.c.o: %.c
	"$(CC)" -c $(CFLAGS) $(CCFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(TARGET_BUILD_DIR)/%.cpp.o: %.cpp
	"$(CXX)" -c $(CFLAGS) $(CXXFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(BUILD_DIRS):
	$(MKDIR) $@

