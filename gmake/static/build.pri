all: $(SUBDIRS)

$(BUILD_DIR): 
	$(MKDIR) $(BUILD_DIR) 

define BUILD_SUBDIR
DEPENDENCIES:=
$(eval -include $(ROOT)$(1)/dependencies.pri)
$(info Target: $(1) Dependencies: $(DEPENDENCIES))
$(1): $(BUILD_DIR) $(DEPENDENCIES) force_look
	cd $(1);$$(MAKE)
endef
$(foreach i,$(SUBDIRS),$(eval $(call BUILD_SUBDIR,$(i))))

install:
	-for d in $(SUBDIRS) ; do (cd $$d; $(MAKE) install ); done

clean:
	-for d in $(SUBDIRS); do (cd $$d; $(MAKE) clean ); done

force_look :
	true
