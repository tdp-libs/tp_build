
DEPENDENCIES_ := $(foreach DEPENDENCY,$(DEPENDENCIES),$(ROOT)$(DEPENDENCY)/dependencies.pri)
DEPENDENCIES = 
include $(DEPENDENCIES_)

DEPENDENCIES_ := $(foreach DEPENDENCY,$(DEPENDENCIES),$(ROOT)$(DEPENDENCY)/dependencies.pri)
DEPENDENCIES = 
include $(DEPENDENCIES_)

DEPENDENCIES_ := $(foreach DEPENDENCY,$(DEPENDENCIES),$(ROOT)$(DEPENDENCY)/dependencies.pri)
DEPENDENCIES = 
include $(DEPENDENCIES_)

DEPENDENCIES_ := $(foreach DEPENDENCY,$(DEPENDENCIES),$(ROOT)$(DEPENDENCY)/dependencies.pri)
DEPENDENCIES = 
include $(DEPENDENCIES_)

DEPENDENCIES_ := $(foreach DEPENDENCY,$(DEPENDENCIES),$(ROOT)$(DEPENDENCY)/dependencies.pri)
DEPENDENCIES = 
include $(DEPENDENCIES_)

DEPENDENCIES_ := $(foreach DEPENDENCY,$(DEPENDENCIES),$(ROOT)$(DEPENDENCY)/dependencies.pri)
DEPENDENCIES = 
include $(DEPENDENCIES_)

DEPENDENCIES_ := $(foreach DEPENDENCY,$(DEPENDENCIES),$(ROOT)$(DEPENDENCY)/dependencies.pri)
DEPENDENCIES = 
include $(DEPENDENCIES_)

define uniq =
  $(eval seen :=)
  $(foreach _,$1,$(if $(filter $_,${seen}),,$(eval seen += $_)))
  ${seen}
endef

UNIQUE_LIBRARIES = $(call uniq,$(LIBRARIES))
