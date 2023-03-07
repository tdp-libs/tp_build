# Bring in the dependencies tree 
include $(ROOT)$(PROJECT_DIR)/dependencies.pri
include $(ROOT)tp_build/gmake/parse_dependencies.pri

BC = $(addsuffix .bc,$(addprefix $(ROOT)$(BUILD_DIR),$(UNIQUE_LIBRARIES)))
HTML = $(TARGET_BUILD_DIR).html
JS_ONLY = $(TARGET_BUILD_DIR).js_only.js
WASM_ONLY = $(TARGET_BUILD_DIR).wasm_only.wasm

all: $(JS_ONLY) $(WASM_ONLY)

js_only: $(JS_ONLY)

wasm_only: $(WASM_ONLY)

$(HTML): $(BUILD_DIR) $(SUBDIRS) force_look
	$(CXX) $(LDFLAGS) $(BC) $(LIBS) -o $@

$(JS_ONLY): $(BUILD_DIR) $(SUBDIRS) force_look
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
