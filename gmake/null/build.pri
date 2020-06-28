UNIQUE_LIBRARIES = $(call uniq,$(LIBRARIES))

SUB_AR = $(addsuffix .a,$(addprefix $(ROOT)$(BUILD_DIR),$(UNIQUE_LIBRARIES)))
PUB_AR = $(ROOT)$(BUILD_DIR)lib$(PUB_TARGET).a
PUB_O  = $(ROOT)$(BUILD_DIR)$(PUB_TARGET).o

OBJ_DIR = $(ROOT)$(BUILD_DIR)/obj/

#All must be the first target in the makefile
.PHONY: all
all: $(BUILD_DIR) $(SUBDIRS)

$(PUB_AR): $(BUILD_DIR) $(SUBDIRS) $(SUB_AR)
	"$(LD)" --whole-archive -r $(SUB_AR) -o $(PUB_O)
	"$(AR)" rcs $@ $(PUB_O)

$(BUILD_DIR): 
	$(MKDIR) $(BUILD_DIR) 

.PHONY: force_look
$(SUBDIRS): force_look
	for d in $@ ; do (cd $$d ; make  ) ; done

install:
	-for d in $(SUBDIRS) ; do (cd $$d; $(MAKE) install ); done

clean:
	-for d in $(SUBDIRS); do (cd $$d; $(MAKE) clean ); done

