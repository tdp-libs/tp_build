ROOT = ./

TDP_BUILD_TYPE = static
-include $(ROOT)toolchain.pri

define uniq =
  $(eval seen :=)
  $(foreach _,$1,$(if $(filter $_,${seen}),,$(eval seen += $_)))
  ${seen}
endef

PID := $(shell cat /proc/$$$$/status | grep PPid | awk '{print $$2}')
JOBS := $(shell ps -p ${PID} -f | tail -n1 | grep -oP '\-j *\d+' | sed 's/-j//')
ifeq "${JOBS}" ""
JOBS := 1
endif

include $(ROOT)tdp_build/gmake/$(TDP_BUILD_TYPE)/common.pri

# Bring in project wide config
include $(ROOT)project.inc
include $(ROOT)$(PROJECT_DIR)/project.conf

include $(ROOT)$(PROJECT_DIR)/submodules.pri

# Bring in the dependencies tree 
include $(PROJECT_DIR)/dependencies.pri
include $(ROOT)tdp_build/gmake/parse_dependencies.pri

include $(ROOT)tdp_build/gmake/$(TDP_BUILD_TYPE)/build.pri

