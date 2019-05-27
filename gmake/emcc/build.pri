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

