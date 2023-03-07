#Sort to remove duplicates
BUILD_DIRS = $(sort $(addprefix $(TARGET_BUILD_DIR)/,$(dir $(SOURCES))))

CCOBJECTS = $(filter %.o,$(SOURCES:.c=.c.o))
CXXOBJECTS = $(filter %.o,$(SOURCES:.cpp=.cpp.o))

DEFINES  := $(foreach DEFINE,$(DEFINES),-D$(DEFINE))

INCLUDES += $(foreach INCLUDE,$(INCLUDEPATHS),-I../$(INCLUDE))
INCLUDES := $(INCLUDES:-I..//%=-I/%) # Remove ../ from absolute paths

#LIBS :=
LIBS := $(foreach LIB,$(LIBS),-l$(LIB))
LIBS := $(LIBS:-l-l%=-l%)
LIBS := $(LIBS:-l-L%=-L%)
LIBS += $(foreach LIB,$(LIBRARYPATHS),-L../$(LIB))
LIBS := $(LIBS:-L..//%=-L/%) # Remove ../ from absolute paths
LIBS += $(foreach LIB,$(LIBRARIES),$(ROOT)$(BUILD_DIR)$(LIB).a)

ifeq ($(TEMPLATE), app)

all_a: $(BUILD_DIRS) $(RTARGET_BUILD_DIR)/$(TARGET)

$(TARGET_BUILD_DIR)/$(TARGET): $(addprefix $(TARGET_BUILD_DIR)/,$(CCOBJECTS)) $(addprefix $(TARGET_BUILD_DIR)/,$(CXXOBJECTS))
	pwd
	"$(CXX)" $^ $(LIBS) $(LFLAGS) -o $@ 

endif

ifeq ($(TEMPLATE), lib)

all_a: $(BUILD_DIRS) $(TARGET_BUILD_DIR).a

$(TARGET_BUILD_DIR).a: $(addprefix $(TARGET_BUILD_DIR)/,$(CCOBJECTS)) $(addprefix $(TARGET_BUILD_DIR)/,$(CXXOBJECTS))
	"$(AR)" rcs $@ $^

endif

$(TARGET_BUILD_DIR)/%.c.o: %.c
	"$(CC)" -c $(CFLAGS) $(CCFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(TARGET_BUILD_DIR)/%.cpp.o: %.cpp
	"$(CXX)" -c $(CFLAGS) $(CXXFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(BUILD_DIRS):
	$(MKDIR) $@


#UNIQUE_INCLUDEPATHS = $(call uniq,$(INCLUDEPATHS))


