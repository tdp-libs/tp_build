ROOT = ./

include $(ROOT)tdp_build/gmake/emcc/common.pri

# Bring in project wide config
include $(ROOT)project.inc
include $(ROOT)$(PROJECT_DIR)/project.conf

include $(ROOT)$(PROJECT_DIR)/submodules.pri

# Bring in the dependencies tree 
include $(PROJECT_DIR)/dependencies.pri
include $(ROOT)tdp_build/gmake/emcc/parse_dependencies.pri

BC = $(addsuffix .bc,$(addprefix $(ROOT)$(BUILD_DIR),$(LIBRARIES)))
JS = $(ROOT)$(BUILD_DIR)$(TARGET).html

all: $(JS)

$(JS): $(BUILD_DIR) $(SUBDIRS) $(BC)
	$(CXX) $(LDFLAGS) $(BC) $(LIBS) -o $@

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

