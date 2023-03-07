ARCHIVES = $(addsuffix .a,$(addprefix $(ROOT)$(BUILD_DIR),$(SUBDIRS)))
ELF = $(TARGET_BUILD_DIR).elf
HEX = $(TARGET_BUILD_DIR).hex
BIN = $(TARGET_BUILD_DIR).bin

all: $(BIN) $(HEX)

$(HEX): $(ELF)
	$(OBJCOPY) -O ihex -R .eeprom $< $@

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

$(ELF): $(BUILD_DIR) $(SUBDIRS) $(ARCHIVES)
	$(CXX) $(LDFLAGS) -Wl,--start-group $(ARCHIVES) $(LIBS) -Wl,--end-group -o $@

$(BUILD_DIR): 
	$(MKDIR) $(BUILD_DIR) 

$(SUBDIRS): force_look
	for d in $@ ; do (cd $$d ; make ) ; done

install:
	-for d in $(SUBDIRS) ; do (cd $$d; $(MAKE) install ); done

clean:
	-for d in $(SUBDIRS); do (cd $$d; $(MAKE) clean ); done

force_look :
	true

