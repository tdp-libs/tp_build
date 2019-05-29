PAGES_BUILD_DIRS = $(addprefix $(ROOT)$(BUILD_DIR)$(TARGET)/, $(PAGES))
PAGES_MAKEFILES = $(addsuffix /Makefile, $(PAGES_BUILD_DIRS))

.PHONY: pages
pages: $(PAGES_BUILD_DIRS) $(PAGES_MAKEFILES)
	-for d in $(PAGES_MAKEFILES) ; do (cd `dirname $$d`; $(MAKE)); done

$(ROOT)$(BUILD_DIR)$(TARGET)/%/Makefile: % $(ROOT)tdp_build/gmake/common/template_page_Makefile
	echo "SOURCE_DIR=`realpath $<`/" > $@
	echo "ROOT_DIR=`realpath $(ROOT)`/" >> $@
	echo "BUILD_DIR=`realpath $(ROOT)$(BUILD_DIR)`/" >> $@
	echo "PAGE_NAME=$<" >> $@
	cat $(ROOT)tdp_build/gmake/common/template_page_Makefile >> $@

$(PAGES_BUILD_DIRS):
	$(MKDIR) $@

