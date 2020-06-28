PAGES_BUILD_DIRS = $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/, $(PAGES))
PAGES_MAKEFILES = $(addsuffix /Makefile, $(PAGES_BUILD_DIRS))
PAGES_MAKETARGETS = $(addsuffix /make, $(PAGES_BUILD_DIRS))

ifeq ($(ROOT_URL),)
ROOT_URL = $(ROOT)$(BUILD_DIR)pages/
endif
export ROOT_URL

pages: $(PAGES_BUILD_DIRS) $(PAGES_MAKEFILES) $(PAGES_MAKETARGETS)
#	-for d in $(PAGES_MAKEFILES) ; do (cd `dirname $$d`; $(MAKE)); done

.PHONY: $(PAGES_MAKETARGETS)
$(PAGES_MAKETARGETS):
	cd `dirname $@` && $(MAKE)

$(ROOT)$(BUILD_DIR)$(TARGET)/%/Makefile: % $(ROOT)tp_build/gmake/common/template_page_Makefile
	echo "SOURCE_DIR=`realpath $<`/" > $@
	echo "ROOT_DIR=`realpath $(ROOT)`/" >> $@
	echo "BUILD_DIR=`realpath $(ROOT)$(BUILD_DIR)`/" >> $@
	echo "PAGE_NAME=$<" >> $@
	cat $(ROOT)tp_build/gmake/common/template_page_Makefile >> $@

$(PAGES_BUILD_DIRS):
	$(MKDIR) $@

