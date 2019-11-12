#Sort to remove duplicates
BUILD_DIRS = $(sort $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(dir $(SOURCES))))

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

all_a: $(BUILD_DIRS) $(ROOT)$(BUILD_DIR)$(TARGET)/$(TARGET)

$(ROOT)$(BUILD_DIR)$(TARGET)/$(TARGET): $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(CCOBJECTS)) $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(CXXOBJECTS))
	pwd
	"$(CXX)" $^ $(LIBS) $(LFLAGS) -o $@ 

endif

ifeq ($(TEMPLATE), lib)

all_a: $(BUILD_DIRS) $(ROOT)$(BUILD_DIR)$(TARGET).a

$(ROOT)$(BUILD_DIR)$(TARGET).a: $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(CCOBJECTS)) $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/,$(CXXOBJECTS))
	"$(AR)" rcs $@ $^

endif

$(ROOT)$(BUILD_DIR)$(TARGET)/%.c.o: %.c
	"$(CC)" -c $(CFLAGS) $(CCFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(ROOT)$(BUILD_DIR)$(TARGET)/%.cpp.o: %.cpp
	"$(CXX)" -c $(CFLAGS) $(CXXFLAGS) $(INCLUDES) $(DEFINES) $< -o $@

$(BUILD_DIRS):
	$(MKDIR) $@


#UNIQUE_INCLUDEPATHS = $(call uniq,$(INCLUDEPATHS))


