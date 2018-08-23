ROOT = ./

include $(ROOT)tdp_build/gmake/static/common.pri

# Bring in project wide config
include $(ROOT)project.inc
include $(ROOT)$(PROJECT_DIR)/project.conf

include $(ROOT)$(PROJECT_DIR)/submodules.pri

# Bring in the dependencies tree 
include $(PROJECT_DIR)/dependencies.pri
include $(ROOT)tdp_build/gmake/parse_dependencies.pri

UNIQUE_LIBRARIES = $(call uniq,$(LIBRARIES))

SUB_AR = $(addsuffix .a,$(addprefix $(ROOT)$(BUILD_DIR),$(UNIQUE_LIBRARIES)))
PUB_AR = $(ROOT)$(BUILD_DIR)lib$(PUB_TARGET).a
PUB_O  = $(ROOT)$(BUILD_DIR)$(PUB_TARGET).o

OBJ_DIR = $(ROOT)$(BUILD_DIR)/obj/

all: $(PUB_AR)

$(PUB_AR): $(BUILD_DIR) $(SUBDIRS) $(SUB_AR)
	"$(LD)" --whole-archive -r $(SUB_AR) -o $(PUB_O)
	"$(AR)" rcs $@ $(PUB_O)

$(BUILD_DIR): 
	$(MKDIR) $(BUILD_DIR) 

$(SUBDIRS): force_look
	for d in $@ ; do (cd $$d ; make -j4 ) ; done

install:
	-for d in $(SUBDIRS) ; do (cd $$d; $(MAKE) install ); done

clean:
	-for d in $(SUBDIRS); do (cd $$d; $(MAKE) clean ); done

force_look :
	true

