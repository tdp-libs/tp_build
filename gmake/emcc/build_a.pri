#Sort to remove duplicates
BUILD_DIRS = $(sort $(addprefix $(TARGET_BUILD_DIR)/,$(dir $(SOURCES))))

CCOBJECTS = $(addprefix $(TARGET_BUILD_DIR)/,$(filter %.bc,$(SOURCES:.c=.c.bc)))
CXXOBJECTS = $(addprefix $(TARGET_BUILD_DIR)/,$(filter %.bc,$(SOURCES:.cpp=.cpp.bc)))
QRCSOURCES = $(addprefix $(TARGET_BUILD_DIR)/,$(filter %.cpp,$(TP_RC:.qrc=.qrc.cpp)))
QRCOBJECTS = $(filter %.bc,$(QRCSOURCES:.cpp=.cpp.bc))

DEFINES  := $(foreach DEFINE,$(DEFINES),-D$(DEFINE))
INCLUDES += $(sort $(foreach INCLUDE,$(INCLUDEPATHS),-I../$(INCLUDE)))
INCLUDES += $(sort $(foreach INCLUDE,$(SYSTEM_INCLUDEPATHS),-I$(INCLUDE)))

TP_RC_CMD = $(ROOT)$(BUILD_DIR)tp_rc
TP_RC_SRC = $(ROOT)tp_build/tp_rc/tp_rc.cpp

all_a: $(BUILD_DIRS) $(TARGET_BUILD_DIR).bc

$(TARGET_BUILD_DIR).bc: $(CCOBJECTS) $(CXXOBJECTS) $(QRCOBJECTS)
	"$(AR)" -r $^ -o $@

$(TARGET_BUILD_DIR)/%.c.bc: %.c
	"$(CC)" -c $(CFLAGS) $(CCFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(TARGET_BUILD_DIR)/%.cpp.bc: %.cpp
	"$(CXX)" -c $(CFLAGS) $(CXXFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(TARGET_BUILD_DIR)/%.qrc.cpp.bc: %.qrc $(TP_RC_CMD)
	"$(TP_RC_CMD)" --compile "$<" "$(basename $@)" $(basename $(basename $(notdir $<)))
	"$(CXX)" -c $(CFLAGS) $(CXXFLAGS) $(INCLUDES) $(DEFINES) "$(basename $@)" -o $@

$(BUILD_DIRS):
	$(MKDIR) $@

$(TP_RC_CMD): $(TP_RC_SRC)
	$(HOST_CXX) -std=gnu++1z -O2 $(TP_RC_SRC) -o $(TP_RC_CMD)
