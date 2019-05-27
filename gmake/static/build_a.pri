UNIQUE_INCLUDEPATHS = $(call uniq,$(INCLUDEPATHS))

#Sort to remove duplicates
BUILD_DIRS = $(sort $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(dir $(SOURCES))))

CCOBJECTS = $(filter %.o,$(SOURCES:.c=.c.o))
CXXOBJECTS = $(filter %.o,$(SOURCES:.cpp=.cpp.o))

DEFINES  := $(foreach DEFINE,$(DEFINES),-D$(DEFINE))
INCLUDES += $(foreach INCLUDE,$(UNIQUE_INCLUDEPATHS),-I../$(INCLUDE))

all_a: $(BUILD_DIRS) $(ROOT)$(BUILD_DIR)$(TARGET).a

$(ROOT)$(BUILD_DIR)$(TARGET).a: $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(CCOBJECTS)) $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(CXXOBJECTS))
	"$(AR)" rcs $@ $^

$(ROOT)$(BUILD_DIR)$(TARGET)/%.c.o: %.c
	"$(CC)" -c $(CFLAGS) $(CCFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(ROOT)$(BUILD_DIR)$(TARGET)/%.cpp.o: %.cpp
	"$(CXX)" -c $(CFLAGS) $(CXXFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(BUILD_DIRS):
	$(MKDIR) $@

