# Bring in the dependencies tree 
include $(ROOT)$(PROJECT_DIR)/dependencies.pri
include $(ROOT)tp_build/gmake/parse_dependencies.pri

BC = $(addsuffix .bc,$(addprefix $(ROOT)$(BUILD_DIR),$(UNIQUE_LIBRARIES)))
JS = $(ROOT)$(BUILD_DIR)$(TARGET).js
WASM_ONLY = $(ROOT)$(BUILD_DIR)$(TARGET).wasm_only.wasm

all: $(JS)

wasm_only: $(WASM_ONLY)

$(JS): $(BUILD_DIR) $(SUBDIRS) force_look
	$(CXX) $(LDFLAGS) $(BC) $(LIBS) -o $@

$(WASM_ONLY): $(BUILD_DIR) $(SUBDIRS) force_look
	$(CXX) $(LDFLAGS) $(BC) $(LIBS) -o $@

$(BUILD_DIR): 
	$(MKDIR) $(BUILD_DIR) 

$(SUBDIRS): force_look
	for d in $@ ; do (cd $$d ; $(MAKE) ) ; done

install:
	-for d in $(SUBDIRS) ; do (cd $$d; $(MAKE) install ); done

clean:
	-for d in $(SUBDIRS); do (cd $$d; $(MAKE) clean ); done

force_look :
	true
